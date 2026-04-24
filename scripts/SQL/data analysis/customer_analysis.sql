/* =========================
   Customer Analysis - BANKING
   GOLD LAYER ANALYTICS
========================= */

-- 1. Active customer
SELECT
	COUNT(DISTINCT account_id) AS active_customer
FROM gold.fact_transaction;

-- Average transactions and amount per customer
SELECT 
	account_id,
	CAST(COUNT(*) AS FLOAT) / COUNT(DISTINCT account_id) AS avg_transaction_per_customer,
	CAST(SUM(amount) AS FLOAT) / COUNT(DISTINCT account_id) AS avg_amount_per_customer
FROM gold.fact_transaction
GROUP BY account_id;

-- 2. Spending vs Income per Customer
SELECT
	account_id,
	total_income,
	total_withdrawal,
	total_income - total_withdrawal AS net_cash_flow
FROM
	(SELECT
		account_id,
		SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
		SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_withdrawal
	FROM gold.fact_transaction
	GROUP BY account_id)t

-- 3. Risk Analytics
SELECT
	account_id,
	spending_income_ratio,
	CASE WHEN spending_income_ratio BETWEEN 0.8 AND 1.3 THEN 'paycheck to paycheck'
		 WHEN spending_income_ratio > 1.3 THEN 'risky'
		 WHEN spending_income_ratio < 0.8 THEN 'low spender'
	END AS status
FROM
(SELECT 
	account_id,
	SUM(CASE WHEN transaction_type = 'Spending' OR transaction_type = 'Withdrawal' THEN amount ELSE 0 END)/
	NULLIF(SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END), 0)
	AS spending_income_ratio
FROM gold.fact_transaction
GROUP BY account_id)t;

-- 4. Customer Segmentation
SELECT 
    account_id,
    CASE 
        WHEN SUM(CASE WHEN transaction_type = 'Withdrawal' OR transaction_type = 'Spending' THEN amount ELSE 0 END) > 100000 THEN 'High Spender'
        WHEN SUM(CASE WHEN transaction_type = 'Withdrawal' OR transaction_type = 'Spending' THEN amount ELSE 0 END) BETWEEN 50000 AND 100000 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS spending_segment
FROM gold.fact_transaction
GROUP BY account_id;

-- 5. Top income customers
SELECT TOP 10
    account_id,
    SUM(amount) AS total_income
FROM gold.fact_transaction
WHERE transaction_type = 'Income'
GROUP BY account_id
ORDER BY total_income DESC;


-- 6. Top spending customers
SELECT TOP 10
    account_id,
    SUM(amount) AS total_spending
FROM gold.fact_transaction
WHERE transaction_type = 'Withdrawal'
GROUP BY account_id
ORDER BY total_spending DESC;

-- 7. Customer activity
SELECT
    t.account_id,
    c.gender,
    SUM(t.amount) AS total_amount
FROM gold.fact_transaction t
JOIN gold.dim_account a 
    ON t.account_id = a.account_id
JOIN gold.dim_disp d 
    ON a.account_id = d.account_id
JOIN gold.dim_client c 
    ON d.client_id = c.client_id
WHERE d.disposition_type = 'OWNER'
GROUP BY t.account_id, c.gender
ORDER BY total_amount DESC;

-- 8. Customer by Geography
SELECT
	c.district_id,
	d.district_name,
	COUNT(*) AS total_customers
FROM gold.dim_client c
LEFT JOIN gold.dim_district d
ON c.district_id = d.district_id
GROUP BY c.district_id, d.district_name