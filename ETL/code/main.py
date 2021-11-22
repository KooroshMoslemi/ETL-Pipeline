from util.database import Database
from util.pipeline import Pipeline


if __name__ == '__main__':
    src_db = Database(db_name = "library" , user="postgres" , password = "123456")
    target_db = Database(db_name = "library_warehouse" , user="postgres" , password = "123456",versioning = True)

    pipe = Pipeline(src_db,target_db,False)
    pipe.run()