CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
	DECLARE @start_time DATETIME,
			@end_time DATETIME,
			@batch_start_time DATETIME,
			@batch_end_time DATETIME,
			@row_count INT;

	SET @batch_start_time = GETDATE();


	-- ACCOUNT
	PRINT 'ACCOUNT';
	TRUNCATE TABLE silver.account;
	SET @start_time = GETDATE();

	INSERT INTO silver.account (
		account_id,
		district_id,
		frequency,
		account_date
	)
	SELECT 
		account_id,
		district_id,
		CASE 
			WHEN frequency = '"POPLATEK TYDNE"' THEN 'Weekly'
			WHEN frequency = '"POPLATEK MESICNE"' THEN 'Monthly'
			WHEN frequency = '"POPLATEK PO OBRATU"' THEN 'Per_Transaction'
		END,
		CONVERT(date, date, 12)
	FROM bronze.account;

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.account;

	PRINT '>> Account rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- CARD
	PRINT 'CARD';
	TRUNCATE TABLE silver.card;
	SET @start_time = GETDATE();

	INSERT INTO silver.card(
		card_id,
		disp_id,
		card_type,
		issued_date
	)
	SELECT 
		card_id,
		disp_id,
		REPLACE(type, '"', ''),
		CONVERT(date, issued, 12)
	FROM bronze.card;

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.card;

	PRINT '>> Card rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- CLIENT
	PRINT 'CLIENT';
	TRUNCATE TABLE silver.client;
	SET @start_time = GETDATE();

	WITH c AS (
		SELECT 
			client_id,
			REPLACE(birth_number, '"', '') AS bn,
			district_id
		FROM bronze.client
	)
	INSERT INTO silver.client(
		client_id,
		gender,
		birth_date,
		district_id
	)
	SELECT
		client_id,
		CASE 
			WHEN CAST(SUBSTRING(bn,3,2) AS INT) > 50 THEN 'Female'
			ELSE 'Male'
		END,
		CONVERT(date,
			CONCAT(
				CASE WHEN LEFT(bn,2) <= '25' THEN '20' ELSE '19' END,
				LEFT(bn,2),
				RIGHT('0' + 
					CAST(
						CASE 
							WHEN CAST(SUBSTRING(bn,3,2) AS INT) > 50
							THEN CAST(SUBSTRING(bn,3,2) AS INT) - 50
							ELSE CAST(SUBSTRING(bn,3,2) AS INT)
						END AS VARCHAR
					),2),
				RIGHT(bn,2)
			)
		),
		district_id
	FROM c;

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.client;

	PRINT '>> Client rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- DISP
	PRINT 'DISP';
	TRUNCATE TABLE silver.disp;
	SET @start_time = GETDATE();

	WITH t AS(
		SELECT 
			disp_id,
			client_id,
			account_id,
			REPLACE(type, '"', '') AS disposition_type
		FROM bronze.disp
	)
	INSERT INTO silver.disp (
		disp_id,
		client_id,
		account_id,
		disposition_type
	)
	SELECT 
		disp_id,
		client_id,
		account_id,
		CASE 
			WHEN disposition_type = 'OWNER' THEN 'Owner'
			WHEN disposition_type = 'DISPONENT' THEN 'Disponent'
		END
	FROM t;

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.disp;

	PRINT '>> Disp rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- DISTRICT
	PRINT 'DISTRICT';
	TRUNCATE TABLE silver.district;
	SET @start_time = GETDATE();

	INSERT INTO silver.district(
		district_id,
		district_name,
		population,
		municipalities_under_500,
		municipalities_500_to_1999,
		municipalities_2000_to_9999,
		municipalities_over_10000,
		cities_count,
		urban_population_ratio,
		average_salary,
		unemployment_rate_1995,
		unemployment_rate_1996,
		entrepreneurs_per_1000,
		crimes_1995,
		crimes_1996
	)
	SELECT
		district_id,
		REPLACE(district_name, '"', ''),
		CAST(REPLACE(population, '"', '') AS INT),
		CAST(REPLACE(municipalities_lt_500, '"', '') AS INT),
		CAST(REPLACE(municipalities_500_1999, '"', '') AS INT),
		CAST(REPLACE(municipalities_2000_9999, '"', '') AS INT),
		CAST(REPLACE(municipalities_gt_10000, '"', '') AS INT),
		CAST(REPLACE(cities_count, '"', '') AS INT),
		CAST(REPLACE(urban_population_ratio, '"', '') AS DECIMAL(5,2)),
		CAST(REPLACE(average_salary, '"', '') AS INT),
		CAST(REPLACE(unemployment_rate_1995, '"', '') AS DECIMAL(5,2)),
		CAST(REPLACE(unemployment_rate_1996, '"', '') AS DECIMAL(5,2)),
		CAST(REPLACE(entrepreneurs_per_1000, '"', '') AS DECIMAL(5,2)),
		CAST(REPLACE(crimes_1995, '"', '') AS INT),
		CAST(REPLACE(crimes_1996, '"', '') AS INT)
	FROM bronze.district
	WHERE unemployment_rate_1995 <> '?';

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.district;

	PRINT '>> District rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- LOAN
	PRINT 'LOAN';
	TRUNCATE TABLE silver.loan;
	SET @start_time = GETDATE();

	INSERT INTO silver.loan(
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
		CONVERT(DATE, date),
		amount,
		duration,
		payments,
		CASE 
			WHEN status IN ('"A"','"C"') THEN 'Good loan'
			ELSE 'Bad loan'
		END
	FROM bronze.loan;

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.loan;

	PRINT '>> Loan rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- ORDER
	PRINT 'ORDER';
	TRUNCATE TABLE silver.[order];
	SET @start_time = GETDATE();

	INSERT INTO silver.[order](
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
		REPLACE(bank_to, '"', ''),
		REPLACE(account_to, '"', ''),
		amount,
		CASE 
			WHEN k_symbol = '"POJISTNE"' THEN 'Insurance'
			WHEN k_symbol = '"SIPO"' THEN 'Household payments'
			WHEN k_symbol = '"LEASING"' THEN 'Leasing'
			WHEN k_symbol = '"UVER"' THEN 'Loan'
			ELSE 'Not available'
		END
	FROM bronze.[order];

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.[order];

	PRINT '>> Order rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	-- TRANSACTION
	PRINT 'TRANSACTION';
	TRUNCATE TABLE silver.[transaction];
	SET @start_time = GETDATE();

	INSERT INTO silver.[transaction](
		trans_id,
		account_id,
		transaction_date,
		transaction_type,
		operation,
		amount,
		balance,
		payment_purpose,
		destination_bank,
		destination_account
	)
	SELECT
		trans_id,
		account_id,
		CONVERT(DATE, date),
		CASE 
			WHEN type = '"PRIJEM"' THEN 'Income'
			WHEN type = '"VYBER"' THEN 'Withdrawal'
			ELSE 'Spending'
		END,
		CASE 
			WHEN k_symbol = '"PRIJEM"' THEN 'Income'
			WHEN k_symbol = '"VYDAJ"' THEN 'Spending'
			WHEN k_symbol = '"VYBER"' THEN 'Withdrawal'
			WHEN k_symbol = '"VYBER KARTOU"' THEN 'Card withdrawal'
			WHEN k_symbol = '"PREVOD Z UCTU"' THEN 'Incoming transfer'
			WHEN k_symbol = '"PREVOD NA UCET"' THEN 'Outgoing transfer'
			WHEN k_symbol = '"VKLAD"' THEN 'Deposit'
			WHEN k_symbol = '""' OR k_symbol IS NULL THEN 'Unknown'
			ELSE 'Other'
		END,
		amount,
		balance,
		CASE 
			WHEN k_symbol = '"DUCHOD"' THEN 'Pension'
			WHEN k_symbol = '"SANKC. UROK"' THEN 'Penalty Interest'
			WHEN k_symbol = '"UROK"' THEN 'Interest'
			WHEN k_symbol = '"SLUZBY"' THEN 'Services'
			WHEN k_symbol = '"POJISTNE"' THEN 'Insurance'
			WHEN k_symbol = '"UVER"' THEN 'Loan'
			WHEN k_symbol = '"SIPO"' THEN 'Household Payments'
			WHEN k_symbol = '""' OR k_symbol = '"' OR k_symbol IS NULL OR k_symbol = '" "' THEN 'Unknown'
			ELSE 'Other'
		END,
		CASE 
			WHEN bank IS NULL OR REPLACE(bank, '"', '') = '' THEN 'Not Available'
			ELSE REPLACE(bank, '"', '')
		END,
		CASE 
			WHEN account IS NULL OR REPLACE(account, '"', '') = '' THEN 'Not Available'
			ELSE REPLACE(account, '"', '')
		END
	FROM bronze.[transaction];

	SET @end_time = GETDATE();
	SELECT @row_count = COUNT(*) FROM silver.[transaction];

	PRINT '>> Transaction rows: ' + CAST(@row_count AS NVARCHAR);
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
	PRINT '>> --------------';


	SET @batch_end_time = GETDATE();

	PRINT '=====================================================';
	PRINT 'TOTAL BATCH TIME: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' second';
	PRINT '=====================================================';
END

