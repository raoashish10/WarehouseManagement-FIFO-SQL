/*CREATE TYPE dbo.TempTable AS TABLE 
(
TName varchar(50),
    Amount int,
	expdate  DATETIME,
	racks  varchar(50)
	)*/
	
CREATE PROCEDURE dbo.temp
@tmp TempTable READONLY 
AS
BEGIN
DECLARE @Amount int,@expdate DATETIME,@racks varchar(50),@TName varchar(50)

DECLARE tcount CURSOR FOR 
SELECT * FROM @tmp 
OPEN tcount
FETCH NEXT FROM tcount INTO @Amount,@TName,@expdate,@racks

WHILE (@@FETCH_STATUS=0)
BEGIN
	INSERT INTO dbo.Tmaster
	VALUES(@Amount,@TName,@expdate,@racks)

	FETCH NEXT FROM tcount INTO @Amount,@TName,@expdate,@racks
END
END