/*Dirty Read
Transaction: UPDATE +WAIT+ ROLLBACK
Problem: Transaction 2 will show the name before it is rollbacked
*/
GO
CREATE OR ALTER PROCEDURE DR1(
@cityid int,
@cityname varchar(50)
) AS
BEGIN
	BEGIN TRAN
	UPDATE City
	SET City.name=@cityname
	WHERE City.cityid=@cityid
	WAITFOR DELAY '00:00:10'
	ROLLBACK TRAN
END;
GO

DELETE FROM City;

INSERT INTO City VALUES(1,'Brasov'),(2,'Iasi'),(3,'Bucuresti');
SELECT * FROM City
EXEC DR1 3,'Cluj-Napoca';
SELECT * FROM City


/*Non Repeatable Reads
Transaction: SELECT + WAIT + SELECT
*/
GO
CREATE OR ALTER PROCEDURE NRR1(
@cityid int
) AS
BEGIN
	UPDATE City
	SET Name='Not Modified'
	WHERE cityid=@cityid

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	BEGIN TRAN
	SELECT * FROM City
	WAITFOR DELAY '00:00:05'
	SELECT * FROM City
	COMMIT TRAN
END;
EXEC NRR1 1;

/*Solution*/
GO
CREATE OR ALTER PROCEDURE NRR1S(
@cityid int
)AS
BEGIN
	UPDATE City
	SET name='Changed'
	WHERE cityid=@cityid
	/*
		Nivelul de izolare a fost schimbat de la "read committed" la "repeatable read"
		Datele citite de primul select nu poate fi updatate sau sterse de o alta tranzactie 
		pana cand prima tranzactie este efectuata
		Ambele selecturi vor returna aceleasi date
		Tranzactia a 2 a va modifica datele dupa ce prima tranzactie termina
		*/
		SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
		BEGIN TRAN
		SELECT * FROM City
		WAITFOR DELAY '00:00:05'
		SELECT * FROM City
	COMMIT TRAN
END;

EXEC NRR1S 1;

/*Phantom Reads
Transaction: SELECT + WAIT + SELECT
*/
GO
CREATE OR ALTER PROCEDURE PR1
AS BEGIN
	/*Blocheaza datele selectate de query ca sa nu poate sa fie modificate*/
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN TRAN
	SELECT * FROM City
	WAITFOR DELAY '00:00:05'
	/*Citeste datele din nou dar apare un rand nou care a fost inserat de tranzactia 2*/
	SELECT * FROM City;
	COMMIT TRAN
END

EXEC PR1;
GO
CREATE OR ALTER PROCEDURE PRS
AS BEGIN
	/* Nivelul de izolare se modifica de la repeatable read in serializable
	Datele noi nu pot fi inserate de o alta tranzactie pana nu termina traznactia 1,
	insertul din tranzactia 2 se va afisa dupa cele 2 selecturi din tranzactia 1*/
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRAN
	SELECT * FROM City
	WAITFOR DELAY '00:00:05'
	SELECT * FROM City;
	COMMIT TRAN
END;
EXEC PRS;