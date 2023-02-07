USE master
GO
-- Primero creo la BD con sus archivos principales .mdf y .ldf
DROP DATABASE IF EXISTS LONJA_LRM
GO
CREATE DATABASE LONJA_LRM
ON PRIMARY ( NAME = 'Lonja_LRM_drc',
FILENAME = 'C:\Data\Lonja\Lonja_LRM_drc.mdf' ,
SIZE = 16960KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0)
LOG ON ( NAME = 'Lonja_LRM_drc_log',
FILENAME = 'C:\Data\Lonja\Lonja_LRM_drc.ldf' ,
SIZE = 10345KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
USE LONJA_LRM
GO
-- Creo los filegroups para contener las particiones
ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_barcos_nacionales]
GO
ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_barcos_internacionales]
GO

ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_barcos_locales]
GO

ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_otro_barco]
GO

-- Creo los archivos
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'nacional', FILENAME =
'c:\DATA\Lonja\nacional.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_barcos_nacionales]
GO
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'internacional', FILENAME =
'c:\DATA\Lonja\internacional.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_barcos_internacionales]
GO
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'local', FILENAME =
'c:\DATA\Lonja\local.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_barcos_locales]
GO

ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'otro', FILENAME =
'c:\DATA\Lonja\otro.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_otro_barco]
GO

--Creo una función de partición llamada "FN_origen_barco":
DROP PARTITION FUNCTION FN_origen_barco;
CREATE PARTITION FUNCTION FN_origen_barco (int)
AS RANGE LEFT
FOR VALUES (1,2,3)
GO


--Creo un esquema de partición que asigne los valores de la función
--de partición a cada partición:
DROP PARTITION SCHEME PS_origen_barco;
CREATE PARTITION SCHEME PS_origen_barco
AS PARTITION FN_origen_barco
TO ([FG_barcos_nacionales],[FG_barcos_internacionales],[FG_barcos_locales],[FG_otro_barco])
GO


--Creo un esquema de partición que asigna las particiones de una 
--tabla o índice con particiones a los nuevos grupos de archivos.

-- Tabla particionada
-- Se crea como normalmente, pero con dos requerimientos adicionales:
-- 1. La localización de almacenamiento se la da el esquema de partición
-- 2. Hay que especificar la columna que se utilizará para particionar
DROP TABLE IF EXISTS Barco
GO
CREATE TABLE Barco
(
ID_Barco int IDENTITY(1,1) NOT NULL,
Nombre varchar(50),
Tamaño varchar(50) null,
ID_Origen int not null,
)
ON PS_origen_barco (ID_Origen)
GO


--Inserto los datos a la tabla

INSERT INTO Barco
	Values	('Aguamarina','200','1'),
			('Simon Peel','300','1'),
			('Siete Mares','400','1');

-- METADATOS
SELECT *,$Partition.FN_origen_barco(id_origen) AS
Partition
FROM Barco where id_origen = 1
GO

INSERT INTO Barco
	Values	
			('Aguamar','250',2),
			('Simon Patel','300',2),
			('Mareas','450',2);

-- METADATOS
SELECT *,$Partition.FN_origen_barco(id_origen) AS
Partition
FROM Barco
Where Id_origen = 2
GO

INSERT INTO Barco
	Values	('Tempestad','250',3),
			('Timon Patel','300',3),
			('Perla','450',3);

INSERT INTO Barco
	Values	('Temp','250',5),
			(' Patel','300',5),
			('Perla Negra','450',5);

--METADATOS
SELECT *,$Partition.FN_origen_barco(id_origen) AS
Partition
FROM Barco
Where Id_origen = 5
GO

------
---SPLIT

-- CREO LOS FILEGROUPS


-- Creo los filegroups para contener las particiones
ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_clientes_antes1970]
GO
ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_clientes1970_1990]
GO

ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_clientes1990_2000]
GO

ALTER DATABASE LONJA_LRM ADD FILEGROUP
[FG_clientes_despues2000]
GO

-- CREO LOS ARCHIVOS
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'nacimiento_antes1970', FILENAME =
'c:\DATA\Lonja\nacimiento_antes1970.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_clientes_antes1970]
GO
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'nacimiento_1970_1990', FILENAME =
'c:\DATA\Lonja\nacimiento_1970_1990.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_clientes1970_1990]
GO
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'nacimiento_1990_2000', FILENAME =
'c:\DATA\Lonja\nacimiento_1990_2000.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_clientes1990_2000]
GO
ALTER DATABASE LONJA_LRM ADD FILE ( NAME =
'nacimiento_despues2000', FILENAME =
'c:\DATA\Lonja\nacimiento_despues2000.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_clientes_despues2000]
GO

-- Creo una función de partición
CREATE PARTITION FUNCTION FN_nacimiento_fecha (datetime)
AS RANGE RIGHT
FOR VALUES ('1970-1-1','1990-1-1')
GO

-- Creo el esquema
CREATE PARTITION SCHEME nacimiento_fecha
AS PARTITION FN_nacimiento_fecha
TO
(FG_clientes_antes1970,FG_clientes1970_1990,FG_clientes1990_2000,
FG_clientes_despues2000)
GO

-- Creo la tabla clientes
DROP TABLE IF EXISTS Clientes
GO
CREATE TABLE Clientes
(
ID_Cliente int IDENTITY(1,1) NOT NULL,
Nombre varchar(50),
Apellidos varchar(50),
Fecha_nac datetime,
)
ON nacimiento_fecha (Fecha_nac) 
GO

--Añado los datos

INSERT INTO Clientes
Values ('Lavilson','Rodrigues','1998-10-14'),
('Delvis','Semedo','1965-10-10'),
('Miguel','Pino','1950-10-11'),
('Miguel','Santos','1975-06-23'),
('Ferlan','mndy','1988-02-03'),
('Vinicius','Junior','1980-04-06'),
('Sebastian','Sabitzer','1995-05-21'),
('Erling','Haaland','2002-07-09'),
('Kylian','Mbappe','2000-09-12')
GO

SELECT *,$Partition.FN_nacimiento_fecha(fecha_nac) AS
Partition
FROM Clientes
GO


ALTER PARTITION FUNCTION FN_nacimiento_fecha()
SPLIT RANGE ('2000-1-1');
GO
SELECT *,$Partition.FN_nacimiento_fecha(fecha_nac) as
PARTITION
FROM Clientes

----
-- MERGE
ALTER PARTITION FUNCTION FN_nacimiento_fecha()
MERGE RANGE ('1970-1-1');
GO
SELECT *,$Partition.FN_nacimiento_fecha(fecha_nac) AS PARTITION
FROM Clientes

---
-- -- SWITCH
USE LONJA_LRM
go
DROP TABLE IF EXISTS Clientes_antes1990;
CREATE TABLE Clientes_antes1990
( ID_cliente int IDENTITY(1,1) NOT NULL,
Nombre varchar(50),
Apellidos varchar(50),
fecha_nac datetime)
ON FG_clientes_antes1970
go
ALTER TABLE Clientes
SWITCH Partition 1 to Clientes_antes1990
go

SELECT * FROM Clientes
GO

--TRUNCATE

TRUNCATE TABLE Clientes
WITH (PARTITIONS (3));
go
select * from Clientes
GO
