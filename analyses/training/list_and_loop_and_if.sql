{%- set foods = ['carrot', 'hotdog', 'cucumber', 'bell pepper'] -%}

{% for food in foods %}

  {%- if food == 'hotdog' -%}
    {%- set food_type = 'snack' -%}
  {%- else %}
    {%- set food_type = 'vegetable' -%}
  {%- endif -%}

  The humble {{ food }} is my favorite {{ food_type }}

{% endfor %}
