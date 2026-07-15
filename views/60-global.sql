-- One-row network totals over the derived views above.
CREATE VIEW global AS
SELECT
  (SELECT count(*) FROM allocations WHERE status = 'active')          AS active_allocations,
  (SELECT count(DISTINCT "indexer") FROM allocation_events)           AS indexers,
  (SELECT count(*) FROM delegations)                                  AS active_delegations,
  (SELECT COALESCE(SUM("tokensRewards_dec"), 0)::VARCHAR
     FROM "service__indexing_rewards_collected")                      AS total_indexing_rewards,
  (SELECT COALESCE(SUM("tokensCollected_dec"), 0)::VARCHAR
     FROM "service__query_fees_collected")                            AS total_query_fees;
