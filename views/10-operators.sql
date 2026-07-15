-- Operators: the current operator authorisations, from the latest OperatorSet per
-- (serviceProvider, verifier, operator). `allowed` is the live state; we keep only the ones
-- currently authorised. Latest-event-wins by (block_number, log_index).
CREATE VIEW operators AS
SELECT "serviceProvider", "verifier", "operator"
FROM (
  SELECT *,
         row_number() OVER (
           PARTITION BY "serviceProvider", "verifier", "operator"
           ORDER BY block_number DESC, log_index DESC
         ) AS rn
  FROM "staking__operator_set"
)
WHERE rn = 1 AND lower("allowed") = 'true';
