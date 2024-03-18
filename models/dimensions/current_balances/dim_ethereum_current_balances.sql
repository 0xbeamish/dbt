-- depends_on: {{ ref("fact_ethereum_address_balances_by_token") }}
{{ config(materialized="incremental", unique_key=["address", "contract_address"]) }}


{{ current_balances("ethereum") }}
