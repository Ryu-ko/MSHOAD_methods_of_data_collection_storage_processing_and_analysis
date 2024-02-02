use shop;
--lab4 

-- 2.¬ычисление итогов работы продавцов помес€чно, за квартал, за полгода, за год.
-- DateMetrics общего табличного выражени€ (CTE) - разбивает даты заказа на компоненты года, мес€ца, квартала и полугоди€
--квартал = 12/4=3 мес€ца, если €нварь-май - 1, апрель-июнь - 2, июль-сент€брь - 3, окт€брь-декабрь - 4

WITH DateMetrics AS (  --определение общего табличного выражени€ (CTE)
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
-- «атем основной ¬џЅќ– агрегирует данные о продажах за каждый мес€ц и предоставл€ет результаты дл€ мес€чных, квартальных, полугодовых и годовых показателей.
SELECT
    SaleYear,
    SaleMonth,
    SUM(OrderAmount) AS MonthlySales,
    SUM(CASE WHEN SaleQuarter = 1 THEN OrderAmount ELSE 0 END) AS Q1Sales,--первого квартала (квартал с €нвар€ по март).
    SUM(CASE WHEN SaleQuarter = 2 THEN OrderAmount ELSE 0 END) AS Q2Sales,
    SUM(CASE WHEN SaleQuarter = 3 THEN OrderAmount ELSE 0 END) AS Q3Sales,
    SUM(CASE WHEN SaleQuarter = 4 THEN OrderAmount ELSE 0 END) AS Q4Sales,--четвертого квартала (квартал с окт€бр€ по декабрь).
    SUM(CASE WHEN SaleHalfYear = 1 THEN OrderAmount ELSE 0 END) AS H1Sales,--первой половины года (€нварь-июнь).
    SUM(CASE WHEN SaleHalfYear = 2 THEN OrderAmount ELSE 0 END) AS H2Sales,--второй половины года (июль-декабрь).
    SUM(OrderAmount) AS YearlySales
FROM DateMetrics
GROUP BY SaleYear, SaleMonth
ORDER BY SaleYear, SaleMonth;



-- 4.3--¬ычисление итогов работы продавцов за определенный период:
				--объем продаж;
				--сравнение их с общим объемом продаж (в %);
				--сравнение с наилучшим объемом продаж (в %).
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

MaxSales AS ( -- максимальный объем продаж среди всех клиентов.
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



-----------------ѕопытка еще в унике, не понравилось 2 select--------------
CREATE PROCEDURE GetPaginatedOrders2
AS
BEGIN
    -- ѕерва€ страница
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

    -- ¬тора€ страница
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

------------попытка 3 не делает многостраничность,а просто с 1 по 10 и оп€ть с 1 по 10 нумерует-----------
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


----------------------закрытие 3------------------------------

----------------------попытка 4-----------------------------



-----------------------закрытие 4-----------------------------


----------------------попытка 5-----------------------------




-------------------закрытие 5--------------------------------



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
WHERE RowNum > 1; -- оставл€етс€ только первый отзыв дл€ каждого продукта.

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
    WHERE o.OrderDate >= DATEADD(MONTH, -6, GETDATE()) --прибавлени€ или вычитани€ временного интервала к дат
    GROUP BY o.ClientID
)

SELECT
    c.ClientID,
    c.FirstName + ' ' + c.LastName AS ClientName,
    ISNULL(lo.TotalAmountLast6Months, 0) AS TotalAmountLast6Months --если ISNULL то ставим 0
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
