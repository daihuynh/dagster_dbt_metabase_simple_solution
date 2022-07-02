SELECT flm.film_id
    , averageRating AS average_rating
    , numVotes AS votes
FROM {{ ref('dim_films') }} flm
LEFT JOIN {{ ref('valid_ratings') }} r ON r.tconst = flm.film_id