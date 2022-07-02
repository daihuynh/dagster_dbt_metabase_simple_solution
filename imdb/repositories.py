from dagster import repository

from imdb.jobs.etl import local_job_etl, local_job_extract_raw_data, local_job_load_to_dwh, local_job_transform
from imdb.schedules.my_hourly_schedule import local_schedule_etl
# from imdb.schedules.my_hourly_schedule import my_hourly_schedule
# from imdb.sensors.my_sensor import my_sensor


@repository
def imdb_local():
    jobs = [local_job_extract_raw_data, 
            local_job_load_to_dwh, 
            local_job_transform, 
            local_job_etl,
            local_schedule_etl]
    # schedules = [my_hourly_schedule]
    # sensors = [my_sensor]

    # return jobs + schedules + sensors
    return jobs

@repository
def imdb_test():
    jobs = [local_job_extract_raw_data]
    # schedules = [my_hourly_schedule]
    # sensors = [my_sensor]

    # return jobs + schedules + sensors
    return jobs