from dagster import graph

from imdb.ops.file_download import op_download_data_files
from imdb.ops.staging import op_load_raw_files_to_db


@graph
def graph_extract_raw_data():
    op_download_data_files()

    
@graph
def graph_load_to_staging():
    op_load_raw_files_to_db()