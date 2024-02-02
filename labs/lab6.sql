

SELECT
    name AS LogicalName,
    physical_name AS PhysicalPath
FROM sys.master_files
WHERE database_id = DB_ID('5sem');

-- Создание таблицы Users
CREATE TABLE Users (
    UserID INTEGER PRIMARY KEY,
    FirstName TEXT,
    LastName TEXT,
    Username TEXT,
    Email TEXT,
    Role TEXT,
    UserFullName AS (FirstName || ' ' || LastName) -- Денормализованный атрибут
);

-- Создание таблицы Requests
CREATE TABLE Requests (
    RequestID INTEGER PRIMARY KEY,
    Title TEXT,
    Description TEXT,
    Status TEXT,
    Priority TEXT,
    CreatedAt TEXT,
    UpdatedAt TEXT,
    UserID INTEGER,
    UserFullName TEXT, -- Денормализованный атрибут
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Создание таблицы Incidents
CREATE TABLE Incidents (
    IncidentID INTEGER PRIMARY KEY,
    Title TEXT,
    Description TEXT,
    Status TEXT,
    Priority TEXT,
    CreatedAt TEXT,
    ClosedAt TEXT,
    UserID INTEGER,
    UserFullName TEXT, -- Денормализованный атрибут
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Создание таблицы Comments
CREATE TABLE Comments (
    CommentID INTEGER PRIMARY KEY,
    Text TEXT,
    CreatedAt TEXT,
    UserID INTEGER,
    UserFullName TEXT, -- Денормализованный атрибут
    RequestID INTEGER,
    IncidentID INTEGER,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RequestID) REFERENCES Requests(RequestID),
    FOREIGN KEY (IncidentID) REFERENCES Incidents(IncidentID)
);

-- Создание таблицы KnowledgeBase
CREATE TABLE KnowledgeBase (
    ArticleID INTEGER PRIMARY KEY,
    Title TEXT,
    Content TEXT,
    Category TEXT,
    CreatedAt TEXT
);

-- Создание таблицы Reports
CREATE TABLE Reports (
    ReportID INTEGER PRIMARY KEY,
    ReportType TEXT,
    CreatedAt TEXT,
    ReportData TEXT,
    UserID INTEGER,
    UserFullName TEXT, -- Денормализованный атрибут
    RequestType TEXT, -- Денормализованный атрибут
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Добавление столбца KnowledgeBaseID в таблицу Requests
ALTER TABLE Requests
ADD COLUMN KnowledgeBaseID INTEGER;

-- Создание связи между столбцами KnowledgeBaseID в таблицах Requests и KnowledgeBase
UPDATE Requests
SET KnowledgeBaseID = NULL;


-- Добавление данных в таблицу Users
INSERT INTO Users (UserID, FirstName, LastName, Username, Email, Role)
VALUES (1, 'Halwa', 'halwa', 'johndoe', 'Halwa@example.com', 'Admin'),
       (2, 'Senya', 'palaz', 'alicesmith', 'Senya@example.com', 'User'),
       (3, 'VlaD', 'vekulenchik', 'bobjohnson', 'VlaD@example.com', 'User');

-- Добавление данных в таблицу Requests
INSERT INTO Requests (RequestID, Title, Description, Status, Priority, CreatedAt, UpdatedAt, UserID, UserFullName, KnowledgeBaseID)
VALUES (1, 'Request  1', ' description 1', 'Open', 'High', '2023-10-30', '2023-11-01', 1, 'John Doe', NULL),
       (2, 'Request  2', ' description 2', 'Closed', 'Medium', '2023-10-31', '2023-11-02', 2, 'Alice Smith', NULL),
       (3, 'Request  3', ' description 3', 'Open', 'Low', '2023-11-01', '2023-11-03', 3, 'Bob Johnson', NULL);

-- Добавление данных в таблицу Incidents
INSERT INTO Incidents (IncidentID, Title, Description, Status, Priority, CreatedAt, ClosedAt, UserID, UserFullName)
VALUES (1, 'Incident  1', ' description 1', 'Open', 'High', '2023-10-30', '2023-11-01', 1, 'John Doe'),
       (2, 'Incident  2', ' description 2', 'Closed', 'Medium', '2023-10-31', '2023-11-02', 2, 'Alice Smith'),
       (3, 'Incident  3', ' description 3', 'Open', 'Low', '2023-11-01', '2023-11-03', 3, 'Bob Johnson');

-- Добавление данных в таблицу Comments
INSERT INTO Comments (CommentID, Text, CreatedAt, UserID, UserFullName, RequestID, IncidentID)
VALUES (1, 'Comment  1', '2023-10-30', 1, 'John Doe', 1, NULL),
       (2, 'Comment  2', '2023-10-31', 2, 'Alice Smith', NULL, 1),
       (3, 'Comment  3', '2023-11-01', 3, 'Bob Johnson', NULL, 2);

-- Добавление данных в таблицу KnowledgeBase
INSERT INTO KnowledgeBase (ArticleID, Title, Content, Category, CreatedAt)
VALUES (1, 'Article  1', ' content 1', 'Category 1', '2023-10-30'),
       (2, 'Article  2', ' content 2', 'Category 2', '2023-10-31'),
       (3, 'Article  3', ' content 3', 'Category 3', '2023-11-01');

-- Добавление данных в таблицу Reports
INSERT INTO Reports (ReportID, ReportType, CreatedAt, ReportData, UserID, UserFullName, RequestType)
VALUES (1, 'Report Type 1', '2023-10-30', 'Report data 1', 1, 'John Doe', 'Type A'),
       (2, 'Report Type 2', '2023-10-31', 'Report data 2', 2, 'Alice Smith', 'Type B'),
       (3, 'Report Type 3', '2023-11-01', 'Report data 3', 3, 'Bob Johnson', 'Type C');


-- Обновление данных в подчиненной таблице
BEGIN TRANSACTION;

UPDATE Requests SET Status = 'In Progress' WHERE RequestID = 1;

COMMIT;

Select * from Requests
-- Добавление данных в подчиненную таблицу
BEGIN TRANSACTION;

INSERT INTO Comments (CommentID, Text, CreatedAt, UserID, UserFullName, RequestID)
VALUES (4, 'Additional comment', '2023-11-04', 1, 'John Doe', 1);

COMMIT;

-- Удаление данных из подчиненной таблицы
BEGIN TRANSACTION;

DELETE FROM Comments WHERE IncidentID = 2;

COMMIT;



-- Предаставление на 2 таблицы
CREATE VIEW RequestsAndUsers AS
SELECT
    r.RequestID,
    r.Title,
    r.Description,
    r.Status,
    r.Priority,
    r.CreatedAt,
    r.UpdatedAt,
    r.UserID AS RequestUserID,
    r.UserFullName AS RequestUserFullName,
    u.FirstName AS UserFirstName,
    u.LastName AS UserLastName,
    u.Username AS UserUsername,
    u.Email AS UserEmail,
    u.Role AS UserRole
FROM Requests r
JOIN Users u ON r.UserID = u.UserID;

SELECT * FROM RequestsAndUsers;


-- Пример создания индекса для внешнего ключа UserID в таблице Requests
CREATE INDEX idx_Requests_UserID ON Requests(UserID);

-- Пример создания индекса для внешнего ключа UserID в таблице Incidents
CREATE INDEX idx_Incidents_UserID ON Incidents(UserID);

-- Пример создания индекса для внешнего ключа RequestID в таблице Comments
CREATE INDEX idx_Comments_RequestID ON Comments(RequestID);

-- Пример создания индекса для внешнего ключа IncidentID в таблице Comments
CREATE INDEX idx_Comments_IncidentID ON Comments(IncidentID);

-- Пример создания индекса для внешнего ключа UserID в таблице Comments
CREATE INDEX idx_Comments_UserID ON Comments(UserID);

-- Пример создания индекса для внешнего ключа UserID в таблице Reports
CREATE INDEX idx_Reports_UserID ON Reports(UserID);


-- Создание триггера
CREATE TRIGGER trg_Request_Insert
AFTER INSERT ON Requests
BEGIN
    SELECT 'New row inserted with RequestID: ', new.RequestID, ' and Title: ', new.Title 
    FROM Requests AS new WHERE new.RequestID = NEW.RequestID;
END;

INSERT INTO Requests (RequestID, Title, Description, Status, Priority, CreatedAt, UpdatedAt, UserID, UserFullName)
VALUES (14, 'New RequestIsetr', 'Description', 'Open', 'High', '2023-11-01', '2023-11-01', 1, 'John Doe');



-- Удаление таблицы Reports
DROP TABLE IF EXISTS Reports;

-- Удаление таблицы KnowledgeBase
DROP TABLE IF EXISTS KnowledgeBase;

-- Удаление таблицы Comments
DROP TABLE IF EXISTS Comments;

-- Удаление таблицы Incidents
DROP TABLE IF EXISTS Incidents;

-- Удаление таблицы Requests
DROP TABLE IF EXISTS Requests;

-- Удаление таблицы Users
DROP TABLE IF EXISTS Users;
