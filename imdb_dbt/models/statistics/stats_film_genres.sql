WITH RECURSIVE GenreList(id, genre, rest, round) AS (
    SELECT tconst, genres, genres || ',', 1
    FROM (SELECT tconst, genres FROM {{ ref('valid_films' )}} WHERE genres != '\N' )
    UNION ALL
    SELECT id
        , substr(rest, 0, instr(rest, ','))
        , substr(rest, instr(rest, ',')+1)
        , round + 1
    FROM GenreList
    WHERE genre <> ''
), GenresById AS (
	SELECT id, genre 
	FROM GenreList
	WHERE genre <> '' AND round > 1
)
SELECT DISTINCT genre
FROM GenresById