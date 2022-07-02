{% macro create_index(columns) %}

{{ log("Create index") }}
{{ log("Create index for " ~ this) }}

CREATE INDEX 
  idx_{{ this.name }}__on_{{ columns|join('_') }}
  ON {{ this.name }} ({{  columns|join(',')  }})

{% endmacro %}