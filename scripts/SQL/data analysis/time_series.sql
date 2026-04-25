/* =========================
   Time series - BANKING
   GOLD LAYER ANALYTICS
========================= */

-- 1. Monthly trend
SELECT
	YEAR(transaction_date) AS [year],
	DATENAME(MONTH,transaction_date) AS [month],
	COUNT(*) AS total_transaction,
	SUM(amount) AS total_amount
FROM gold.fact_transaction
GROUP BY YEAR(transaction_date), DATENAME(MONTH,transaction_date), MONTH(transaction_date)
ORDER BY [year], MONTH(transaction_date);

-- 2. Income VS Spending 
SELECT 
    YEAR(transaction_date) AS [year],
    DATENAME(MONTH,transaction_date) AS [month],
    SUM(CASE WHEN transaction_type = 'Income' THEN amount ELSE 0 END) AS income,
    SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS spending
FROM gold.fact_transaction
GROUP BY YEAR(transaction_date), MONTH(transaction_date), DATENAME(MONTH,transaction_date)
ORDER BY [year], MONTH(transaction_date);

-- 3. Moving average
SELECT 
    transaction_date,
    SUM(amount) AS daily_amount,
    AVG(SUM(amount)) OVER (
        ORDER BY transaction_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7_days
FROM gold.fact_transaction
GROUP BY transaction_date;
	
-- 4. Growth rate
SELECT 
    year,
    month,
    total_amount,
    LAG(total_amount) OVER (ORDER BY year, month) AS prev_month,
    CAST(
        (total_amount - LAG(total_amount) OVER (ORDER BY year, month)) * 1.0 /
        NULLIF(LAG(total_amount) OVER (ORDER BY year, month),0)
    AS DECIMAL(10,2)) AS growth_rate
FROM (
    SELECT 
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        SUM(amount) AS total_amount
    FROM gold.fact_transaction
    GROUP BY YEAR(transaction_date), MONTH(transaction_date)
)t;

-- 5. Loan trend
SELECT 
    YEAR(term_start_date) AS [year],
    DATENAME(MONTH, term_start_date) AS [month],
    COUNT(*) AS total_loans,
    SUM(amount) AS total_loan_amount
FROM gold.fact_loan
GROUP BY YEAR(term_start_date), MONTH(term_start_date), DATENAME(MONTH, term_start_date)
ORDER BY [year], MONTH(term_start_date);

-- 6. Default trend
SELECT 
    YEAR(term_start_date) AS [year],
    DATENAME(MONTH, term_start_date) AS [month],
    AVG(CASE WHEN loan_quality = 'Bad loan' THEN 1.0 ELSE 0 END) AS default_rate
FROM gold.fact_loan
GROUP BY YEAR(term_start_date), MONTH(term_start_date), DATENAME(MONTH, term_start_date)
ORDER BY [year], MONTH(term_start_date);

-- 7. Customer Activity Over Time
SELECT 
    YEAR(transaction_date) AS [year],
    DATENAME(MONTH, transaction_date) AS [month],
    COUNT(DISTINCT account_id) AS active_customers
FROM gold.fact_transaction
GROUP BY YEAR(transaction_date), MONTH(transaction_date), DATENAME(MONTH, transaction_date) 
