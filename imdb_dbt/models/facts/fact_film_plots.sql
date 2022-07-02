{{ 
	config(
		pre_hook="{{ drop_all_indexes() }}"
	) 
}}
WITH RECURSIVE PlotFilmList(id, title, rest, round) AS (
    SELECT nconst, knownForTitles, knownForTitles || ',', 1
    FROM (SELECT nconst, knownForTitles FROM {{ ref('valid_plots') }})
    UNION ALL
    SELECT id
        , substr(rest, 0, instr(rest, ','))
        , substr(rest, instr(rest, ',')+1)
        , round + 1
    FROM PlotFilmList
    WHERE title <> ''
), PlotFilmMap AS (
	SELECT id AS plot_id
		, title AS film_id
	FROM PlotFilmList
	WHERE title <> '' AND round > 1
)
SELECT 
	/* dbt-sqlite is using sqlean's crypto.dll but it doesn't work
	{{ dbt_utils.surrogate_key(['plot_id', 'film_id']) }} AS film_plot_key */
	(plot_id || '-' || film_id) AS film_plot_key
	, *
FROM PlotFilmMap