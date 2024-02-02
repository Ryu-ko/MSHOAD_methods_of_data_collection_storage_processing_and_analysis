

-- 10.1

exec sp_configure 'show advanced options', 1;
go 
reconfigure
go 
exec sp_configure 'clr enabled',1;
exec sp_configure 'clr strict security', 0
RECONFIGURE;


DECLARE @result FLOAT;

EXEC dbo.CalculateAverageWithoutMinMax
    @values = '10,2,3,4,5',
    @result = @result OUTPUT;

SELECT @result AS Result;


-- 10.2

CREATE TABLE AddressTable
(
    ID INT PRIMARY KEY,
    Location Address
);


INSERT INTO AddressTable (ID, Location)
VALUES
(1, '123 Main St, City1, State1'),
(2, '456 Elm St, City2, State2'),
(3, '789 Pine St, City3, State3');

-- watch hex
SELECT * FROM AddressTable;

-- cast it back
SELECT ID, CAST(Location AS NVARCHAR(MAX)) AS ReadableAddress
FROM AddressTable;


