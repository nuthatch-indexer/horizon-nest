-- Allocations: current state per allocation, folding Created / Resized / Closed into one row.
-- Each event contributes (allocationId, indexer, tokens, status); the latest event wins. Token
-- amounts use the `*_dec` DECIMAL(38) columns nuthatch derives for uint256 columns, so they sum
-- and compare as numbers. `allocation_events` is the shared spine the indexer/global views reuse.
CREATE VIEW allocation_events AS
  SELECT "allocationId", "indexer", "subgraphDeploymentId",
         "tokens_dec"    AS tokens, 'active' AS status, block_number, log_index
  FROM "service__allocation_created"
  UNION ALL
  SELECT "allocationId", "indexer", "subgraphDeploymentId",
         "newTokens_dec" AS tokens, 'active' AS status, block_number, log_index
  FROM "service__allocation_resized"
  UNION ALL
  SELECT "allocationId", "indexer", "subgraphDeploymentId",
         "tokens_dec"    AS tokens, 'closed' AS status, block_number, log_index
  FROM "service__allocation_closed";

CREATE VIEW allocations AS
SELECT "allocationId", "indexer", "subgraphDeploymentId", tokens, status
FROM (
  SELECT *,
         row_number() OVER (
           PARTITION BY "allocationId"
           ORDER BY block_number DESC, log_index DESC
         ) AS rn
  FROM allocation_events
)
WHERE rn = 1;
