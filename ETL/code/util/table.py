from util.base_table import BaseTable

class Table(BaseTable):
    

    def __init__(self,name):
        super().__init__(name)


    def addColumn(self, name, dtype, nullable, max_len_char=None):
        super().addColumn(name,dtype,nullable,max_len_char)

    def addPk(self, pk):
        super().addPk(pk)

    def addFk(self, name, column, ref_table, ref_col):
        super().addFk(name,column,ref_table,ref_col)

    def setCount(self, count):
        super().setCount(count)

    def generateQuery(self):
        
        query = f'CREATE TABLE {self.name}(\n'

        cols_def = []
        for name,dtype,nullable,max_len_char in self.cols:
            col_def = f'{name} {dtype}' + (f"({max_len_char}) " if max_len_char is not None else " ") + ("NOT NULL" if not nullable else "")
            cols_def.append(col_def)

        constraints = []
        constraints.append(f"PRIMARY KEY({','.join(self.pks)})")
        for name,col,ref_table,ref_col in self.fks:
            constraints.append(f'CONSTRAINT {name} FOREIGN KEY ({col}) REFERENCES {ref_table}({ref_col})')

        query += (",\n".join(cols_def)+",\n"+",\n".join(constraints)+"\n);")

        return query


if __name__ == "__main__":
    # Test generateQuery functionality
    t = Table("FakeTable")
    t.addColumn("id","serial",False)
    t.addColumn("isbn","char",False,20)
    t.addPk("id")
    t.addFk("FakeTable_isbn_fkey","isbn","Book","isbn")
    print(t.generateQuery())
    
