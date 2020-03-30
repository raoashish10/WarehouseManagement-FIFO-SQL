
CREATE FUNCTION dbo.GetBatchAmounts3
(
    @requestedAmount int

)
RETURNS 

@tBatchResults TABLE 
(   
    Batch nvarchar(50),
    Amount int,
	expdate DATETIME

)
AS
BEGIN
    
    DECLARE @temp TABLE( 

     Qty int,
     batch_no NVARCHAR(max),
     accept_date DATETIME
    )

    insert into @temp(Qty,batch_no,accept_date)
    SELECT quantity,batchno,expdate FROM Tmaster
	WHERE TName = 'Green Tea'
	--ORDER BY expdate;


    --insert into @RS_GIN_Master(Qty,batch_no,accept_date)
    --SELECT 10,'BT003', CAST(CAST(2014 AS varchar) + '-' + CAST(8 AS varchar) + '-' + CAST(5 AS varchar) AS DATETIME)

    --insert into @RS_GIN_Master(Qty,batch_no,accept_date)
    --SELECT 10,'BT001', CAST(CAST(2014 AS varchar) + '-' + CAST(8 AS varchar) + '-' + CAST(6 AS varchar) AS DATETIME)
    /*---------------------------*/

     DECLARE @Qty int
     DECLARE @batch_no NVARCHAR(max)
     DECLARE @accept_date DATETIME
	 
    DECLARE myCursor CURSOR FOR
	SELECT Qty, batch_no,accept_date FROM @temp ORDER BY accept_date ASC

    OPEN myCursor

    FETCH NEXT FROM myCursor INTO  @Qty, @batch_no,@accept_date

    WHILE (@@FETCH_STATUS = 0 AND @requestedAmount > 0 ) 
    BEGIN

        Declare @actualQty int
        IF @requestedAmount > @Qty
            SET @actualQty = @Qty
        ELSE    
            SET @actualQty = @requestedAmount
		
        INSERT INTO @tBatchResults (batch, Amount, expdate)
        SELECT @batch_no, @actualQty, @accept_date
		
		/*UPDATE Tmaster
		SET  Tmaster.quantity = Tmaster.quantity - @actualQty,
		WHERE Tmaster.batchno = @batch_no
		*/
        set @requestedAmount  = @requestedAmount - @actualQty

        FETCH NEXT FROM myCursor INTO @Qty, @batch_no,@accept_date

    END /*WHILE*/

    CLOSE myCursor
    DEALLOCATE myCursor
	
    RETURN
END




