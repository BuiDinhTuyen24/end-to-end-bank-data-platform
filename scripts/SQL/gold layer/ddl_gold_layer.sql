-- Create table gold.dim_client
DROP TABLE IF EXISTS gold.dim_client;
CREATE TABLE gold.dim_client(
	client_id INT PRIMARY KEY,
	gender NVARCHAR(50),
	birth_date DATE,
	district_id INT
);


-- Create table gold.dim_account
DROP TABLE IF EXISTS gold.dim_account;
CREATE TABLE gold.dim_account(
	account_id INT PRIMARY KEY,
	district_id INT,
	frequency NVARCHAR(50),
	account_created_date DATE
);

-- Create table gold.dim_district
DROP TABLE IF EXISTS gold.dim_district;
CREATE TABLE gold.dim_district(
	district_id INT PRIMARY KEY,
	district_name NVARCHAR(50),
	population INT,
	urban_population_ratio DECIMAL(5,2),
	average_salary DECIMAL(10,2),
	unemployment_rate_1995 DECIMAL(5,2),
	unemployment_rate_1996 DECIMAL(5,2),
	entrepreneurs_per_1000 DECIMAL(5,2)
);

-- Create table gold.dim_card
DROP TABLE IF EXISTS gold.dim_card;
CREATE TABLE gold.dim_card(
	card_id INT PRIMARY KEY,
	card_type NVARCHAR(50),
	issued_date DATE
);

-- Create table gold.dim_date
DROP TABLE IF EXISTS gold.dim_date;
CREATE TABLE gold.dim_date(
	date_id INT PRIMARY KEY,
	full_date DATE,
	[year] INT,
	[month] INT,
	[day] INT,
	[weekday] INT,
	weekday_name NVARCHAR(50),
	[quarter] INT
);


-- Create table gold.fact_transaction
DROP TABLE IF EXISTS gold.fact_transaction;
CREATE TABLE gold.fact_transaction(
	trans_id INT PRIMARY KEY,
	account_id INT,
	date_id INT,
	amount DECIMAL(10,2),
	balance DECIMAL(10,2),
	transaction_type NVARCHAR(50),
	operation NVARCHAR(50),
	payment_purpose NVARCHAR(50)
);

-- Create table gold.fact_loan
DROP TABLE IF EXISTS gold.fact_loan;
CREATE TABLE gold.fact_loan(
	loan_id INT PRIMARY KEY,
	account_id INT,
	term_start_date DATE,
	amount DECIMAL(10,2),
	duration INT,
	monthly_payments DECIMAL(10,2),
	loan_quality NVARCHAR(50)
);

-- Create table gold.fact_order
DROP TABLE IF EXISTS gold.fact_order;
CREATE TABLE gold.fact_order(
	order_id INT PRIMARY KEY,
	account_id INT,
	destination_bank NVARCHAR(50),
	destination_account INT,
	amount DECIMAL(10,2),
	payment_purpose NVARCHAR(50)
);








