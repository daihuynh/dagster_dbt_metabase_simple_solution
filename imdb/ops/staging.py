import chunk
import os
from dagster import Field, In, Nothing, String, Dict, file_relative_path, op
import pandas as pd

@op(config_schema={
    'store_path': Field(String),
    'tables': dict
  },
  required_resource_keys={'db_connection'},
  ins={
    'start': In(Nothing)
  }
)
def op_load_raw_files_to_db(context):
    conn = context.resources.db_connection.connect()
    store_path = file_relative_path(__file__, context.op_config['store_path'])
    context.log.info(context.op_config['tables'])
    tables = context.op_config['tables']
    for k, v in tables.items():
        df = pd.read_csv(os.path.join(store_path, v), encoding='utf-8', delimiter='\t')
        df.to_sql(k, con=conn, index=False, if_exists='replace', chunksize=1000)