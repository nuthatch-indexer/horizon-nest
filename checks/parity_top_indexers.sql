-- Top 20 indexers by lifetime indexing rewards. Parity: must match the source subgraph's
-- indexer totals at the pinned block. rewards is a base-units decimal string (GRT * 1e18).
SELECT "indexer", rewards, active_allocations
FROM indexers
ORDER BY CAST(rewards AS HUGEINT) DESC, "indexer"
LIMIT 20;
