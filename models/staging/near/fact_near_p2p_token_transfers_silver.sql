{{
    config(
        materialized="incremental",
        unique_key=["tx_hash", "index"],
        snowflake_warehouse="NEAR",
    )
}}

{{ p2p_token_transfers("near") }}