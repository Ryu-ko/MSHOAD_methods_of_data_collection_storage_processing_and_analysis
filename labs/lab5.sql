--опредедение всех сущностей, которые существуют


SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA

-- 6 TASK datatype
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
 
-- 7 TASK SRID --уникальный идентификатор пространственной системы координат в базах данных, использующих пространственные данные
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ne_50m_admin_0_countries' AND DATA_TYPE = 'geometry'

select distinct geom.STSrid as SRID from [ne_50m_admin_0_countries] 


-- 8 TASK аттрибутивные столбцы содержат атриб. инф. о географ объектах(точками, линиями, полигонами и тд)
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND DATA_TYPE <> 'geometry'

-- 9 TASK WRT--текстовый формат для представления пространственных объектов
SELECT geom.STAsText() AS WKT_Description--метод, возвращает представление таблицы в текстовом формате WKT.
FROM [ne_50m_admin_0_countries]

-- 10 TASKS
select * from [ne_50m_admin_0_countries]

-- 10.1 Intersaction
DECLARE @polygonGeometry1 GEOMETRY;
SET @polygonGeometry1 = GEOMETRY::STGeomFromText('POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))', 0);

DECLARE @polygonGeometry2 GEOMETRY;
SET @polygonGeometry2 = GEOMETRY::STGeomFromText('POLYGON((35 10, 45 45, 15 40, 10 20, 35 10))', 0);

SELECT @polygonGeometry1.STIntersection(@polygonGeometry2) AS Intersection --STIntersection, который возвращает геометрический объект, представляющий собой пересечение между геометрическим объектом в obj1.geom и объектом в obj2.geom.
FROM [ne_50m_admin_0_countries] @polygonGeometry1, [ne_50m_admin_0_countries] @polygonGeometry2
WHERE @polygonGeometry1.qgs_fid = 1 AND @polygonGeometry2.qgs_fid = 2


-- 10.2 Union

SELECT obj1.geom.STUnion(obj2.geom) AS [Union] --объединение геометрических объектов
FROM [ne_50m_admin_0_countries] obj1, [ne_50m_admin_0_countries] obj2
WHERE obj1.qgs_fid = 3 AND obj2.qgs_fid = 2

-- 10.3 WithIn 

SELECT obj1.geom.STWithin(obj2.geom) AS [IsWithin] --возвращает 1 (True), если геометрический объект obj1 находится внутри геометрического объекта obj2, 
												-- 0 (False) в противном случае. Результат помещается в столбец с именем [IsWithin].
FROM [ne_50m_admin_0_countries] obj1, [ne_50m_admin_0_countries] obj2
WHERE obj1.qgs_fid = 1 AND obj2.qgs_fid = 2

-- 10.4 Simplified (не поддерживается, использовал Reduce)

SELECT geom.Reduce(0.1) AS Simplified --насколько сильно должен быть упрощен геометрический объект
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 6

-- 10.5 VertexCoordinates

SELECT geom.STPointN(1).ToString() AS VertexCoordinates -- извлекает первую точку (вершину) из геометрического объекта в столбце geom.
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 6

-- 10.6 ObjectDimension 

SELECT geom.STDimension() AS ObjectDimension--возвращает размерность геометрического объекта. Размерность может быть 0 для точек, 1 для линий, 2 для полигонов и тд
FROM [ne_50m_admin_0_countries]
WHERE qgs_fid = 3

-- 10.7 ObjectLength, ObjectArea 

SELECT geom.STLength() AS ObjectLength, geom.STArea() AS ObjectArea --STLength метод, который возвращает длину (или периметр) геометрического объекта.
FROM [ne_50m_admin_0_countries]                                     --STArea метод, который возвращает площадь геометрического объекта.
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

-- точка и полигон
DECLARE @point GEOMETRY = GEOMETRY::STGeomFromText('POINT(30 30)', 0);
DECLARE @polygon GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);

SELECT @point.STWithin(@polygon) AS PointWithinPolygon; --определения того, находится ли один геометрический объект внутри другого. 
														--Он возвращает логическое значение 1 (True), если первый объект полностью находится внутри второго,

-- прямая и полигон
DECLARE @line GEOMETRY = GEOMETRY::STGeomFromText('LINESTRING(30 10, 10 30, 40 40)', 0);
DECLARE @polygonn GEOMETRY = GEOMETRY::STGeomFromText('POLYGON((20 20, 20 40, 40 40, 40 20, 20 20))', 0);

SELECT @line.STIntersects(@polygonn) AS LineIntersectsPolygon; --пересекаются ли