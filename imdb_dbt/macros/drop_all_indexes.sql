{% macro drop_all_indexes() %}
    {{ log('Drop' ~ tbl_name) }}
    {% set query %}
        SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = '{{ this }}';
    {% endset %}

    {% set results = run_query(query) %}
    {% if execute %}
    {% set results_list = results.rows %}
    {% else%}
    {% set results_list = [] %}
    {% endif %}

    {% for index in results_list %}
        DROP INDEX {{index}};
    {% endfor %}
{% endmacro%}