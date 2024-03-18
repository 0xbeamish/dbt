{{ config(materialized="table", snowflake_warehouse="UNISWAP_SM") }}
with
    all_metrics as (
        select
            t1.date,
            t1.chain,
            'uniswap' as app,
            t1.category,
            coalesce(t1.tvl, 0) as tvl,
            coalesce(t2.unique_traders, 0) as unique_traders,
            coalesce(t3.trading_volume, 0) as trading_volume,
            coalesce(t3.fees, 0) as fees
        from {{ ref("fact_uniswap_v3_tvl_arbitrum") }} t1
        full outer join
            {{ ref("fact_uniswap_v3_unique_traders_arbitrum") }} t2 on t1.date = t2.date
        full outer join
            {{ ref("fact_uniswap_v3_trading_vol_and_fees_arbitrum") }} t3
            on t1.date = t3.date
    )
select date, chain, app, category, tvl, unique_traders, trading_volume, fees
from all_metrics
