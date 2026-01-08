{% macro generate_schema_name(custom_schema_name, node) -%}

    {%- set default_schema = target.schema -%}

    {%- if target.name == 'prod' and custom_schema_name is not none -%}
        {# In production, use only the custom schema (e.g., 'core') #}
        {{ custom_schema_name | trim }}

    {%- elif target.name == 'dev' -%}
        {# In dev, concatenate the target and custom schemas (e.g., 'dbt_matt_core') #}
        {{ default_schema }}_{{ custom_schema_name | trim }}

    {%- else -%}
        {# Fallback to the default target schema if no custom schema is defined #}
        {{ default_schema }}

    {%- endif -%}

{%- endmacro %}
