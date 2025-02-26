{{
    config(
        materialized='table',
        snowflake_warehouse='AERODROME',
        database='aerodrome',
        schema='core',
        alias='ez_metrics'
    )
}}

with swap_metrics as (
    SELECT
        date,
        COUNT(DISTINCT sender) as unique_traders,
        COUNT(*) as total_swaps,
        SUM(amount_in_usd) as daily_volume_usd,
        SUM(fee_usd) as daily_fees_usd
    FROM {{ ref('fact_aerodrome_swaps') }}
    GROUP BY date
)
, tvl_metrics as (
    SELECT
        date,
        SUM(token_balance_usd) as tvl_usd
    FROM {{ ref('fact_aerodrome_tvl') }}
    GROUP BY date
)
, date_spine as (
    SELECT
        ds.date
    FROM {{ ref('dim_date_spine') }} ds
    WHERE ds.date
        between (
                    select min(min_date) from (
                        select min(date) as min_date from swap_metrics
                        UNION ALL
                        select min(date) as min_date from tvl_metrics
                    )
                )
        and to_date(sysdate())
)
SELECT
    ds.date,
    sm.unique_traders,
    sm.total_swaps,
    sm.daily_volume_usd,
    sm.daily_fees_usd,
    tm.tvl_usd
FROM date_spine ds
LEFT JOIN swap_metrics sm on sm.date = ds.date
LEFT JOIN tvl_metrics tm on tm.date = ds.date