# Query Performance Tuning & Optimization Analysis

## Scenario
The query fetching pending `PROCESSING` transactions older than 15 minutes was performing a full sequential table scan (`Seq Scan`) across high-volume transaction datasets.

## 1. Unoptimized Query Execution Plan
```sql
EXPLAIN ANALYZE 
SELECT reference, customer_id, amount 
FROM transactions 
WHERE status = 'PROCESSING' 
  AND created_at < NOW() - INTERVAL '15 minutes';
```

### Before Optimization Plan Output:
```text
Seq Scan on transactions  (cost=0.00..35.50 rows=5 width=48) (actual time=0.035..0.089 rows=2 loops=1)
  Filter: (((status)::text = 'PROCESSING'::text) AND (created_at < (now() - '00:15:00'::interval)))
Planning Time: 0.120 ms
Execution Time: 0.110 ms
```

---

## 2. Optimization Strategy & Composite Index Creation
We introduced a composite index covering both filtering criteria (`status` and `created_at`):

```sql
CREATE INDEX idx_transactions_status_created 
ON transactions(status, created_at);
```

---

## 3. Optimized Query Execution Plan

### After Optimization Plan Output:
```text
Index Scan using idx_transactions_status_created on transactions  (cost=0.15..8.17 rows=5 width=48) (actual time=0.012..0.020 rows=2 loops=1)
  Index Cond: (((status)::text = 'PROCESSING'::text) AND (created_at < (now() - '00:15:00'::interval)))
Planning Time: 0.085 ms
Execution Time: 0.031 ms
```

## Engineering Summary
- **Execution Time Reduction:** Reduced scan overhead from sequential disk lookup to an Index Scan tree walk (~70% execution time improvement).
- **Scalability:** Prevents total I/O bottleneck when the `transactions` table scales to millions of rows in production environments.
