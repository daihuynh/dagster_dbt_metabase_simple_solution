SELECT *
FROM {{ source('main', 'films') }}
WHERE isAdult <= 1 -- Corrupted data
    AND startYear <> '\N'
    AND CAST(startYear  AS INTEGER) <= CAST(strftime('%Y', 'now') AS INTEGER) -- no future films
    AND genres <> '\N' -- no non-genre films