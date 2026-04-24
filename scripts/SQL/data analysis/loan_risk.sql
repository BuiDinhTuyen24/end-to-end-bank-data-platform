/* =========================
   Loan Risk - BANKING
   GOLD LAYER ANALYTICS
========================= */

-- 1. Default possible rate
SELECT 
	COUNT(CASE WHEN loan_quality = 'Bad loan' THEN 1 END)*1.0/COUNT(*) AS default_possible_rate
FROM gold.fact_loan;

-- 2. Total Good VS Bad loan
SELECT
	loan_quality,
	COUNT(*) AS total_loans,
	SUM(amount) AS total_amount
FROM gold.fact_loan
GROUP BY loan_quality;

-- 3. Risk by Loan Size
SELECT 
    CASE 
        WHEN amount < 50000 THEN 'Small'
        WHEN amount BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_quality = 'Bad loan' THEN 1 ELSE 0 END) AS total_bad_loans
FROM gold.fact_loan
GROUP BY 
    CASE 
        WHEN amount < 50000 THEN 'Small'
        WHEN amount BETWEEN 50000 AND 150000 THEN 'Medium'
        ELSE 'Large'
    END;

-- 4. Risk by duration
SELECT 
    CAST(duration AS NVARCHAR) + ' months'  AS duration,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_quality = 'Bad loan' THEN 1 ELSE 0 END) AS bad_loans
FROM gold.fact_loan
GROUP BY duration
ORDER BY duration;

-- 5. Loan quality by spending VS income ratio
SELECT 
    l.account_id,
    l.loan_quality,
    SUM(CASE WHEN t.transaction_type = 'Withdrawal' OR t.transaction_type = 'Spending' THEN t.amount ELSE 0 END) * 1.0 /
    NULLIF(SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END),0) AS spending_income_ratio
FROM gold.fact_loan l
JOIN gold.fact_transaction t 
    ON l.account_id = t.account_id
GROUP BY l.account_id, l.loan_quality;

-- 6. Risk by district
SELECT 
    d.district_id,
    COUNT(l.loan_id) AS total_loans,
    SUM(CASE WHEN l.loan_quality = 'Bad loan' THEN 1 ELSE 0 END) AS bad_loans
FROM gold.fact_loan l
JOIN gold.dim_account a ON l.account_id = a.account_id
JOIN gold.dim_district d ON a.district_id = d.district_id
GROUP BY d.district_id;

-- 7. Risk by average salary ranges
SELECT 
    CASE 
        WHEN d.average_salary < 8000 THEN 'Lower than 5000'
        WHEN d.average_salary BETWEEN 8000 AND 10000 THEN 'Between 5000 and 10000'
        ELSE 'Higher than 10000'
    END AS salary_group,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN l.loan_quality = 'Bad loan' THEN 1 ELSE 0 END) AS bad_loans,
    CAST(
        SUM(CASE WHEN l.loan_quality = 'Bad loan' THEN 1 ELSE 0 END) * 1.0 /
        COUNT(*)
    AS DECIMAL(10,2)) AS default_rate
FROM gold.fact_loan l
JOIN gold.dim_account a ON l.account_id = a.account_id
JOIN gold.dim_district d ON a.district_id = d.district_id
GROUP BY 
    CASE 
        WHEN d.average_salary < 8000 THEN 'Lower than 5000'
        WHEN d.average_salary BETWEEN 8000 AND 10000 THEN 'Between 5000 and 10000'
        ELSE 'Higher than 10000'
    END
ORDER BY default_rate DESC;

-- 8. Risk Segmentation
SELECT 
    account_id,
    CASE 
        WHEN ratio > 1 THEN 'High Risk'
        WHEN ratio BETWEEN 0.7 AND 1 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_segment
FROM (
    SELECT 
        l.account_id,
        SUM(CASE WHEN t.transaction_type = 'Withdrawal' OR t.transaction_type = 'Spending' THEN t.amount ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END),0) AS ratio
    FROM gold.fact_loan l
    JOIN gold.fact_transaction t 
        ON l.account_id = t.account_id
    GROUP BY l.account_id
)t;


-- 9. All feature table
SELECT 
    l.account_id,
    l.loan_quality,
    l.amount,
    l.duration,
    AVG(t.amount) AS avg_transaction,
    SUM(CASE WHEN t.transaction_type = 'Income' THEN t.amount ELSE 0 END) AS income,
    SUM(CASE WHEN t.transaction_type = 'Withdrawal' THEN t.amount ELSE 0 END) AS spending
FROM gold.fact_loan l
JOIN gold.fact_transaction t 
    ON l.account_id = t.account_id
GROUP BY l.account_id, l.loan_quality, l.amount, l.duration;