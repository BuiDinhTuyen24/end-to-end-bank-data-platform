
-- Create table account
DROP TABLE IF EXISTS bronze.account;
CREATE TABLE bronze.account(
	account_id NVARCHAR(50),
	district_id NVARCHAR(50),
	frequency NVARCHAR(50),
	date NVARCHAR(50)
);

-- Create table card
DROP TABLE IF EXISTS bronze.card;
CREATE TABLE bronze.card(
	card_id NVARCHAR(50),
	disp_id NVARCHAR(50),
	type NVARCHAR(50),
	issued NVARCHAR(50)
);

-- Create table client
DROP TABLE IF EXISTS bronze.client;
CREATE TABLE bronze.client(
	client_id NVARCHAR(50),
	birth_number NVARCHAR(50),
	district_id NVARCHAR(50)
);

-- Create table disp
DROP TABLE IF EXISTS bronze.disp;
CREATE TABLE bronze.disp(
	disp_id NVARCHAR(50),
	client_id NVARCHAR(50),
	account_id NVARCHAR(50),
	type NVARCHAR(50)
);

-- Create table district
DROP TABLE IF EXISTS bronze.district;
CREATE TABLE bronze.district(
	district_id NVARCHAR(50),
	district_name_cz NVARCHAR(100),
	district_name NVARCHAR(100),
	population NVARCHAR(50),
	municipalities_lt_500 NVARCHAR(50),
	municipalities_500_1999 NVARCHAR(50),
	municipalities_2000_9999 NVARCHAR(50),
	municipalities_gt_10000 NVARCHAR(50),
	cities_count NVARCHAR(50),
	urban_population_ratio NVARCHAR(50),
	average_salary NVARCHAR(50),
	unemployment_rate_1995 NVARCHAR(50),
	unemployment_rate_1996 NVARCHAR(50),
	entrepreneurs_per_1000 NVARCHAR(50),
	crimes_1995 NVARCHAR(50),
	crimes_1996 NVARCHAR(50)
);

-- Create table loan
DROP TABLE IF EXISTS bronze.loan;
CREATE TABLE bronze.loan(
	loan_id NVARCHAR(50),
	account_id NVARCHAR(50),
	date NVARCHAR(50),
	amount NVARCHAR(50),
	duration NVARCHAR(50),
	payments NVARCHAR(50),
	status NVARCHAR(50)
);

-- Create table order
DROP TABLE IF EXISTS bronze.[order];
CREATE TABLE bronze.[order](
	order_id NVARCHAR(50),
	account_id NVARCHAR(50),
	bank_to NVARCHAR(20),
    account_to NVARCHAR(50),
    amount NVARCHAR(50),
    k_symbol NVARCHAR(20)
);

-- Create table transaction
DROP TABLE IF EXISTS bronze.[transaction];
CREATE TABLE bronze.[transaction](
	trans_id NVARCHAR(50),
    account_id NVARCHAR(50),
    date NVARCHAR(50),
    type NVARCHAR(50),
    operation NVARCHAR(50),
    amount NVARCHAR(50),
    balance NVARCHAR(50),
    k_symbol NVARCHAR(50),
    bank NVARCHAR(50),
    account NVARCHAR(50)
);