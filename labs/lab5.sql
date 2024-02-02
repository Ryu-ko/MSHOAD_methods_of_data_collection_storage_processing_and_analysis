--����������� ���� ���������, ������� ����������


SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA

-- 6 TASK datatype
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
 
-- 7 TASK SRID --���������� ������������� ���������������� ������� ��������� � ����� ������, ������������ ���������������� ������
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ne_50m_admin_0_countries' AND DATA_TYPE = 'geometry'

select distinct geom.STSrid as SRID from [ne_50m_admin_0_countries] 


-- 8 TASK ������������� ������� �������� �����. ���. � ������� ��������(�������, �������, ���������� � ��)
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE <> 'geometry'

-- 9 TASK WRT--��������� ������ ��� ������������� ���������������� ��������
SELECT geom.STAsText() AS WKT_Description--�����, ���������� ������������� ������� � ��������� ������� WKT.
FROM [ne_50m_admin_0_countries]

-- 10 TASKS
select * from [ne_50m_admin_0_countries]

-- 10.1 Intersaction
DECLARE @polygonGeometry1 GEOMETRY;
SET @polygonGeometry1 = GEOMETRY::STGeomFromText('POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))', 0);

DECLARE @polygonGeometry2 GEOMETRY;
SET @polygonGeometry2 = GEOMETRY::STGeomFromText('POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))', 0);

SELECT @polygonGeometry1.STIntersection(@polygonGeometry2) AS Intersection --STIntersection, ������� ���������� �������������� ������, �������������� ����� ����������� ����� �������������� �������� � obj1.geom � �������� � obj2.geom.
FROM [ne_50m_admin_0_countries] @polygonGeometry1, [ne_50m_admin_0_countries] @polygonGeometry2
WHERE @polygonGeometry1.qgs_fid = 1 AND @polygonGeometry2.qgs_fid = 2


-- 10.2 Union

SELECT obj1.geom.STUnion(obj2.geom) AS [Union] --����������� �������������� ��������
FROM [ne_50m_admin_0_countries] obj1, [ne_50m_admin_0_countries] obj2
WHERE obj1.qgs_fid = 3 AND obj2.qgs_fid = 2

-- 10.3 WithIn 

SELECT obj1.geom.STWithin(obj2.geom) AS [IsWithin] --���������� 1 (True), ���� �������������� ������ obj1 ��������� ������ ��������������� ������� obj2, 
												-- 0 (False) � ��������� ������. ��������� ���������� � ������� � ������ [IsWithin].
FROM [ne_50m_admin_0_countries] obj1, [ne_50m_admin_0_countries] obj2
WHERE obj1.qgs_fid = 1 AND obj2.qgs_fid = 2

-- 10.4 Simplified (�� ��������������, ����������� Reduce)

SELECT geom.Reduce(0.1) AS Simplified --��������� ������ ������ ���� ������� �������������� ������
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 6

-- 10.5 VertexCoordinates

SELECT geom.STPointN(1).ToString() AS VertexCoordinates -- ��������� ������ ����� (�������) �� ��������������� ������� � ������� geom.
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 6

-- 10.6 ObjectDimension 

SELECT geom.STDimension() AS ObjectDimension--���������� ����������� ��������������� �������. ����������� ����� ���� 0 ��� �����, 1 ��� �����, 2 ��� ��������� � ��
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 3

-- 10.7 ObjectLength, ObjectArea 

SELECT geom.STLength() AS ObjectLength, geom.STArea() AS ObjectArea --STLength �����, ������� ���������� ����� (��� ��������) ��������������� �������.
FROM [ne_50m_admin_0_countries]                                     --STArea �����, ������� ���������� ������� ��������������� �������.
WHERE qgs_fid = 5


-- 10.8 Distance

SELECT obj1.geom.STDistance(obj2.geom) AS Distance
FROM [ne_50m_admin_0_countries] obj1, [ne_50m_admin_0_countries] obj2
WHERE obj1.qgs_fid = 6 AND obj2.qgs_fid = 4


-- 11 point, line, polygon

DECLARE @pointGeometry GEOMETRY;
SET @pointGeometry = GEOMETRY::STGeomFromText('POINT(30 10)', 0);

SELECT @pointGeometry AS PointGeometry;


DECLARE @lineGeometry GEOMETRY;
SET @lineGeometry = GEOMETRY::STGeomFromText('LINESTRING(30 10, 10 30, 40 40)', 0);

SELECT @lineGeometry AS LineGeometry;



DECLARE @polygonGeometry GEOMETRY;
SET @polygonGeometry = GEOMETRY::STGeomFromText('POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))', 0);

SELECT @polygonGeometry AS PolygonGeometry;


-- 12 

-- ����� � �������
DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(30 30)', 0);
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);

SELECT @point.STWithin(@polygon) AS PointWithinPolygon; --����������� ����, ��������� �� ���� �������������� ������ ������ �������. 
														--�� ���������� ���������� �������� 1 (True), ���� ������ ������ ��������� ��������� ������ �������,

-- ������ � �������
DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(30 10, 10 30, 40 40)', 0);
DECLARE @polygonn GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);

SELECT @line.STIntersects(@polygonn) AS LineIntersectsPolygon; --������������ ��