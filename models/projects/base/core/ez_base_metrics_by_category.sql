-- depends_on {{ ref("ez_base_transactions") }}
{{
    config(
        materialized="table",
        snowflake_warehouse="base",
        database="base",
        schema="core",
        alias="ez_metrics_by_category",
    )
}}

{{ get_fundamental_data_for_chain_by_category("base") }}
