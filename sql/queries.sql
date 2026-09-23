-- 1. Transaction count and total value by status and day
SELECT 
    DATE(created_at) AS txn_date,
    status,
    COUNT(*) AS total_count,
    SUM(amount) AS total_value
FROM transactions
GROUP BY DATE(created_at), status
ORDER BY txn_date DESC;

-- 2. Top 10 customers by successful transaction value
SELECT 
    c.id AS customer_id,
    c.name,
    c.email,
    SUM(t.amount) AS total_spent
FROM customers c
JOIN transactions t ON c.id = t.customer_id
WHERE t.status = 'SUCCESS'
GROUP BY c.id, c.name, c.email
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Transactions stuck in PROCESSING for > 15 minutes
SELECT 
    reference,
    customer_id,
    amount,
    status,
    created_at,
    NOW() - created_at AS pending_duration
FROM transactions
WHERE status = 'PROCESSING'
  AND created_at < NOW() - INTERVAL '15 minutes';

-- 4. Duplicate transaction references
SELECT 
    reference,
    COUNT(*) AS occurrence_count
FROM transactions
GROUP BY reference
HAVING COUNT(*) > 1;

-- 5. Daily success rate percentage
SELECT 
    DATE(created_at) AS txn_date,
    COUNT(*) AS total_transactions,
    COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END) AS successful_transactions,
    ROUND(
        (COUNT(CASE WHEN status = 'SUCCESS' THEN 1 END)::DECIMAL / COUNT(*)) * 100, 2
    ) AS success_rate_percentage
FROM transactions
GROUP BY DATE(created_at);

-- 6. Reconciliation: Successful transactions vs Callback Success
SELECT 
    t.reference AS txn_reference,
    t.status AS txn_status,
    t.amount AS txn_amount,
    c.status AS callback_status
FROM transactions t
LEFT JOIN callbacks c ON t.reference = c.transaction_reference
WHERE t.status = 'SUCCESS' 
  AND (c.status IS NULL OR c.status != 'SUCCESS');

-- 7. Average and p95 processing time
SELECT 
    AVG(EXTRACT(EPOCH FROM (updated_at - created_at))) AS avg_processing_seconds,
    PERCENTILE_CONT(0.95) WITHIN GROUP (
        ORDER BY EXTRACT(EPOCH FROM (updated_at - created_at))
    ) AS p95_processing_seconds
FROM transactions
WHERE status IN ('SUCCESS', 'FAILED');
