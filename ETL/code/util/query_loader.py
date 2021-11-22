from util.config import *

class QueryLoader:
    '''
    This class uses singleton pattern for better performance
    '''
    _instance = None

    def __new__(cls):
        if cls._instance is None:
            print('Creating QueryLoader object...')
            cls._instance = super(QueryLoader, cls).__new__(cls)

            # initialization
            cls._instance.commands = {}

            with open(CMD_PATH,'r') as f:
                lines = f.readlines()

            key = ""
            for line in lines:
                if len(line.strip()) > 0:
                    if line.startswith('--'):
                        key = line.replace("--","").strip()
                        cls._instance.commands[key] = ""
                    elif key in cls._instance.commands:
                        cls._instance.commands[key] += line

        return cls._instance


    def load(cls, key , **kwargs):
        cmd = cls._instance.commands[key]

        for k in kwargs:
            cmd = cmd.replace("${%s}" % k , str(kwargs[k]))
        return cmd


if __name__ ==  "__main__":
    # Testing singleton functionality
    ql1 = QueryLoader()
    ql2 =QueryLoader()
    print(ql1 is ql2)


