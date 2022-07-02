WITH InvolvedFilms AS (
    SELECT plot_id, COUNT(*) AS film_count
    FROM {{ ref('fact_film_plots') }}
    GROUP BY plot_id
), Roles AS (
    SELECT plot_id, COALESCE(COUNT(*), 0) AS roles
    FROM {{ ref('fact_plot_roles') }}
    GROUP BY plot_id
), FilmRatings AS (
    SELECT fp.film_id, fp.plot_id
        , COALESCE(r.averageRating, 0) AS rating
        , COALESCE(r.numVotes, 0) AS votes
    FROM {{ ref('fact_film_plots') }} fp
    LEFT JOIN {{ ref('valid_ratings') }} r ON r.tconst = fp.film_id
), PlotRatingStats AS (
    SELECT plot_id
        , MIN(rating) AS lowest_rating_film
        , MAX(rating) AS highest_rating_film
        , MIN(votes) AS lowest_votes
        , MAX(votes) AS highest_votes
    FROM FilmRatings
    GROUP BY plot_id
)
SELECT p.plot_id
    , CAST(iflm.film_count AS INTEGER) AS film_count
    , CAST(r.roles AS INTEGER) AS roles
    , CAST(prs.lowest_rating_film AS REAL) AS lowest_rating_film
    , CAST(prs.highest_rating_film AS REAL) AS highest_rating_film
    , CAST(prs.lowest_votes AS INTEGER) AS lowest_votes
    , CAST(prs.highest_votes AS INTEGER) AS highest_votes
FROM {{ ref('dim_plots') }} p
LEFT JOIN InvolvedFilms iflm ON iflm.plot_id = p.plot_id
LEFT JOIN Roles r ON r.plot_id = p.plot_id
LEFT JOIN PlotRatingStats prs ON prs.plot_id = p.plot_id