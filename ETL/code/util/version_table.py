from util.base_table import BaseTable
from util.table import Table
from util.query_loader import QueryLoader
from util.config import *

class VersionTable(BaseTable):
    '''
    This approach is heavily inspired by the following link:
    https://www.cybertec-postgresql.com/en/implementing-as-of-queries-in-postgresql/
    '''

    def __init__(self,name):
        super().__init__(name)
        self.ql = QueryLoader()


    def addColumn(self, name, dtype, nullable, max_len_char=None):
        super().addColumn(name,dtype,nullable,max_len_char)

    def addPk(self, pk):
        super().addPk(pk)

    def addFk(self, name, column, ref_table, ref_col):
        super().addFk(name,column,ref_table,ref_col)

    def setCount(self, count):
        super().setCount(count)

    def generateQuery(self):

        # Version Table
        query = f'CREATE TABLE {self.name}(\n'

        cols_def = []
        for name,dtype,nullable,max_len_char in self.cols:
            col_def = f'{name} {dtype}' + (f"({max_len_char}) " if max_len_char is not None else " ") + ("NOT NULL" if not nullable else "")
            cols_def.append(col_def)

        cols_def.append("__valid tstzrange")

        exclusion_constraints = []
        for pk in self.pks:
            exclusion_constraints.append(f'{pk} WITH =')
        exclusion_constraints.append("__valid WITH &&")

        query += (",\n".join(cols_def)+",\n"+f"EXCLUDE USING gist ({','.join(exclusion_constraints)})"+"\n);\n")

        # Version Trigger Function
        other_cols = [col_name for col_name,_,_,_ in self.cols if col_name not in self.pks]
        other_cols_value = ','.join([f"NEW.{col}" for col in other_cols])

        conflict_condition = ' or '.join([f"NEW.{pk} <> OLD.{pk}" for pk in self.pks])
        new_id_condition = ' and '.join([f"{pk} = NEW.{pk}" for pk in self.pks])
        old_id_condition = ' and '.join([f"{pk} = OLD.{pk}" for pk in self.pks])

        id_cols = ','.join(self.pks)
        id_cols_value = ','.join([f"NEW.{pk}" for pk in self.pks])
        
        query += "\n" + self.ql.load(CMD_VER_TRI_FUNC,
                              safe_table=self.name.strip('"'),
                              table=self.name,
                              conflict_condition=conflict_condition,
                              new_id_condition=new_id_condition,
                              old_id_condition=old_id_condition,
                              id_cols=id_cols,
                              other_cols=','.join(other_cols),
                              id_cols_value=id_cols_value,
                              other_cols_value=other_cols_value)

        # Recent View
        query += "\n" + self.ql.load(CMD_RECENT_VIEW,
                                     safe_table=self.name.strip('"'),
                                     table=self.name,
                                     cols=','.join(self.pks+other_cols))

        # Historic View
        query += "\n" + self.ql.load(CMD_HISTORIC_VIEW,
                                     safe_table=self.name.strip('"'),
                                     table=self.name,
                                     cols=','.join(self.pks+other_cols))

        # Version Trigger
        query += "\n" + self.ql.load(CMD_VER_TRI,
                                     safe_table=self.name.strip('"'))

        return query



if __name__ == "__main__":
    # Test generateQuery functionality
    t = VersionTable("FakeTable")
    t.addColumn("id","serial",False)
    t.addColumn("isbn","char",False,20)
    t.addPk("id")
    t.addFk("FakeTable_isbn_fkey","isbn","Book","isbn")
    print(t.generateQuery())
    
