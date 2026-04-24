/* =========================
   Transaction_flow - BANKING
   GOLD LAYER ANALYTICS
========================= */

-- 1. Monthly Inflow VS Outflow
SELECT 
    YEAR(transaction_date) AS [year],
    DATENAME(MONTH, transaction_date) AS [month],
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS inflow,
    SUM(CASE WHEN transaction_type = 'Withdrawal' OR transaction_type = 'Spending' THEN amount ELSE 0 END) AS outflow,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE -amount END) AS net_flow
FROM gold.fact_transaction
GROUP BY 
    YEAR(transaction_date), 
    MONTH(transaction_date), 
    DATENAME(MONTH, transaction_date)
ORDER BY [year], MONTH(transaction_date);

-- 2. Money Flow by Transaction type
SELECT 
    transaction_type,
    SUM(amount) AS total_amount
FROM gold.fact_transaction
GROUP BY transaction_type;

-- 3. Money Flow by Operation
SELECT 
    operation,
    SUM(amount) AS total_amount,
    COUNT(*) AS frequency
FROM gold.fact_transaction
GROUP BY operation
ORDER BY total_amount DESC;

-- 4. Money Flow by Payment Purpose
SELECT 
    payment_purpose,
    SUM(amount) AS total_amount,
    COUNT(*) AS frequency
FROM gold.fact_transaction
GROUP BY payment_purpose
ORDER BY total_amount DESC;

-- 5. Cumulative Flow
SELECT
    account_id,
    transaction_date,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount
             ELSE -amount 
        END) 
    OVER(PARTITION BY transaction_date ORDER BY account_id) AS cumulative_balance_change
FROM gold.fact_transaction