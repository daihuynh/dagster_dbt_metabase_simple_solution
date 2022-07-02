from dagster import In, Nothing, file_relative_path, op, Field, Array, String
import requests
import os.path
import gzip

@op(config_schema={
    'file_list': Field(Array(String), description='list of file urls'),
    'store_path': Field(String, description='file store location')
})
def op_download_data_files(context):
    context.log.info(context.op_config['file_list'])
    store_path = file_relative_path(__file__, context.op_config['store_path'])

    for url in context.op_config['file_list']:
        file_name = os.path.basename(url)
        basename = os.path.splitext(file_name)[0]
        context.log.info(f'Downloading {file_name}')
        resp = requests.get(url, stream=True)
        context.log.info(f'Unzipping {file_name}')
        tsv = gzip.decompress(resp.content)
        context.log.info(f'Writing {file_name} to file')
        with open(os.path.join(store_path, basename), 'wb') as f:
            f.write(tsv)
        
        context.log.info(f'Done processing {file_name}')
        
