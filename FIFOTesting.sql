
SELECT * FROM dbo.GetBatchAmounts3(100)

UPDATE dbo.Tmaster 
SET Tmaster.quantity = Tmaster.quantity - (SELECT Amount FROM dbo.GetBatchAmounts3(100) AS p WHERE Tmaster.batchno = p.Batch  )
WHERE Tmaster.batchno = (SELECT Batch FROM dbo.GetBatchAmounts3(100) AS p WHERE Tmaster.batchno = p.Batch);

DELETE FROM Tmaster
WHERE quantity=0

SELECT * FROM Tmaster



/*
INSERT INTO Tmaster(quantity,TName,expdate) VALUES 
(20,'Cream Tea','2004/09/01'),
(50,'Green Tea','2001/05/11'),
(80,'Green Tea','2002/01/13')
*/