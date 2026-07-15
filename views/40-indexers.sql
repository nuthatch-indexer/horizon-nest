-- Per-indexer totals: indexing rewards, query fees, and active allocation count. Rewards and fees
-- are summed from the collection events (uint256 → `*_dec`); the active-allocation count comes from
-- the folded `allocations` view (§20). Left joins so an indexer with rewards but no open allocation
-- (or vice-versa) still appears.
CREATE VIEW indexer_rewards AS
SELECT "indexer", SUM("tokensRewards_dec")::VARCHAR AS rewards
FROM "service__indexing_rewards_collected" GROUP BY "indexer";

CREATE VIEW indexer_query_fees AS
SELECT "serviceProvider" AS "indexer", SUM("tokensCollected_dec")::VARCHAR AS query_fees
FROM "service__query_fees_collected" GROUP BY "serviceProvider";

CREATE VIEW indexers AS
SELECT
  i."indexer",
  COALESCE(r.rewards, '0')            AS rewards,
  COALESCE(f.query_fees, '0')         AS query_fees,
  COALESCE(a.active_allocations, 0)   AS active_allocations
FROM (SELECT DISTINCT "indexer" FROM allocation_events) i
LEFT JOIN indexer_rewards r    ON r."indexer" = i."indexer"
LEFT JOIN indexer_query_fees f ON f."indexer" = i."indexer"
LEFT JOIN (
  SELECT "indexer", count(*) AS active_allocations
  FROM allocations WHERE status = 'active' GROUP BY "indexer"
) a ON a."indexer" = i."indexer";
