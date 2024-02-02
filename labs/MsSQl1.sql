--Create database MSCHOIAD_labs

-- Категория товара
CREATE TABLE Category (
    ID_Category INT PRIMARY KEY, 
    Category_Name NVARCHAR(100) NOT NULL
);

-- Поставщик
CREATE TABLE Supplier (
    ID_Supplier INT PRIMARY KEY,
    Supplier_Name NVARCHAR(255) NOT NULL,
    Supplier_Email NVARCHAR(255) NOT NULL,
    Supplier_Number NVARCHAR(20) NOT NULL,
    Supplier_Adress NVARCHAR(255) NOT NULL
);

-- Cклад
CREATE TABLE Warehouse (
    ID_Warehouse INT PRIMARY KEY,
    Warehouse_Address NVARCHAR(255) NOT NULL
);

-- Товары
CREATE TABLE Item (
    ID_Item INT PRIMARY KEY,
    Item_Name NVARCHAR(255) NOT NULL,
    Item_Category INT NOT NULL,
    Item_Price DECIMAL(10, 2) NOT NULL,
    Item_Quantity INT NOT NULL,
    Item_Describe NVARCHAR(500) NOT NULL,
    Item_Supplier INT NOT NULL,  -- Внешний ключ к "Поставщики"
    FOREIGN KEY (Item_Category) REFERENCES Category(ID_Category),
    FOREIGN KEY (Item_Supplier) REFERENCES Supplier(ID_Supplier)
);

-- Заказы
CREATE TABLE OrdersSklad (
    ID_Orders INT PRIMARY KEY,
    Ord_ID_Item INT NOT NULL,  -- Внешний ключ к "Товары"
    NumberOrderedItems INT NOT NULL,
    FOREIGN KEY (Ord_ID_Item) REFERENCES Item(ID_Item)
);

-- Создание таблицы "Курьеры"
CREATE TABLE Courier (
    ID_Courier INT PRIMARY KEY,
    Courier_Name NVARCHAR(255) NOT NULL,
    Courier_Email  NVARCHAR(255) NOT NULL,
    Courier_Number NVARCHAR(20) NOT NULL,
	Courier_Adress NVARCHAR(255) NOT NULL
);

-- Информация о заказе
CREATE TABLE OrderInfSklad (
    ID_Order INT PRIMARY KEY,
    Order_Date DATETIME NOT NULL,
    Delivery_Time DATETIME NOT NULL,
    Order_status NVARCHAR(50) CHECK (Order_status IN ('Принят на обработку', 'Собрано', 'Отправлено', 'Доставлено')),
    Amount DECIMAL(10, 2) NOT NULL,
	ID_Courier INT NOT NULL, 
    FOREIGN KEY (ID_Order) REFERENCES OrdersSklad(ID_Orders),
	FOREIGN KEY (ID_Courier) REFERENCES Courier(ID_Courier)
);

-- Места хранения
CREATE TABLE StorageLocation (
    ID_Location INT PRIMARY KEY,
    Warehouse INT NOT NULL,  -- Внешний ключ к "Cклад"
    Loc_Row INT NOT NULL,
    Loc_Place INT NOT NULL,
    Loc_ItemID INT NOT NULL,  -- Внешний ключ к "Товары"
    FOREIGN KEY (Warehouse) REFERENCES Warehouse(ID_Warehouse),
    FOREIGN KEY (Loc_ItemID) REFERENCES Item(ID_Item)
);


Drop database MSCHOIAD_labs

DROP TABLE Category;
DROP TABLE Supplier;
DROP TABLE Warehouse;
DROP TABLE Item;
DROP TABLE Orders;
DROP TABLE OrderInf;
DROP TABLE StorageLocation;
DROP TABLE Courier;
