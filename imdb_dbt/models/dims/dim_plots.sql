
SELECT nconst AS plot_id
    , primaryName AS plot_name
    , CASE
        WHEN birthYear <> '\N' AND deathYear = '\N' THEN CAST(strftime('%Y', 'now') AS INTEGER) - CAST(birthYear AS INTEGER)
        WHEN birthYear <> '\N' AND deathYear <> '\N' THEN CAST(deathYear AS INTEGER) - CAST(birthYear AS INTEGER)
        ELSE 'N\A'
    END AS age
    , CASE
        WHEN deathYear = '\N' THEN 'YES'
        ELSE 'NO'
    END AS is_alive
FROM {{ ref('valid_plots') }}