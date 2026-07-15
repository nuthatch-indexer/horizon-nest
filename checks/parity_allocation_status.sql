-- Allocation count by current status (active vs closed) after folding Created/Resized/Closed.
SELECT status, count(*) AS n
FROM allocations
GROUP BY status
ORDER BY status;
