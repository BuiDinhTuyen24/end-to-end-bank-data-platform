CREATE OR ALTER PROCEDURE gold.load_gold AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;

    SET @start_time = GETDATE();

    PRINT '=====================================================';
    PRINT 'Loading Gold Layer';
    PRINT '=====================================================';

    -- DIM CLIENT
    PRINT '>> Loading dim_client';
    TRUNCATE TABLE gold.dim_client;

    INSERT INTO gold.dim_client(
        client_id,
        gender,
        birth_date,
        district_id
    )
    SELECT 
        client_id,
        gender,
        birth_date,
        district_id
    FROM silver.client;

    PRINT 'Rows dim_client: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- DIM ACCOUNT
    PRINT '>> Loading dim_account';
    TRUNCATE TABLE gold.dim_account;

    INSERT INTO gold.dim_account(
        account_id,
        district_id,
        frequency,
        account_created_date
    )
    SELECT 
        account_id,
        district_id,
        frequency,
        account_date AS account_created_date
    FROM silver.account;

    PRINT 'Rows dim_account: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- DIM DISTRICT
    PRINT '>> Loading dim_district';
    TRUNCATE TABLE gold.dim_district;

    INSERT INTO gold.dim_district(
        district_id,
        district_name,
        population,
        urban_population_ratio,
        average_salary,
        unemployment_rate_1995,
        unemployment_rate_1996,
        entrepreneurs_per_1000
    )
    SELECT
        district_id,
        district_name,
        population,
        urban_population_ratio,
        average_salary,
        unemployment_rate_1995,
        unemployment_rate_1996,
        entrepreneurs_per_1000
    FROM silver.district;

    PRINT 'Rows dim_district: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- DIM CARD
    PRINT '>> Loading dim_card';
    TRUNCATE TABLE gold.dim_card;

    INSERT INTO gold.dim_card(
        card_id,
        card_type,
        issued_date
    )
    SELECT 
        card_id,
        card_type,
        issued_date
    FROM silver.card;

    PRINT 'Rows dim_card: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- DIM DATE
    PRINT '>> Loading dim_date';
    TRUNCATE TABLE gold.dim_date;

    INSERT INTO gold.dim_date(
        date_id,
        full_date,
        [year],
        [month],
        [day],
        [weekday],
        weekday_name,
        [quarter]
    )
    SELECT 
        CONVERT(INT, FORMAT(full_date, 'yyyyMMdd')) AS date_id,
        full_date,
        YEAR(full_date) AS [year],
        MONTH(full_date) AS [month],
        DAY(full_date) AS [day],
        DATEPART(WEEKDAY, full_date) AS [weekday],
        DATENAME(WEEKDAY, full_date) AS weekday_name,
        DATEPART(QUARTER, full_date) AS [quarter]
    FROM 
        (SELECT transaction_date AS full_date FROM silver.[transaction]
         UNION
         SELECT term_start_date FROM silver.loan) t;

    PRINT 'Rows dim_date: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- FACT TRANSACTION
    PRINT '>> Loading fact_transaction';
    TRUNCATE TABLE gold.fact_transaction;

    INSERT INTO gold.fact_transaction(
        trans_id,
        account_id,
        date_id,
        amount,
        balance,
        transaction_type,
        operation,
        payment_purpose
    )
    SELECT 
        trans_id,
        account_id,
        CONVERT(INT, FORMAT(transaction_date, 'yyyyMMdd')) AS date_id,
        amount,
        balance,
        transaction_type,
        operation,
        payment_purpose
    FROM silver.[transaction];

    PRINT 'Rows fact_transaction: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- FACT LOAN
    PRINT '>> Loading fact_loan';
    TRUNCATE TABLE gold.fact_loan;

    INSERT INTO gold.fact_loan(
        loan_id,
        account_id,
        term_start_date,
        amount,
        duration,
        monthly_payments,
        loan_quality
    )
    SELECT
        loan_id,
        account_id,
        term_start_date,
        amount,
        duration,
        monthly_payments,
        loan_quality
    FROM silver.loan;

    PRINT 'Rows fact_loan: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    -- FACT ORDER
    PRINT '>> Loading fact_order';
    TRUNCATE TABLE gold.fact_order;

    INSERT INTO gold.fact_order(
        order_id,
        account_id,
        destination_bank,
        destination_account,
        amount,
        payment_purpose
    )
    SELECT 
        order_id,
        account_id,
        destination_bank,
        destination_account,
        amount,
        payment_purpose
    FROM silver.[order];

    PRINT 'Rows fact_order: ' + CAST(@@ROWCOUNT AS NVARCHAR);


    SET @end_time = GETDATE();

    PRINT '=====================================================';
    PRINT 'Gold Layer Completed';
    PRINT 'Total time (seconds): ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR);
    PRINT '=====================================================';
END;

EXEC gold.load_gold