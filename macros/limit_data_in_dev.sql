  {% macro limit_data_in_dev(column_name, days_of_data = 3) %}
  
  {% if target.name == 'dev' %}

  {{ column_name }} >= dateadd('day', -{{ days_of_data }}, current_timestamp)

  {% endif %}

  {% endmacro %}
