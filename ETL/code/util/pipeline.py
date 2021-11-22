from util.database import Database
from util.query_loader import QueryLoader
from util.config import *


class Pipeline:
    
    def __init__(self,src_db ,target_db,constructive=True):
        if src_db.versioning == True:
            raise RuntimeError("You can only enable versioning in the target database!")
        self.src_db = src_db
        self.target_db = target_db
        self.constructive = constructive
        self.ql = QueryLoader()
        self.versioning = target_db.versioning

    def run(self):
        print('Pipeline started...')
        if self.constructive:
            self.target_db.construct(self.src_db)
        else:
            self.target_db.constructed = True
            self._handleDiff()
        print('Pipeline finished successfully!')

    def _handleDiff(self):

        schema, top_order = self.src_db.extract()
        insert_cnt = 0
        delete_cnt = 0
        update_cnt = 0
        
        # handle Insertions
        for table_name in top_order:
            pks = ",".join(schema[table_name].pks)
            src_rows = self.src_db.fetchTableRowsId(table_name,pks)
            target_rows = self.target_db.fetchTableRowsId(table_name,pks)
            inserting_rows = src_rows.difference(target_rows)
            insert_cnt += len(inserting_rows)

            for row_pks in inserting_rows:
                conditions = ['%s = %%s' % pk for pk in schema[table_name].pks]
                row = self.src_db.fetchSingleRowConditional(table_name,conditions,row_pks)

                cols_name = [col[0] for col in schema[table_name].cols]
                self.target_db.insertIntoTable(table_name,cols_name,row)

        # handle Removals
        for table_name in reversed(top_order):
            pks = ",".join(schema[table_name].pks)
            src_rows = self.src_db.fetchTableRowsId(table_name,pks)
            target_rows = self.target_db.fetchTableRowsId(table_name,pks)
            deleting_rows = target_rows.difference(src_rows)
            delete_cnt += len(deleting_rows)

            for row_pks in deleting_rows:
                conditions = ['%s = %%s' % pk for pk in schema[table_name].pks]
                self.target_db.deleteRowsConditional(table_name,conditions,row_pks)

        # handle Updates
        for table_name in reversed(top_order):
            pks = ",".join(schema[table_name].pks)
            src_db_pks = self.src_db.fetchTableRowsId(table_name,pks)
            
            for row_pks in src_db_pks:
                conditions = ['%s = %%s' % pk for pk in schema[table_name].pks]
                src_row = self.src_db.fetchSingleRowConditional(table_name,conditions,row_pks)
                target_row = self.target_db.fetchSingleRowConditional(table_name,conditions,row_pks)

                if src_row != target_row:
                    update_cnt += 1
                    update_sets = ['%s = %%s' % col[0] for col in schema[table_name].cols]
                    self.target_db.updateRowsConditional(table_name,conditions,update_sets,row_pks,src_row)


        print(f'+{insert_cnt},-{delete_cnt},~{update_cnt}')


