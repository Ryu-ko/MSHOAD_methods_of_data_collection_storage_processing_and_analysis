-- 3.1 

ALTER TABLE Warehouse
add nodee hierarchyid,
LEVELL as nodee.GetLevel() persisted;


INSERT INTO Warehouse VALUES
  (3,'aDRESS', hierarchyid::GetRoot()),
  (4,'Adress', hierarchyid::GetRoot());
go
select * FROM Warehouse;

-- ����������� ������������� ����
DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/');

DECLARE @NewNodePath hierarchyid;
SET @NewNodePath = @ParentNodePath.GetDescendant (NULL, NULL); -- �������� ������ ���� ����� ������������ � �������� �����.

-- ������� ����� ������ � ��������� ������������� ����
INSERT INTO Warehouse VALUES (5,'Ul Fouxchs 12', @NewNodePath); 
go
select * from Warehouse;

-- 3.2
CREATE PROCEDURE DisplayNodes
    @NodePath hierarchyid
AS
BEGIN
    SELECT
        ID_Warehouse,
        Warehouse_Address,
        nodee.ToString() AS NodePath,
        nodee.GetLevel() AS NodeLevel
    FROM
        Warehouse 
    WHERE
        nodee.IsDescendantOf(@NodePath) = 1 --��������, �������� �� ���� �������� �������.
    ORDER BY nodee;
END;
--drop procedure DisplayNodes
go

DECLARE @NodePath hierarchyid;
SET @NodePath = hierarchyid::Parse('/');

EXEC DisplayNodes @NodePath;
go

-- 3.3
CREATE PROCEDURE AddNode
    @ParentNodePath hierarchyid, 
    @NewNodeName NVARCHAR(100)
AS
BEGIN
    DECLARE @LastChild hierarchyid;    
	
	DECLARE @new_wareh_id INT;
	
	 SET @new_wareh_id = (select top 1 ID_Warehouse from Warehouse order by ID_Warehouse desc) + 1;


    -- Get the last child node under the parent
    SELECT TOP 1 @LastChild = nodee
    FROM Warehouse
    WHERE nodee.GetAncestor(1) = @ParentNodePath --��������� ������ ���� �� ��������� ������� 
    ORDER BY nodee DESC;

    DECLARE @NewNodePath hierarchyid;
    -- Use the last child as the first parameter to GetDescendant
    SET @NewNodePath = @ParentNodePath.GetDescendant(@LastChild, NULL);

    INSERT INTO Warehouse (ID_Warehouse,Warehouse_Address, nodee)
    VALUES (@new_wareh_id, @NewNodeName, @NewNodePath);
END;
--drop procedure AddNode
go

DECLARE @ParentNodePath hierarchyid;
SET @ParentNodePath = hierarchyid::Parse('/5/2/'); 
EXEC AddNode @ParentNodePath, 'Apt 192 Kio';
go

-- 3.4
CREATE PROCEDURE TransportNode
    @SourceNodePath hierarchyid,
    @DestinationNodePath hierarchyid
AS
BEGIN    
    UPDATE Warehouse
    SET nodee = nodee.GetReparentedValue(@SourceNodePath, @DestinationNodePath)
    WHERE nodee.IsDescendantOf(@SourceNodePath) = 1;
END;
go

DECLARE @SourceNodePath hierarchyid;
SET @SourceNodePath = hierarchyid::Parse('/8/2/'); 

DECLARE @DestinationNodePath hierarchyid;
SET @DestinationNodePath = hierarchyid::Parse('/7/'); 

EXEC TransportNode @SourceNodePath, @DestinationNodePath;
go

DECLARE @NodePath hierarchyid;
SET @NodePath = hierarchyid::Parse('/');

EXEC DisplayNodes @NodePath;
go

Truncate Table Warehouse