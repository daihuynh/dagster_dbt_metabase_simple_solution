WITH RECURSIVE GenreList(release_year, genre, rest, round) AS (
    SELECT startYear, genres, genres || ',', 1
    FROM (SELECT startYear, genres FROM {{ ref('valid_films') }} )
    UNION ALL
    SELECT release_year
        , substr(rest, 0, instr(rest, ','))
        , substr(rest, instr(rest, ',')+1)
        , round + 1
    FROM GenreList
    WHERE genre <> ''
), GenresById AS (
	SELECT release_year, genre 
	FROM GenreList
	WHERE genre <> '' AND round > 1
), Stats AS (
	SELECT release_year, genre, COUNT(*) as cnt
	FROM GenresById
	GROUP BY release_year, genre
)
SELECT release_year, COUNT(*) AS genres
FROM Stats
GROUP BY release_year