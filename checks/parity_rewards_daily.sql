-- Daily indexing-reward totals — the aggregation a dashboard panel reads.
SELECT day, rewards
FROM rewards_daily
ORDER BY day;
