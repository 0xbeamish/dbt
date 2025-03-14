{{
    config(
        materialized="table",
        snowflake_warehouse="BERACHAIN",
        database="berachain",
        schema="core",
        alias="ez_metrics",
    )
}}

with 
     price_data as ({{ get_coingecko_metrics('berachain-bera') }})
select
    f.date
    , txns
    , daa as dau
    , fees_native
    , fees
    -- Market Data
    , price
    , market_cap
    , fdmc
    , token_turnover_circulating
    , token_turnover_fdv
    token_volume
from {{ ref("fact_berachain_fundamental_metrics") }} as f
left join price_data on f.date = price_data.date
where f.date  < to_date(sysdate())
