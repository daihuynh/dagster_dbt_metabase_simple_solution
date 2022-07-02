WITH NonAdults AS (
	SELECT startYear AS release_year, COUNT(*) as films
	FROM {{ ref('valid_films') }}
	WHERE isAdult = 0
	GROUP BY startYear
), Adults AS (
	SELECT startYear AS release_year, COUNT(*) as adult_films
	FROM {{ ref('valid_films')  }}
	WHERE isAdult =1
	GROUP BY startYear
), Merged AS (
	SELECT nald.release_year AS year1, nald.films, ald.release_year AS year2, ald.adult_films 
	FROM NonAdults nald
	LEFT JOIN Adults ald ON ald.release_year = nald.release_year
	UNION
	SELECT nald.release_year AS year1, nald.films, ald.release_year AS year2, ald.adult_films
	FROM Adults ald
	LEFT JOIN NonAdults nald ON ald.release_year = nald.release_year
), Stats AS (
	SELECT 
		CASE WHEN year1 IS NULL THEN year2
		ELSE year1
		END AS release_year
		, CASE WHEN adult_films IS NULL THEN 0
			ELSE adult_films
			END AS adult_films
		, films
	FROM Merged
)
SELECT CAST(s.release_year AS INTEGER) AS release_year
	, CAST(s.adult_films AS INTEGER) AS adult_films
	, CAST(s.films AS INTEGER) AS films
    , CAST(g.genres AS TEXT) AS genres
	,CAST((adult_films * 100.0 / films) AS REAL) AS adult_film_pct
	,CAST((adult_films + films) AS REAL) AS total
FROM Stats s
LEFT JOIN {{ ref('genre_by_year') }} g ON g.release_year = s.release_year