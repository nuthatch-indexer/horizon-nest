-- Time-bucketed rollups, using the implicit `block_timestamp` (unix seconds → DuckDB timestamp).
-- Daily and hourly indexing-reward and query-fee totals — the shape a dashboard panel consumes.
CREATE VIEW rewards_daily AS
SELECT date_trunc('day', to_timestamp(block_timestamp))::VARCHAR AS day,
       SUM("tokensRewards_dec")::VARCHAR AS rewards
FROM "service__indexing_rewards_collected"
GROUP BY 1 ORDER BY 1;

CREATE VIEW query_fees_daily AS
SELECT date_trunc('day', to_timestamp(block_timestamp))::VARCHAR AS day,
       SUM("tokensCollected_dec")::VARCHAR AS query_fees
FROM "service__query_fees_collected"
GROUP BY 1 ORDER BY 1;

CREATE VIEW rewards_hourly AS
SELECT date_trunc('hour', to_timestamp(block_timestamp))::VARCHAR AS hour,
       SUM("tokensRewards_dec")::VARCHAR AS rewards
FROM "service__indexing_rewards_collected"
GROUP BY 1 ORDER BY 1;
