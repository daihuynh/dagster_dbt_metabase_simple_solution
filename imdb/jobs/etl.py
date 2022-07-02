from os.path import join

from dagster import job, config_from_files, file_relative_path
from dagster_dbt import dbt_cli_resource, dbt_run_op

from imdb.graphs.etl import graph_extract_raw_data, graph_load_to_staging
from imdb.ops.file_download import op_download_data_files
from imdb.ops.staging import op_load_raw_files_to_db
from imdb.resources.db_connection import dwh_connection

local_job_extract_raw_data = graph_extract_raw_data\
                                .to_job(config=config_from_files(
                                    [
                                        file_relative_path(__file__, join('..', 'configs', 'extraction_local.yml'))
                                    ]
                                ))


local_job_load_to_dwh = graph_load_to_staging\
                                .to_job(
                                    resource_defs={
                                        'db_connection': dwh_connection
                                    },
                                    config=config_from_files(
                                    [
                                        file_relative_path(__file__, join('..', 'configs', 'load_local.yml'))
                                    ]
                                ))


local_dbt_config = dbt_cli_resource.configured({
        'project_dir': 'imdb_dbt',
        'target': 'local'
    })

@job(resource_defs={
    'dbt': local_dbt_config
})
def local_job_transform():
    dbt_run_op()

@job(resource_defs={
    'dbt': local_dbt_config,
    'db_connection': dwh_connection
}, config=config_from_files(
[
    file_relative_path(__file__, join('..', 'configs', 'extraction_local.yml')),
    file_relative_path(__file__, join('..', 'configs', 'load_local.yml'))
]))
def local_job_etl():
    dbt_run_op(start_after=op_load_raw_files_to_db(start=op_download_data_files()))