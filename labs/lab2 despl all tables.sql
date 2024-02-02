CREATE VIEW TableAttributes AS
SELECT 
    'Category' AS TableName,
    'ID_Category INT PRIMARY KEY' AS Attribute,
    'Category_Name NVARCHAR(100) NOT NULL' AS Description
UNION
SELECT 
    'Supplier' AS TableName,
    'ID_Supplier INT PRIMARY KEY' AS Attribute,
    'Supplier_Name NVARCHAR(255) NOT NULL, Supplier_Email NVARCHAR(255) NOT NULL, Supplier_Number NVARCHAR(20) NOT NULL, Supplier_Adress NVARCHAR(255) NOT NULL' AS Description
UNION
SELECT 
    'Warehouse' AS TableName,
    'ID_Warehouse INT PRIMARY KEY' AS Attribute,
    'Warehouse_Address NVARCHAR(255) NOT NULL' AS Description
UNION
SELECT 
    'Item' AS TableName,
    'ID_Item INT PRIMARY KEY' AS Attribute,
    'Item_Name NVARCHAR(255) NOT NULL, Item_Category INT NOT NULL (FK to Category), Item_Price DECIMAL(10, 2) NOT NULL, Item_Quantity INT NOT NULL, Item_Describe NVARCHAR(500) NOT NULL, Item_Supplier INT NOT NULL (FK to Supplier)' AS Description
UNION
SELECT 
    'Orders' AS TableName,
    'ID_Orders INT PRIMARY KEY' AS Attribute,
    'Ord_ID_Item INT NOT NULL (FK to Item), NumberOrderedItems INT NOT NULL' AS Description
UNION
SELECT 
    'Courier' AS TableName,
    'ID_Courier INT PRIMARY KEY' AS Attribute,
    'Courier_Name NVARCHAR(255) NOT NULL, Courier_Email NVARCHAR(255) NOT NULL, Courier_Number NVARCHAR(20) NOT NULL, Courier_Adress NVARCHAR(255) NOT NULL' AS Description
UNION
SELECT 
    'OrderInf' AS TableName,
    'ID_Order INT PRIMARY KEY' AS Attribute,
    'Order_Date DATETIME NOT NULL, Delivery_Time DATETIME NOT NULL, Order_status NVARCHAR(50) CHECK (Order_status IN (''Принят на обработку'', ''Собрано'', ''Отправлено'', ''Доставлено'')), Amount DECIMAL(10, 2) NOT NULL, ID_Courier INT NOT NULL (FK to Courier)' AS Description
UNION
SELECT 
    'StorageLocation' AS TableName,
    'ID_Location INT PRIMARY KEY' AS Attribute,
    'Warehouse INT NOT NULL (FK to Warehouse), Loc_Row INT NOT NULL, Loc_Place INT NOT NULL, Loc_ItemID INT NOT NULL (FK to Item)' AS Description;

	SELECT * FROM TableAttributes;

	---------------------------------------------------------------------------------------
	

	SELECT 
    t.TABLE_NAME AS 'Название таблицы',
    c.COLUMN_NAME AS 'Название столбца',
    c.DATA_TYPE AS 'Тип данных',
    CASE
        WHEN c.CHARACTER_MAXIMUM_LENGTH IS NOT NULL THEN 
            c.DATA_TYPE + '(' + CAST(c.CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) + ')'
        ELSE
            c.DATA_TYPE
    END AS 'Тип данных с длиной',
    CASE
        WHEN c.IS_NULLABLE = 'NO' THEN 'NOT NULL'
        ELSE 'NULL'
    END AS 'Ограничение на NULL',
    CASE
        WHEN c.COLUMN_DEFAULT IS NOT NULL THEN 'DEFAULT ' + c.COLUMN_DEFAULT
        ELSE ''
    END AS 'Значение по умолчанию'
FROM INFORMATION_SCHEMA.TABLES t
JOIN INFORMATION_SCHEMA.COLUMNS c ON t.TABLE_NAME = c.TABLE_NAME
WHERE t.TABLE_TYPE = 'BASE TABLE'
ORDER BY t.TABLE_NAME, c.ORDINAL_POSITION;










