-- Uniswap V3 日交易量查询
-- 计算每个池子过去7天的交易量、交易次数、独立交易地址数
-- Dune SQL V2

WITH swap_volume AS (
  SELECT
    DATE_TRUNC('day', evt_block_time) AS day,
    contract_address AS pool,
    COUNT(*) AS swap_count,
    SUM(amountUSD) AS volume_usd,
    COUNT(DISTINCT sender) AS unique_traders
  FROM uniswap_v3_ethereum.Pair_evt_Swap
  WHERE evt_block_time >= CURRENT_DATE - INTERVAL '7' DAY
  GROUP BY 1, 2
),
pool_names AS (
  SELECT
    pool,
    token0,
    token1,
    CONCAT(token0_symbol, '/', token1_symbol, ' ', fee / 10000, 'bps') AS pool_label
  FROM uniswap_v3_ethereum.Factory_evt_PoolCreated
)
SELECT
  v.day,
  p.pool_label,
  v.swap_count,
  ROUND(v.volume_usd, 2) AS volume_usd,
  v.unique_traders
FROM swap_volume v
LEFT JOIN pool_names p ON v.pool = p.pool
ORDER BY v.day DESC, v.volume_usd DESC;
