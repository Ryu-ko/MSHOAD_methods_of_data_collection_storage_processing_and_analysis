--представление с информацией о товарах с категорией и именем поставщика:
CREATE VIEW ItemDetails AS
	SELECT
		I.ID_Item,
		I.Item_Name,
		C.Category_Name,
		S.Supplier_Name
	FROM Item I
	JOIN Category C ON I.Item_Category = C.ID_Category
	JOIN Supplier S ON I.Item_Supplier = S.ID_Supplier;

-- представление информации о заказах с деталями заказа
CREATE VIEW OrderDetails AS
	SELECT
		O.ID_Orders,
		O.Ord_ID_Item,
		O.NumberOrderedItems,
		I.Item_Name,
		I.Item_Price
	FROM Orders O
	JOIN Item I ON O.Ord_ID_Item = I.ID_Item;

--представление кол-во товаров и местоположение товаров на складе.
CREATE VIEW InventoryView AS
SELECT
    I.ID_Item,
    I.Item_Name,
    I.Item_Quantity,
    SL.Loc_Row,
    SL.Loc_Place
FROM Item I
JOIN StorageLocation SL ON I.ID_Item = SL.Loc_ItemID;

--общая стоимость заказов в различные периоды времени.
CREATE VIEW OrderTotalCostView AS
SELECT
    OI.ID_Order,
    OI.Order_Date,
    SUM(O.NumberOrderedItems * I.Item_Price) AS TotalCost
FROM Orders O
JOIN Item I ON O.Ord_ID_Item = I.ID_Item
JOIN OrderInf OI ON O.ID_Orders = OI.ID_Order
GROUP BY OI.ID_Order, OI.Order_Date;

---------------------------ИНДЕКСЫ---------------------------------------------------------
--Индекс для таблицы Item на столбце Item_Category:
	--поможет ускорить поиск товаров по категории.
CREATE INDEX IX_Item_ItemCategory ON Item(Item_Category);

--Индекс для таблицы Orders на столбце Ord_ID_Item:
	--улучшает производительность запросов, связанных с заказами и товарами.
CREATE INDEX IX_Orders_OrdIDItem ON Orders(Ord_ID_Item);

--Индекс для таблицы StorageLocation на столбце Loc_ItemID:
	--поможет ускорить доступ к данным о местоположениях товаров на складе.
CREATE INDEX IX_StorageLocation_LocItemID ON StorageLocation(Loc_ItemID);

--Индекс для таблицы OrderInf на столбце Order_Date:
	--поможет ускорить запросы, связанные с поиском заказов по дате.
CREATE INDEX IX_OrderInf_OrderDate ON OrderInf(Order_Date);

-------------------------ПОСЛЕДОВАТЕЛЬНОСТИ-----------------------------------------------

-- Последовательность для таблицы Category
CREATE SEQUENCE Category_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- Последовательность для таблицы Item
CREATE SEQUENCE Item_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- Последовательность для таблицы Orders
CREATE SEQUENCE Orders_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- Последовательность для таблицы Courier
CREATE SEQUENCE Courier_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- Последовательность для таблицы OrderInf
CREATE SEQUENCE OrderInf_ID_Seq
    START WITH 1
    INCREMENT BY 1;

DROP SEQUENCE Category_ID_Seq;
DROP SEQUENCE Item_ID_Seq;
DROP SEQUENCE Orders_ID_Seq;
DROP SEQUENCE OrderInf_ID_Seq;
DROP SEQUENCE Courier_ID_Seq;

------------------ТРИГГЕРЫ---------------------
--Category
CREATE TRIGGER Category_InsertTrigger
ON Category
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewID INT;
    SELECT @NewID = NEXT VALUE FOR Category_ID_Seq;
    
    INSERT INTO Category (ID_Category, Category_Name)
    SELECT @NewID, Category_Name
    FROM inserted;
END;

--Item
CREATE TRIGGER Item_InsertTrigger
ON Item
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewID INT;
    SELECT @NewID = NEXT VALUE FOR Item_ID_Seq;
    
    INSERT INTO Item (ID_Item, Item_Name, Item_Category, Item_Price, Item_Quantity, Item_Describe, Item_Supplier)
    SELECT @NewID, Item_Name, Item_Category, Item_Price, Item_Quantity, Item_Describe, Item_Supplier
    FROM inserted;
END;

--Orders
CREATE TRIGGER Orders_InsertTrigger
ON Orders
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewID INT;
    SELECT @NewID = NEXT VALUE FOR Orders_ID_Seq;
    
    INSERT INTO Orders (ID_Orders, Ord_ID_Item, NumberOrderedItems)
    SELECT @NewID, Ord_ID_Item, NumberOrderedItems
    FROM inserted;
END;

--OrderInf
CREATE TRIGGER OrderInf_InsertTrigger
ON OrderInf
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewID INT;
    SELECT @NewID = NEXT VALUE FOR OrderInf_ID_Seq;
    
    INSERT INTO OrderInf (ID_Order, Order_Date, Delivery_Time, Order_status, Amount, ID_Courier)
    SELECT @NewID, Order_Date, Delivery_Time, Order_status, Amount, ID_Courier
    FROM inserted;
END;

--Courier
CREATE TRIGGER Courier_InsertTrigger
ON Courier
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @NewID INT;
    SELECT @NewID = NEXT VALUE FOR Courier_ID_Seq;
    
    INSERT INTO Courier (ID_Courier, Courier_Name, Courier_Email, Courier_Number, Courier_Adress)
    SELECT @NewID, Courier_Name, Courier_Email, Courier_Number, Courier_Adress
    FROM inserted;
END;

-- Вывести информацию о триггерах в базе данных
SELECT
    t.name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    OBJECTPROPERTY(object_id, 'ExecIsInsteadOfTrigger') AS IsInsteadOfTrigger
FROM sys.triggers AS t;

-- Вывести информацию о последовательностях в базе данных
SELECT
    name AS SequenceName,
    start_value AS StartValue,
    increment AS IncrementValue
FROM sys.sequences;

-- Вывести информацию о представлениях в базе данных
SELECT
    TABLE_NAME AS ViewName
FROM INFORMATION_SCHEMA.VIEWS;

-- Вывести информацию о индексах в базе данных
SELECT
    OBJECT_NAME(OBJECT_ID) AS TableName,
    name AS IndexName,
    type_desc AS IndexType,
    is_unique AS IsUnique,
    is_primary_key AS IsPrimaryKey
FROM sys.indexes;
