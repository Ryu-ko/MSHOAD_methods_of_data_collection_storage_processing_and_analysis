use shop;
--lab4 

-- 2.���������� ������ ������ ��������� ���������, �� �������, �� �������, �� ���.
-- DateMetrics ������ ���������� ��������� (CTE) - ��������� ���� ������ �� ���������� ����, ������, �������� � ���������
--������� = 12/4=3 ������, ���� ������-��� - 1, ������-���� - 2, ����-�������� - 3, �������-������� - 4

WITH DateMetrics AS (  --����������� ������ ���������� ��������� (CTE)
    SELECT
        OrderID,
        OrderAmount,
        DATEPART(YEAR, OrderDate) AS SaleYear,
        DATEPART(MONTH, OrderDate) AS SaleMonth,
        DATEPART(QUARTER, OrderDate) AS SaleQuarter,
		-- to define wich first or second half a year
        CASE 
            WHEN DATEPART(MONTH, OrderDate) <= 6 THEN 1
            ELSE 2
        END AS SaleHalfYear
    FROM Orders
)
-- ����� �������� ����� ���������� ������ � �������� �� ������ ����� � ������������� ���������� ��� ��������, �����������, ����������� � ������� �����������.
SELECT
    SaleYear,
    SaleMonth,
    SUM(OrderAmount) AS MonthlySales,
    SUM(CASE WHEN SaleQuarter = 1 THEN OrderAmount ELSE 0 END) AS Q1Sales,--������� �������� (������� � ������ �� ����).
    SUM(CASE WHEN SaleQuarter = 2 THEN OrderAmount ELSE 0 END) AS Q2Sales,
    SUM(CASE WHEN SaleQuarter = 3 THEN OrderAmount ELSE 0 END) AS Q3Sales,
    SUM(CASE WHEN SaleQuarter = 4 THEN OrderAmount ELSE 0 END) AS Q4Sales,--���������� �������� (������� � ������� �� �������).
    SUM(CASE WHEN SaleHalfYear = 1 THEN OrderAmount ELSE 0 END) AS H1Sales,--������ �������� ���� (������-����).
    SUM(CASE WHEN SaleHalfYear = 2 THEN OrderAmount ELSE 0 END) AS H2Sales,--������ �������� ���� (����-�������).
    SUM(OrderAmount) AS YearlySales
FROM DateMetrics
GROUP BY SaleYear, SaleMonth
ORDER BY SaleYear, SaleMonth;



-- 4.3--���������� ������ ������ ��������� �� ������������ ������:
				--����� ������;
				--��������� �� � ����� ������� ������ (� %);
				--��������� � ��������� ������� ������ (� %).
select * from OrderedProducts;
WITH SalesSummary AS (
    SELECT
        o.ClientID,
        SUM(op.TotalCost) AS TotalSales
    FROM Orders o
    JOIN OrderedProducts op ON o.OrderID = op.OrderID
    GROUP BY o.ClientID
),

TotalSales AS (
    SELECT SUM(TotalSales) AS GrandTotalSales FROM SalesSummary
),

MaxSales AS ( -- ������������ ����� ������ ����� ���� ��������.
    SELECT MAX(TotalSales) AS BestSales FROM SalesSummary
)

SELECT
    c.ClientID,
    c.FirstName + ' ' + c.LastName AS SalesmanName,
    ss.TotalSales,	
    (ss.TotalSales / ts.GrandTotalSales * 100) AS SalesPercentageOfTotal, -- every client sales / total sales
    (ss.TotalSales / ms.BestSales * 100) AS SalesPercentageOfBest -- every client sales / only the client with max sales
FROM SalesSummary ss
JOIN Clients c ON ss.ClientID = c.ClientID
CROSS JOIN TotalSales ts
CROSS JOIN MaxSales ms
ORDER BY ss.TotalSales DESC;

INSERT INTO Orders (OrderID, ClientID, OrderDate)
VALUES
    (11, 3, '2023-01-01'),
    (12, 3, '2023-01-02'),
    (13, 4, '2023-01-03'),
    (14, 5, '2023-01-04'),
    (15, 3, '2023-01-05'),
    (16, 3, '2023-01-06'),
    (17, 3, '2023-01-07'),
    (18, 3, '2023-01-08'),
    (19, 3, '2023-01-09'),
    (20, 3, '2023-01-10');
Select * from Clients
Select * from Orders

-- 4
DECLARE @PageSize INT = 10, @PageNumber INT = 1;

WITH RankedOrders AS (
    SELECT
        OrderID,
        ClientID,
        OrderDate,
        ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum
    FROM Orders
)

SELECT * FROM RankedOrders
WHERE RowNum > (@PageSize * (@PageNumber - 1)) AND RowNum <= (@PageSize * @PageNumber);



-----------------������� ��� � �����, �� ����������� 2 select--------------
CREATE PROCEDURE GetPaginatedOrders2
AS
BEGIN
    -- ������ ��������
    SELECT
        OrderID,
        ClientID,
        OrderDate
    FROM (
        SELECT
            OrderID,
            ClientID,
            OrderDate,
            ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum
        FROM Orders
    ) AS NumberedOrders
    WHERE RowNum <= 10;

    -- ������ ��������
    SELECT
        OrderID,
        ClientID,
        OrderDate
    FROM (
        SELECT
            OrderID,
            ClientID,
            OrderDate,
            ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum
        FROM Orders
    ) AS NumberedOrders
    WHERE RowNum > 10 AND RowNum <= 20;
END;


EXEC GetPaginatedOrders2;

DROP PROCEDURE GetPaginatedOrders2

------------������� 3 �� ������ �����������������,� ������ � 1 �� 10 � ����� � 1 �� 10 ��������-----------
WITH NumberedOrders AS (
    SELECT
        OrderID,
        ClientID,
        OrderDate,
        ROW_NUMBER() OVER (ORDER BY OrderDate) AS RowNum
    FROM Orders
)

SELECT
    OrderID,
    ClientID,
    OrderDate,
    (RowNum - 1) % 10 + 1 AS RowNumOnPage
FROM NumberedOrders
WHERE RowNum <= 20;


----------------------�������� 3------------------------------

----------------------������� 4-----------------------------



-----------------------�������� 4-----------------------------


----------------------������� 5-----------------------------




-------------------�������� 5--------------------------------



-- 5
WITH NumberedReviews AS (
    SELECT
        ReviewID,
        ProductID,
        ClientID,
        ReviewText,
        Rating,
        ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY ReviewID) AS RowNum
    FROM Reviews
)
DELETE FROM NumberedReviews
WHERE RowNum > 1; -- ����������� ������ ������ ����� ��� ������� ��������.

INSERT INTO Reviews (ReviewID,ProductID, ClientID, ReviewText, Rating)
VALUES 
(4,1, 3, 'Great car!', 5),
(5,2, 4, 'Could be better in off-road situations', 3),
(6,3, 5, 'Stylish but not very practical', 4);

select * from Reviews;



---- 6

WITH Last6MonthsOrders AS (
    SELECT
        o.ClientID,
        SUM(o.OrderAmount) AS TotalAmountLast6Months
    FROM Orders o
    WHERE o.OrderDate >= DATEADD(MONTH, -6, GETDATE()) --����������� ��� ��������� ���������� ��������� � ���
    GROUP BY o.ClientID
)

SELECT
    c.ClientID,
    c.FirstName + ' ' + c.LastName AS ClientName,
    ISNULL(lo.TotalAmountLast6Months, 0) AS TotalAmountLast6Months --���� ISNULL �� ������ 0
FROM Clients c
LEFT JOIN Last6MonthsOrders lo ON c.ClientID = lo.ClientID
ORDER BY c.ClientID;

--7
WITH ClientEmployeeServiceCounts AS (
    SELECT
        c.ClientID,
        CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
        o.ClientID AS EmployeeID,
        COUNT(o.OrderID) AS ServiceCount
    FROM Clients c
    LEFT JOIN Orders o ON c.ClientID = o.ClientID
    GROUP BY c.ClientID, CONCAT(c.FirstName, ' ', c.LastName), o.ClientID
)

SELECT
    ClientID,
    ClientName,
    EmployeeID AS EmployeeName,
    MAX(ServiceCount) AS MaxServiceCount
FROM ClientEmployeeServiceCounts
GROUP BY ClientID, ClientName, EmployeeID
ORDER BY ClientID, MaxServiceCount DESC;
