-- account
DROP TABLE IF EXISTS silver.account;
CREATE TABLE silver.account(
	account_id INT,
	district_id INT,
	frequency NVARCHAR(50),
	account_date DATE
);

-- card
DROP TABLE IF EXISTS silver.card;
CREATE TABLE silver.card(
	card_id INT,
	disp_id INT,
	card_type NVARCHAR(50),
	issued_date DATE
);

-- client
DROP TABLE IF EXISTS silver.client;
CREATE TABLE silver.client(
	client_id INT,
	gender NVARCHAR(10),
	birth_date DATE,
	district_id INT
);

--

-- disp
DROP TABLE IF EXISTS silver.disp;
CREATE TABLE silver.disp(
	disp_id INT,
	client_id INT,
	account_id INT,
	disposition_type NVARCHAR(50)
)

-- district
DROP TABLE IF EXISTS silver.district;
CREATE TABLE silver.district(
	district_id INT,
	district_name NVARCHAR(50),
	population INT,
	municipalities_under_500 INT,
	municipalities_500_to_1999 INT,
	municipalities_2000_to_9999 INT,
	municipalities_over_10000 INT,
	cities_count INT,
	urban_population_ratio DECIMAL(5,2),
	average_salary INT,
	unemployment_rate_1995 DECIMAL(5,2),
	unemployment_rate_1996 DECIMAL(5,2),
	entrepreneurs_per_1000 DECIMAL(5,2),
	crimes_1995 INT,
	crimes_1996 INT
)

-- loan
DROP TABLE IF EXISTS silver.loan;
CREATE TABLE silver.loan(
	loan_id INT,
	account_id INT,
	term_start_date DATE,
	amount INT,
	duration INT,
	monthly_payments DECIMAL(10,2),
	loan_quality NVARCHAR(50)
)

-- order 
DROP TABLE IF EXISTS silver.[order];
CREATE TABLE silver.[order](
	order_id INT,
	account_id INT,
	destination_bank NVARCHAR(50),
	destination_account INT,
	amount DECIMAL(10,2),
	payment_purpose NVARCHAR(50)
)

-- transaction
DROP TABLE IF EXISTS silver.[transaction]
CREATE TABLE silver.[transaction](
	trans_id INT,
	account_id INT,
	transaction_date DATE,
	transaction_type NVARCHAR(50),
	operation NVARCHAR(50),
	amount DECIMAL(10,2),
	balance DECIMAL(10,2),
	payment_purpose NVARCHAR(50),
	destination_bank NVARCHAR(50),
	destination_account NVARCHAR(50)
)
