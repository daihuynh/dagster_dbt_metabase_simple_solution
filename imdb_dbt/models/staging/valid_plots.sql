SELECT *
FROM {{ source('main', 'plots') }} 
WHERE knownForTitles != '\N'