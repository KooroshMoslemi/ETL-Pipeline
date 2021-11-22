import psycopg2
import networkx as nx
from util.query_loader import QueryLoader
from util.table import Table
from util.version_table import VersionTable
from util.config import *


class Database:
   

    def __init__(self, db_name = "postgres", host = "localhost", port = 5432, user="", password = "",versioning=False):
        
        self.db_name = db_name
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.connected = False
        self.constructed = False
        self.cursor = None
        self.versioning = versioning
        self.ql = QueryLoader()

        self.connect()


    def connect(self):
        print(f'Connecting to the {self.db_name} database...')
        self.connection = psycopg2.connect(dbname=self.db_name,
                                           host = self.host,
                                           port = self.port,
                                           user = self.user,
                                           password = self.password)
        if self.connection is not None:
            self.connected = True
            self.cursor = self.connection.cursor()
            print('Connection established!')
        else:
            print('Connection failed!')

    def disconnect(self):
        self.connection.close()
        self.connected = False


    def commit(self):
        if self.connected:
            self.connection.commit()
        else:
            print("No connection!")


    def exec(self,query, vars=None):
        self.cursor.execute(query,vars)

    def fetchOne(self):
        return self.cursor.fetchone()

    def fetchAll(self):
        return self.cursor.fetchall()

    def fetchTablesName(self):
        tables_name_query = self.ql.load(CMD_TABLES_NAME)
        self.exec(tables_name_query)
        return [res[0] for res in self.fetchAll()]

    def fetchTableColumns(self,table_name):
        table_columns_query = self.ql.load(CMD_TABLE_COLS,table=table_name)
        self.exec(table_columns_query)
        return self.fetchAll()

    def fetchTableFks(self,table_name):
        table_fks_query = self.ql.load(CMD_TABLE_FKS,table=table_name)
        self.exec(table_fks_query)
        return self.fetchAll()

    def fetchTablePks(self,table_name):
        table_pks_query = self.ql.load(CMD_TABLE_PKS,table=table_name)
        self.exec(table_pks_query)
        return self.fetchAll()


    def fetchTableRowCount(self,table_name):
        table_count_query = self.ql.load(CMD_TABLE_COUNT,table=table_name)
        self.exec(table_count_query)
        return self.fetchOne()[0]

    def fetchAllTableData(self,table_name):
        select_all_query = self.ql.load(CMD_SELECT_ALL,table=table_name)
        self.exec(select_all_query)
        return self.fetchAll()


    def fetchTableRowsId(self,table_name,pks):
        if self.versioning:
            table_name = table_name.strip('"')+"_recent"
        select_ids_query = self.ql.load(CMD_SELECT_IDS,table=table_name,id=pks)
        self.exec(select_ids_query)
        return set(list(self.fetchAll()))

    def fetchSingleRowConditional(self,table_name,conditions,cond_values):
        if self.versioning:
            table_name = table_name.strip('"')+"_recent"
        select_conditional_query = self.ql.load(CMD_SELECT_CONDITIONAL,table=table_name,conditions=" and ".join(conditions))
        self.exec(select_conditional_query,cond_values)
        return self.fetchOne()

    def insertIntoTable(self,table_name,cols_name,tuple_values,lazy=False):
        if self.versioning:
            table_name = table_name.strip('"')+"_recent"
        values_placeholder = ",".join(["%s" for _ in cols_name])
        insert_into_query = self.ql.load(CMD_SINGLE_INSERT,table=table_name,cols_name=",".join(cols_name),cols_value=values_placeholder)
        self.exec(insert_into_query,tuple_values)
        if not lazy:
            self.commit()
        return True

    def deleteRowsConditional(self,table_name,conditions,cond_values,lazy=False):
        if self.versioning:
            table_name = table_name.strip('"')+"_recent"
        delete_conditional_query = self.ql.load(CMD_DELETE_CONDITIONAL,table=table_name,conditions=" and ".join(conditions))
        self.exec(delete_conditional_query,cond_values)
        if not lazy:
            self.commit()
        return True

    def updateRowsConditional(self,table_name,conditions,sets,cond_values,set_values,lazy=False):
        if self.versioning:
            table_name = table_name.strip('"')+"_recent"
        update_conditional_query = self.ql.load(CMD_UPDATE_CONDITIONAL,table=table_name,update_sets=" , ".join(sets),conditions=" and ".join(conditions))
        self.exec(update_conditional_query,set_values + cond_values)
        if not lazy:
            self.commit()
        return True

    def setTime(self,time=None):
        if time == None:
            time = '2021-01-01 00:00:00'
        self.exec(self.ql.load(CMD_SET_TIME,time=time))
        self.commit()

    def calcTopOrder(self):
        dag_query = self.ql.load(CMD_DAG)
        self.exec(dag_query)

        edges = []
        for relation in self.fetchAll():
            edges.append((f'"{relation[1]}"',f'"{relation[0]}"'))
        dag = nx.DiGraph(edges)
        return list(nx.topological_sort(dag))




    def extract(self,versioning_target=False):
        '''
        Extracts Database Schema and Computes Topological Order of DAG
        '''
        schema = {}
        for table_name in self.fetchTablesName():

            if versioning_target:
                t = VersionTable(table_name)
            else:
                t = Table(table_name)

            for col_def in self.fetchTableColumns(table_name):
                t.addColumn(col_def[0] , col_def[1] , col_def[2] != "NO", col_def[3])

            for pk in self.fetchTablePks(table_name):
                t.addPk(pk[0])

            for fk in self.fetchTableFks(table_name):
                t.addFk(fk[0],fk[1],fk[2],fk[3])

            table_name = f'"{table_name}"'
            t.setCount(self.fetchTableRowCount(table_name))

            schema[table_name] = t

        topOrder = self.calcTopOrder()

        return schema,topOrder


    def construct(self,src_db):
        if not self.constructed:

            schema,top_order = src_db.extract(self.versioning)

            if self.versioning:
                self.setTime()
                self.exec(self.ql.load(CMD_CREATE_EXTENTION))
                self.commit()


            for table_name in top_order:
            
                # create table
                self.exec(schema[table_name].generateQuery())
                self.commit()

                # insert data into table
                rows = src_db.fetchAllTableData(table_name)
                for row in rows:
                    cols_name = [col[0] for col in schema[table_name].cols]
                    self.insertIntoTable(table_name,cols_name,row,True)

                self.commit()
        else:
            print("You can construct a database only once!")