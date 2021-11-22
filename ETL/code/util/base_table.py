
class BaseTable():
    

    def __init__(self,name):
        self.name = f'"{name}"'
        self.cols = []
        self.pks = []
        self.fks = []
        self.count = 0


    def addColumn(self, name, dtype, nullable, max_len_char=None):
        self.cols.append((f'"{name}"', dtype, nullable, max_len_char))

    def addPk(self, pk):
        self.pks.append(f'"{pk}"')

    def addFk(self, name, column, ref_table, ref_col):
        self.fks.append((name, f'"{column}"', f'"{ref_table}"', f'"{ref_col}"'))

    def setCount(self, count):
        self.count = count

    def generateQuery(self):
        pass
    
