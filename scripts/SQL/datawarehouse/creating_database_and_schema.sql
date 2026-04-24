-- Create database
USE master;
GO

DROP DATABASE IF EXISTS Bank;
GO

CREATE DATABASE Bank;
GO
-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
