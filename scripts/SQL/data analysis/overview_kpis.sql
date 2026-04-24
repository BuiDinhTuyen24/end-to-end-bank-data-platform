/* =========================
   OVERVIEW KPIs - BANKING
   GOLD LAYER ANALYTICS
========================= */
-- ====================================
-- 1. Transacion overview
-- ====================================

-- Total transaction
SELECT
	COUNT(*) AS total_transaction
FROM gold.fact_transaction;

-- Total transaction amount
SELECT 
	SUM(amount) AS total_transaction_amount
FROM gold.fact_transaction;

-- Average transaction amount
SELECT 
	AVG(amount) AS avg_transaction_amount
FROM gold.fact_transaction;

-- Income vs Withdrawal vs Transfer breakdown
SELECT 
	transaction_type,
	COUNT(*) AS total_transaction,
	SUM(amount) AS total_transaction_amount,
	AVG(amount) AS avg_transaction_amount
FROM gold.fact_transaction
GROUP BY transaction_type;

-- Net cash flow
SELECT
	total_income,
	total_withdrawal,
	total_income - total_withdrawal AS net_cash_flow
FROM
	(SELECT 
		SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS total_income,
		SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_withdrawal
	FROM gold.fact_transaction)t

-- Spending by purpose breakdown
SELECT 
    payment_purpose,
    SUM(amount) AS total_spending,
    COUNT(*) AS frequency
FROM gold.fact_transaction
GROUP BY payment_purpose
ORDER BY total_spending DESC;

-- Spending / Income ratio per customer
SELECT 
    account_id,
    SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS spending,
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS income,
    CAST(
        SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END),0)
    AS DECIMAL(10,2)) AS spending_income_ratio
FROM gold.fact_transaction
GROUP BY account_id;