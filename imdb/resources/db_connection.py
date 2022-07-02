from dagster import resource, Field, String, Int
import sqlalchemy

class MariaDBConnection:
    def __init__(self, host:str='localhost', port:int=3306, user:str='root', password:str='', database:str=''):
        self.__host =  host
        self.__port = port
        self.__user = user
        self.__pwd = password
        self.__db = database
    
    def connect(self) -> sqlalchemy.engine.Engine:
        return sqlalchemy.create_engine(f'mariadb+mariadbconnector://{self.__user}:{self.__pwd}@{self.__host}:{self.__port}/{self.__db}')

class SQLiteConnection:
    def __init__(self, db_file:str):
        self.__db_file = db_file
    
    def connect(self) -> sqlalchemy.engine.Engine:
        return sqlalchemy.create_engine(f'sqlite:///{self.__db_file}')

@resource(
    config_schema={
        'db_file': Field(String, description="Local file location")
    }
)
def dwh_connection(init_context):
    # return MariaDBConnection(
    #     host=init_context.resource_config['host'],
    #     port=init_context.resource_config['port'],
    #     user=init_context.resource_config['username'],
    #     password=init_context.resource_config['password'],
    #     database=init_context.resource_config['database']
    # )
    return SQLiteConnection(
        db_file=init_context.resource_config['db_file']
    )