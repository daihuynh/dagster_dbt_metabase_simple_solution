SELECT DISTINCT role AS role
FROM {{ ref('fact_plot_roles') }}