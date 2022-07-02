from dagster import schedule

from imdb.jobs.etl import local_job_etl


@schedule(cron_schedule='0 6 * * *', job=local_job_etl, execution_timezone='Australia/Adelaide')
def local_schedule_etl(_context):
    """
    A schedule definition. The schedule runs everyday at 6AM Adelaide time.
    """
    run_config = {}
    return run_config
