DELETE FROM Contract;
DELETE FROM Restaurant;
DELETE FROM DeliveryCompany;



/* Checks if a varchar variable is null returns 1 if invalid, 0 if valid) */
GO
CREATE OR ALTER FUNCTION ValidateVarchar(@value VARCHAR(50))
RETURNS INT AS
BEGIN
		IF(@value IS NULL)
		BEGIN
				RETURN 1;
		END;
		RETURN 0;
END;
GO

/* Checks if an int is null or smaller than 0 (returns 1 if invalid, 0 if valid) */
GO
CREATE OR ALTER FUNCTION ValidateInt(@value INT)
RETURNS INT AS
BEGIN 
		IF(@value <0 or @value IS NULL)
		BEGIN 
				RETURN 1;
		END;
		RETURN 0;
END;
GO

GO
CREATE OR ALTER PROCEDURE Procedure1(
@restaurantcode int,
@companycode int,
@restaurantname varchar(50),
@companyname varchar(50)) AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		/*Restaurant validation*/
		IF(dbo.ValidateInt(@restaurantcode)=1)
		BEGIN
			RAISERROR('Invalid RestaurantCode',14,1);
		END;
		
		IF(dbo.ValidateVarchar(@restaurantname)=1)
		BEGIN
			RAISERROR('Invalid RestaurantName',14,1);
		END;
		/*Insert*/
		INSERT INTO Restaurant VALUES (@restaurantname,@restaurantcode);
		DECLARE @id1 INT;
		SET @id1 = SCOPE_IDENTITY();

		/*DeliveryCompany validation*/
		IF(dbo.ValidateInt(@companycode)=1)
		BEGIN
			RAISERROR('Invalid CompanyCode',14,1);
		END;
		IF(dbo.ValidateVarchar(@companyname)=1)
		BEGIN
			RAISERROR('Invalid Company name',14,1);
		END;
		/*Insert*/
		INSERT INTO DeliveryCompany VALUES (@companyname,@companycode);
		DECLARE @id2 INT;
		SET @id2 = SCOPE_IDENTITY();
		INSERT INTO dbo.Contract VALUES(@id1,@id2);
	COMMIT TRAN
	SELECT 'Transaction was a success!'
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	SELECT 'Rollback'
	SELECT 'Error: ' + ERROR_MESSAGE()
	END CATCH
END;

/*Successful operation*/
EXEC Procedure1 102,130,'PizzaHut','FoodPanda'
SELECT * FROM Restaurant;
SELECT * FROM DeliveryCompany;
SELECT * FROM Contract;

/*Unsuccessful operation*/
EXEC Procedure1 2,-2,'Lala','Blabla';
SELECT * FROM Restaurant;
SELECT * FROM DeliveryCompany;
SELECT * FROM Contract;

GO
CREATE OR ALTER PROCEDURE Procedure2(
@restaurantcode int,
@restaurantname varchar(50),
@companycode int,
@companyname varchar(50)) AS
BEGIN
	/*Transaction for Restaurant*/
	BEGIN TRAN
	BEGIN TRY
		DECLARE @id1 INT;
		SET @id1=-1;
		IF(dbo.ValidateInt(@restaurantcode) = 1)
		BEGIN
			RAISERROR('Invalid RestaurantCode',14,1);
		END;

		IF(dbo.ValidateVarchar(@restaurantname)=1)
		BEGIN
			RAISERROR('Invalid RestaurantName',14,1);
		END;
		INSERT INTO Restaurant VALUES (@restaurantname,@restaurantcode);
		SET @id1 = SCOPE_IDENTITY();
	COMMIT TRAN
	SELECT 'Restaurant: success!'
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	SELECT 'Rollback'
	SELECT 'Error: ' + ERROR_MESSAGE()
	END CATCH

	/*Transaction for company*/
	BEGIN TRAN
	BEGIN TRY
		DECLARE @id2 INT;
		SET @id2=-1;
	IF(dbo.ValidateInt(@companycode) = 1 )
		BEGIN
			RAISERROR('Invalid Companycode',14,1);
		END;
		IF(dbo.ValidateVarchar(@companyname)=1)
		BEGIN
			RAISERROR('Invalid Company name',14,1);
		END;
		INSERT INTO DeliveryCompany VALUES (@companyname,@companycode);
		SET @id2=SCOPE_IDENTITY();
	COMMIT TRAN
	SELECT 'DeliveryCompany: success!'
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	SELECT 'Rollback'
	SELECT 'Error: ' + ERROR_MESSAGE()
	END CATCH
	/*Transaction for Contract*/
	BEGIN TRAN
	BEGIN TRY
		IF @id1=-1 OR @id2=-1
		BEGIN
			RAISERROR('Either Restaurant or Company had an error',14,1);
		END
		INSERT INTO dbo.Contract VALUES(@id1,@id2);
	COMMIT TRAN
	SELECT 'Transaction was a success!'
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
	SELECT 'Rollback'
	SELECT 'Error: ' + ERROR_MESSAGE()
	END CATCH
END;

/*Successful operation*/
EXEC Procedure2 2002,'Marty',2302,'Takeaway';
SELECT * FROM Restaurant;
SELECT * FROM DeliveryCompany;
SELECT * FROM Contract;

/*Unsuccessful: Something wrong with company: still adds Restaurant but won't add contract*/
EXEC Procedure2 3,'McDonalds',-230,'Glovo';
SELECT * FROM Restaurant;
SELECT * FROM DeliveryCompany;
SELECT * FROM Contract;

/*Unsuccessful: Something wrong with Restaurant: still adds Company but won't add contract*/
EXEC Procedure2 -1200,'KFC',2,'Foodpanda';
SELECT * FROM Restaurant;
SELECT * FROM DeliveryCompany;
SELECT * FROM Contract;