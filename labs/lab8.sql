------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------2------------------------------------------------------------------------------------

-- Создание объектного типа данных для товаров
CREATE TYPE Item_Type AS OBJECT (
    ID_Item INT,
    Item_Name NVARCHAR2(255),
    Item_Category INT,
    Item_Price DECIMAL(10, 2),
    Item_Quantity INT,
    Item_Describe NVARCHAR2(500),
    Item_Supplier INT,

    -- Дополнительный конструктор
    CONSTRUCTOR FUNCTION Item_Type (
        ID_Item INT,
        Item_Name NVARCHAR2,
        Item_Category INT,
        Item_Price DECIMAL,
        Item_Quantity INT,
        Item_Describe NVARCHAR2,
        Item_Supplier INT
    ) RETURN SELF AS RESULT,

    -- Метод сравнения типа MAP
    MEMBER FUNCTION compare (other IN Item_Type) RETURN VARCHAR2,

    -- Метод экземпляра функции
    MEMBER FUNCTION get_item_name RETURN NVARCHAR2,

    -- Метод экземпляра процедуры
    MEMBER PROCEDURE update_quantity (new_quantity IN INT)
);

-- Дополнительный конструктор
CREATE TYPE BODY Item_Type AS
    CONSTRUCTOR FUNCTION Item_Type (
        ID_Item INT,
        Item_Name NVARCHAR2,
        Item_Category INT,
        Item_Price DECIMAL,
        Item_Quantity INT,
        Item_Describe NVARCHAR2,
        Item_Supplier INT
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ID_Item := ID_Item;
        SELF.Item_Name := Item_Name;
        SELF.Item_Category := Item_Category;
        SELF.Item_Price := Item_Price;
        SELF.Item_Quantity := Item_Quantity;
        SELF.Item_Describe := Item_Describe;
        SELF.Item_Supplier := Item_Supplier;
        RETURN;
    END;
    
    -- Метод сравнения типа MAP
    MEMBER FUNCTION compare (other IN Item_Type) RETURN VARCHAR2 IS
    BEGIN
        IF SELF.Item_Price > other.Item_Price THEN
            RETURN 'This item is more expensive';
        ELSIF SELF.Item_Price < other.Item_Price THEN
            RETURN 'This item is less expensive';
        ELSE
            RETURN 'Prices are the same';
        END IF;
    END;

    -- Метод экземпляра функции
    MEMBER FUNCTION get_item_name RETURN NVARCHAR2 IS
    BEGIN
        RETURN SELF.Item_Name;
    END;

    -- Метод экземпляра процедуры
    MEMBER PROCEDURE update_quantity (new_quantity IN INT) IS
    BEGIN
        SELF.Item_Quantity := new_quantity;
    END;
END;

-- Пример использования объекта
DECLARE
    item1 Item_Type := Item_Type(1, 'Item1', 1, TO_NUMBER('10.00', '999.99'), 5, 'Description 1', 101);
    item2 Item_Type := Item_Type(2, 'Item2', 1, TO_NUMBER('15.00', '999.99'), 8, 'Description 2', 102);
BEGIN
    -- Вызов метода сравнения
    DBMS_OUTPUT.PUT_LINE('Comparison Result: ' || item1.compare(item2));

    -- Вызов метода экземпляра функции
    DBMS_OUTPUT.PUT_LINE('Item Name: ' || item1.get_item_name);

    -- Вызов метода экземпляра процедуры
    DBMS_OUTPUT.PUT_LINE('Old Quantity: ' || item1.Item_Quantity);
    item1.update_quantity(7);
    DBMS_OUTPUT.PUT_LINE('Updated Quantity: ' || item1.Item_Quantity);
END;
/
    
            -----StorageLocation-------
        
-- Создание объектного типа данных для Места хранения
CREATE TYPE StorageLocation_Type AS OBJECT (
    ID_Location INT,
    Warehouse INT,
    Loc_Row INT,
    Loc_Place INT,
    Loc_ItemID INT,

    -- Дополнительный конструктор
    CONSTRUCTOR FUNCTION StorageLocation_Type (
        ID_Location INT,
        Warehouse INT,
        Loc_Row INT,
        Loc_Place INT,
        Loc_ItemID INT
    ) RETURN SELF AS RESULT,

    -- Метод сравнения типа MAP
    MEMBER FUNCTION compare (other IN StorageLocation_Type) RETURN VARCHAR2,

    -- Метод экземпляра функции
    MEMBER FUNCTION get_location_info RETURN NVARCHAR2,

    -- Метод экземпляра процедуры
    MEMBER PROCEDURE update_location (new_row INT, new_place INT)
);

-- Дополнительный конструктор
CREATE TYPE BODY StorageLocation_Type AS
    CONSTRUCTOR FUNCTION StorageLocation_Type (
        ID_Location INT,
        Warehouse INT,
        Loc_Row INT,
        Loc_Place INT,
        Loc_ItemID INT
    ) RETURN SELF AS RESULT IS
    BEGIN
        SELF.ID_Location := ID_Location;
        SELF.Warehouse := Warehouse;
        SELF.Loc_Row := Loc_Row;
        SELF.Loc_Place := Loc_Place;
        SELF.Loc_ItemID := Loc_ItemID;
        RETURN;
    END;

    -- Метод сравнения типа MAP
    MEMBER FUNCTION compare (other IN StorageLocation_Type) RETURN VARCHAR2 IS
    BEGIN
        IF SELF.Warehouse = other.Warehouse AND
           SELF.Loc_Row = other.Loc_Row AND
           SELF.Loc_Place = other.Loc_Place AND
           SELF.Loc_ItemID = other.Loc_ItemID THEN
            RETURN 'Locations are the same';
        ELSE
            RETURN 'Locations are different';
        END IF;
    END;

    -- Метод экземпляра функции
    MEMBER FUNCTION get_location_info RETURN NVARCHAR2 IS
    BEGIN
        RETURN 'Warehouse: ' || TO_CHAR(SELF.Warehouse) ||
               ', Row: ' || TO_CHAR(SELF.Loc_Row) ||
               ', Place: ' || TO_CHAR(SELF.Loc_Place) ||
               ', ItemID: ' || TO_CHAR(SELF.Loc_ItemID);
    END;

    -- Метод экземпляра процедуры
    MEMBER PROCEDURE update_location (new_row INT, new_place INT) IS
    BEGIN
        SELF.Loc_Row := new_row;
        SELF.Loc_Place := new_place;
    END;
END;
/

-- Пример использования объекта для Места хранения
DECLARE
    location1 StorageLocation_Type := StorageLocation_Type(1, 101, 1, 1, 1001);
    location2 StorageLocation_Type := StorageLocation_Type(2, 102, 2, 2, 1002);
BEGIN
    -- Вывод информации о Месте хранения
    DBMS_OUTPUT.PUT_LINE('Location 1 Info: ' || location1.get_location_info);
    DBMS_OUTPUT.PUT_LINE('Location 2 Info: ' || location2.get_location_info);

    -- Вызов метода сравнения
    DBMS_OUTPUT.PUT_LINE('Comparison Result: ' || location1.compare(location2));

    -- Вызов метода экземпляра процедуры
    DBMS_OUTPUT.PUT_LINE('Old Row and Place: ' || location1.Loc_Row || ', ' || location1.Loc_Place);
    location1.update_location(3, 4);
    DBMS_OUTPUT.PUT_LINE('Updated Row and Place: ' || location1.Loc_Row || ', ' || location1.Loc_Place);
END;
/

------------------------------------------------------------------------------------------------------------
--------------------------3. Скопировать данные из реляционных таблиц в объектные.-------------------------------------------------------------
------создание объектов, представляющих отдельные строки в бд, с исп инф, извлеченной из соотв реляционных таблиц.----------------------------------------------------------------------------------------

DECLARE
    item_obj Item_Type; -- Инициализируем объект типа Item_Type
BEGIN
    FOR item_rec IN (SELECT ID_Item, Item_Name, Item_Category, Item_Price, Item_Quantity, Item_Describe, Item_Supplier FROM Item) 
    LOOP
        -- Присваиваем значения полей объекта из записи курсора
        item_obj := Item_Type(
            ID_Item       => item_rec.ID_Item, --явного указания имени параметра 
            Item_Name     => item_rec.Item_Name,
            Item_Category => item_rec.Item_Category,
            Item_Price    => item_rec.Item_Price,
            Item_Quantity => item_rec.Item_Quantity,
            Item_Describe => item_rec.Item_Describe,
            Item_Supplier => item_rec.Item_Supplier
        );

        -- Здесь можно выполнять дополнительные операции с объектом, если это необходимо
        -- Например, вывод информации о товаре
        DBMS_OUTPUT.PUT_LINE('Item Name: ' || item_obj.get_item_name);

        -- Далее, вы можете использовать объект item_obj по вашему усмотрению
    END LOOP;
END;

            ----Storage Location-------
            
DECLARE
    location_obj StorageLocation_Type; -- Инициализируем объект типа StorageLocation_Type
BEGIN
    FOR location_rec IN (SELECT ID_Location, Warehouse, Loc_Row, Loc_Place, Loc_ItemID FROM StorageLocation) 
    LOOP
        -- Присваиваем значения полей объекта из записи курсора
        location_obj := StorageLocation_Type(
            ID_Location => location_rec.ID_Location,
            Warehouse   => location_rec.Warehouse,
            Loc_Row     => location_rec.Loc_Row,
            Loc_Place   => location_rec.Loc_Place,
            Loc_ItemID  => location_rec.Loc_ItemID
        );

        -- Здесь можно выполнять дополнительные операции с объектом, если это необходимо
        -- Например, вывод информации о месте хранения
        DBMS_OUTPUT.PUT_LINE('Location Info: ' || location_obj.get_location_info);

        -- Далее, вы можете использовать объект location_obj по вашему усмотрению
    END LOOP;
END;
            
------------------------------------------------------------------------------------------------------------
--------------------------4.Продемонстрировать применение объектных представлений.-------------------------------------------------------------
----------------------------------------------------------------------------------------------

-- Создаем объектное представление для таблицы Item
CREATE OR REPLACE VIEW Item_View AS
SELECT
    Item_Type(ID_Item, Item_Name, Item_Category, Item_Price, Item_Quantity, Item_Describe, Item_Supplier) AS item_obj
FROM Item;

-- Создаем объектное представление для таблицы StorageLocation
CREATE OR REPLACE VIEW StorageLocation_View AS
SELECT
    StorageLocation_Type(ID_Location, Warehouse, Loc_Row, Loc_Place, Loc_ItemID) AS location_obj
FROM StorageLocation;


SELECT object_name, object_type
FROM user_objects
WHERE object_type = 'VIEW'
  AND object_name IN ('ITEM_VIEW', 'STORAGELOCATION_VIEW');

------------------------------------------------------------------------------------------------------------------------------------------------
-----5.Продемонстрировать применение индексов для индексирования по атрибуту и по методу в объектной таблице.-------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
-- Создание таблицы с объектным типом данных
CREATE TABLE Item_Table OF Item_Type;

INSERT INTO Item_Table
SELECT Item_Type(ID_Item, Item_Name, Item_Category, Item_Price, Item_Quantity, Item_Describe, Item_Supplier)
FROM Item;

select * from Item_Table;

-- Создание индекса на атрибут Item_Price
CREATE INDEX idx_Item_Price ON Item_Table (Item_Price);

-- Пример запроса с использованием индекса на атрибут
SELECT * FROM Item_Table WHERE Item_Price > 30.00;

  ----StorageLocation----
  
-- Создание объектной таблицы
CREATE TABLE StorageLocation_Table OF StorageLocation_Type;

-- Создание метода get_location_info
CREATE TYPE BODY StorageLocation_Type AS
    MEMBER FUNCTION get_location_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Warehouse: ' || TO_CHAR(Warehouse) ||
               ', Row: ' || TO_CHAR(Loc_Row) ||
               ', Place: ' || TO_CHAR(Loc_Place) ||
               ', ItemID: ' || TO_CHAR(Loc_ItemID);
    END;
END;

-- Вставка данных в объектную таблицу из соответствующей таблицы
INSERT INTO StorageLocation_Table
SELECT StorageLocation_Type(ID_Location, Warehouse, Loc_Row, Loc_Place, Loc_ItemID)
FROM StorageLocation;

-- Вывод данных из объектной таблицы
SELECT * FROM StorageLocation_Table;

-- Создание индекса на атрибут Warehouse
CREATE INDEX idx_Warehouse ON StorageLocation_Table (Warehouse);

-- Пример запроса с использованием индекса на атрибут Warehouse
SELECT * FROM StorageLocation_Table WHERE Warehouse = 2;


