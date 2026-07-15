-- Delegations: net delegated stake per (indexer, delegator) = Σ(delegated) − Σ(withdrawn), in
-- GRT base units. StakeDelegatedLocked is the thawing step (not a balance change) and is excluded.
-- Rows that net to zero are dropped, matching a "currently delegating" set.
CREATE VIEW delegations AS
SELECT "indexer", "delegator", SUM(delta)::VARCHAR AS tokens
FROM (
  SELECT "indexer", "delegator", "tokens_dec"  AS delta FROM "extension__stake_delegated"
  UNION ALL
  SELECT "indexer", "delegator", -"tokens_dec" AS delta FROM "extension__stake_delegated_withdrawn"
) GROUP BY "indexer", "delegator"
HAVING SUM(delta) <> 0;

-- Active delegator count per indexer.
CREATE VIEW delegators_active AS
SELECT "indexer", count(*) AS delegators
FROM delegations GROUP BY "indexer";
