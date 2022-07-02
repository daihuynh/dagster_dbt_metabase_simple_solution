SELECT tconst AS film_id
    , titleType AS title_type
    , primaryTitle AS title
    , CASE
        WHEN primaryTitle <> originalTitle THEN originalTitle
        ELSE ''
    END AS alternative_title
    , (primaryTitle <> originalTitle) AS has_alternative_title
    , CASE
        WHEN isAdult = '1' THEN 'Yes'
        ELSE 'No'
    END AS is_adult
    , startYear AS release_year 
FROM {{ ref('valid_films') }}