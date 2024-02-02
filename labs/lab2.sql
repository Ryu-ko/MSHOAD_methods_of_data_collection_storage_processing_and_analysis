--������������� � ����������� � ������� � ���������� � ������ ����������:
CREATE VIEW ItemDetails AS
	SELECT
		I.ID_Item,
		I.Item_Name,
		C.Category_Name,
		S.Supplier_Name
	FROM Item I
	JOIN Category C ON I.Item_Category = C.ID_Category
	JOIN Supplier S ON I.Item_Supplier = S.ID_Supplier;

-- ������������� ���������� � ������� � �������� ������
CREATE VIEW OrderDetails AS
	SELECT
		O.ID_Orders,
		O.Ord_ID_Item,
		O.NumberOrderedItems,
		I.Item_Name,
		I.Item_Price
	FROM Orders O
	JOIN Item I ON O.Ord_ID_Item = I.ID_Item;

--������������� ���-�� ������� � �������������� ������� �� ������.
CREATE VIEW InventoryView AS
SELECT
    I.ID_Item,
    I.Item_Name,
    I.Item_Quantity,
    SL.Loc_Row,
    SL.Loc_Place
FROM Item I
JOIN StorageLocation SL ON I.ID_Item = SL.Loc_ItemID;

--����� ��������� ������� � ��������� ������� �������.
CREATE VIEW OrderTotalCostView AS
SELECT
    OI.ID_Order,
    OI.Order_Date,
    SUM(O.NumberOrderedItems * I.Item_Price) AS TotalCost
FROM Orders O
JOIN Item I ON O.Ord_ID_Item = I.ID_Item
JOIN OrderInf OI ON O.ID_Orders = OI.ID_Order
GROUP BY OI.ID_Order, OI.Order_Date;

---------------------------�������---------------------------------------------------------
--������ ��� ������� Item �� ������� Item_Category:
	--������� �������� ����� ������� �� ���������.
CREATE INDEX IX_Item_ItemCategory ON Item(Item_Category);

--������ ��� ������� Orders �� ������� Ord_ID_Item:
	--�������� ������������������ ��������, ��������� � �������� � ��������.
CREATE INDEX IX_Orders_OrdIDItem ON Orders(Ord_ID_Item);

--������ ��� ������� StorageLocation �� ������� Loc_ItemID:
	--������� �������� ������ � ������ � ��������������� ������� �� ������.
CREATE INDEX IX_StorageLocation_LocItemID ON StorageLocation(Loc_ItemID);

--������ ��� ������� OrderInf �� ������� Order_Date:
	--������� �������� �������, ��������� � ������� ������� �� ����.
CREATE INDEX IX_OrderInf_OrderDate ON OrderInf(Order_Date);

-------------------------������������������-----------------------------------------------

-- ������������������ ��� ������� Category
CREATE SEQUENCE Category_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- ������������������ ��� ������� Item
CREATE SEQUENCE Item_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- ������������������ ��� ������� Orders
CREATE SEQUENCE Orders_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- ������������������ ��� ������� Courier
CREATE SEQUENCE Courier_ID_Seq
    START WITH 1
    INCREMENT BY 1;

-- ������������������ ��� ������� OrderInf
CREATE SEQUENCE OrderInf_ID_Seq
    START WITH 1
    INCREMENT BY 1;

DROP SEQUENCE Category_ID_Seq;
DROP SEQUENCE Item_ID_Seq;
DROP SEQUENCE Orders_ID_Seq;
DROP SEQUENCE OrderInf_ID_Seq;
DROP SEQUENCE Courier_ID_Seq;

------------------��������---------------------
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

-- ������� ���������� � ��������� � ���� ������
SELECT
    t.name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    OBJECTPROPERTY(object_id, 'ExecIsInsteadOfTrigger') AS IsInsteadOfTrigger
FROM sys.triggers AS t;

-- ������� ���������� � ������������������� � ���� ������
SELECT
    name AS SequenceName,
    start_value AS StartValue,
    increment AS IncrementValue
FROM sys.sequences;

-- ������� ���������� � �������������� � ���� ������
SELECT
    TABLE_NAME AS ViewName
FROM INFORMATION_SCHEMA.VIEWS;

-- ������� ���������� � �������� � ���� ������
SELECT
    OBJECT_NAME(OBJECT_ID) AS TableName,
    name AS IndexName,
    type_desc AS IndexType,
    is_unique AS IsUnique,
    is_primary_key AS IsPrimaryKey
FROM sys.indexes;
