-- mask_email macro
-- Masks an email so only the first 2 characters before @ are visible
-- Usage: {{ mask_email('email_column_name') }}
-- Example: amelia.williams@gmail.com  →  am***@gmail.com

{% macro mask_email(email_column) %}
    regexp_replace(
        {{ email_column }},
        '(^[^@]{2})[^@]+(@.+)',
        '\\1***\\2'
    )
{% endmacro %}
