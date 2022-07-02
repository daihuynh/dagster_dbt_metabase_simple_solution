{% snapshot ss_total_films %}

 {{
    config(
        strategy='check',
        target_schema='main_etl',
        unique_key='release_year',
        check_cols=['total'],
    )
}}

SELECT release_year, total
FROM {{ ref('stats_film_by_year') }}

{% endsnapshot %}