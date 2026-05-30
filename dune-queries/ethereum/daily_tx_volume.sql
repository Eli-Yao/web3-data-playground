-- 示例: 以太坊每日交易量趋势
-- Dune SQL V2 (Dune Engine v2)

WITH daily_tx AS (
  SELECT
    DATE_TRUNC('day', block_time) AS day,
    COUNT(*) AS tx_count,
    COUNT(DISTINCT "from") AS unique_senders,
    COUNT(DISTINCT "to") AS unique_receivers,
    SUM(gas_used * gas_price / 1e18) AS total_fee_eth
  FROM ethereum.transactions
  WHERE block_time >= NOW() - INTERVAL '30' DAY
  GROUP BY 1
  ORDER BY 1
)
SELECT
  day,
  tx_count,
  unique_senders,
  unique_receivers,
  ROUND(total_fee_eth, 2) AS total_fee_eth
FROM daily_tx
ORDER BY day DESC;
