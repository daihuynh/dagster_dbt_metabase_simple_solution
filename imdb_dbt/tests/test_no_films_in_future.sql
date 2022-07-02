SELECT 1
FROM {{ ref('valid_films') }}
WHERE CAST(startYear AS INTEGER) > CAST(strftime('%Y', 'now') AS INTEGER)