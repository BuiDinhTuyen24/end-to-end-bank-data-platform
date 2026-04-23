

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY 
        SET @batch_start_time = GETDATE()
        PRINT '=====================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=====================================================';

        PRINT '-----------------------------------------------------';
        PRINT 'Loading Account Tables';
        PRINT '-----------------------------------------------------';


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.account'
        TRUNCATE TABLE bronze.account
        PRINT '>> Inserting Data Into: bronze.account'
        BULK INSERT bronze.account
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\account.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration:' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.card';
        TRUNCATE TABLE bronze.card;

        PRINT '>> Inserting Data Into: bronze.card';
        BULK INSERT bronze.card
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\card.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.client';
        TRUNCATE TABLE bronze.client;

        PRINT '>> Inserting Data Into: bronze.client';
        BULK INSERT bronze.client
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\client.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.disp';
        TRUNCATE TABLE bronze.disp;

        PRINT '>> Inserting Data Into: bronze.disp';
        BULK INSERT bronze.disp
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\disp.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.district';
        TRUNCATE TABLE bronze.district;

        PRINT '>> Inserting Data Into: bronze.district';
        BULK INSERT bronze.district
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\district.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.loan';
        TRUNCATE TABLE bronze.loan;

        PRINT '>> Inserting Data Into: bronze.loan';
        BULK INSERT bronze.loan
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\loan.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.[order]';
        TRUNCATE TABLE bronze.[order];

        PRINT '>> Inserting Data Into: bronze.[order]';
        BULK INSERT bronze.[order]
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\order.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.[transaction]';
        TRUNCATE TABLE bronze.[transaction];

        PRINT '>> Inserting Data Into: bronze.[transaction]';
        BULK INSERT bronze.[transaction]
        FROM 'C:\Users\Admin\Desktop\Database\Bank Project\trans.csv'
        WITH (
	        FIRSTROW = 2,
            FIELDTERMINATOR = ';',
            ROWTERMINATOR = '\n',
            CODEPAGE = '65001',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second';
        PRINT '>> --------------';

        SET @batch_end_time = GETDATE();
		PRINT '=====================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' second';
		PRINT '=====================================================';

	END TRY
	BEGIN CATCH
		PRINT '=====================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT '=====================================================';
	END CATCH

END

EXEC bronze.load_bronze