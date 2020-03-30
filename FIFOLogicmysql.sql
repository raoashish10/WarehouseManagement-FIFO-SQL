DELIMITER $$
DROP procedure if exists dbo.GetBatchAmounts3;

CREATE PROCEDURE dbo.GetBatchAmounts3
(
    requestedAmount INTEGER,
    requestedT varchar(100)

)
BEGIN
    
	-- ORDER BY expdate;


    -- insert into @RS_GIN_Master(Qty,batch_no,accept_date)
    -- SELECT 10,'BT003', CAST(CAST(2014 AS varchar) + '-' + CAST(8 AS varchar) + '-' + CAST(5 AS varchar) AS DATETIME)

    -- insert into @RS_GIN_Master(Qty,batch_no,accept_date)
    -- SELECT 10,'BT001', CAST(CAST(2014 AS varchar) + '-' + CAST(8 AS varchar) + '-' + CAST(6 AS varchar) AS DATETIME)
    /*---------------------------*/
	DECLARE Qty INT DEFAULT 0;
    DECLARE TName INT DEFAULT 0;
    DECLARE expdate INT DEFAULT 0;
    DECLARE actualQty INTEGER DEFAULT 0;
    DECLARE rackno INTEGER DEFAULT 0;
    DECLARE done INTEGER DEFAULT FALSE;
--      DECLARE @Qty int
--      DECLARE @batch_no NVARCHAR(max)
--      DECLARE @accept_date DATETIME
 	 
    DECLARE myCursor CURSOR FOR 
	SELECT (quantity, TName,Expdate,racks) 
    FROM tmaster 
    ORDER BY Expdate ASC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN myCursor;

    FETCH NEXT FROM myCursor INTO Qty, TName,expdate,rackno;
 
   loop1: WHILE requestedAmount > 0  DO
	IF TName=requestedT THEN	
        IF done THEN 
        LEAVE loop1;
        END IF;
        IF requestedAmount > Qty THEN
            SET actualQty = Qty;
        ELSE    
            SET actualQty = requestedAmount;
		END IF;
        
        INSERT INTO pickupinstruction (TName, Quantity, expdate,racks)
        SELECT TName, actualQty, expdate,rackno;
		
		/*UPDATE Tmaster
		SET  Tmaster.quantity = Tmaster.quantity - @actualQty,
		WHERE Tmaster.batchno = @batch_no
		*/
        set requestedAmount  = requestedAmount - actualQty;

        FETCH NEXT FROM myCursor INTO Qty, TName,expdate,rackno;
   END IF;
    END WHILE loop1;/*WHILE*/

    CLOSE myCursor;
    
END$$




