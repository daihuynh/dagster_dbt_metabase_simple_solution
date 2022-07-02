{% test uniqueness(model, column) %}

SELECT {{column}}, COUNT(*) AS cnt
FROM {{ model }}
GROUP BY {{ column }}
HAVING COUNT(*) > 1

{% endtest %}