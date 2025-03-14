{{
    config(
        materialized="view",
        snowflake_warehouse="BASE",
        database="base",
        schema="raw",
        alias="ez_bridge_transfers",
    )
}}


select 
    block_timestamp,
    tx_hash as ethereum_tx_hash,
    event_index,
    depositor as source_address,
    recipient as destination_address,
    amount,
    token_address as ethereum_token_address,
    source_chain,
    destination_chain
from {{ref('fact_base_bridge_transfers')}}