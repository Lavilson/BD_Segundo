USE master
Go
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

[FG_barcos_locales]
GO
[FG_otro_barco]
GO
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
'otro', FILENAME =
'c:\DATA\Lonja\otro.ndf', SIZE = 5MB, MAXSIZE = 100MB,
FILEGROWTH = 2MB ) TO FILEGROUP [FG_otro_barco]
GO
AS RANGE LEFT
FOR VALUES (1,2,3)
GO
AS PARTITION FN_origen_barco
TO ([FG_barcos_nacionales],[FG_barcos_internacionales],[FG_barcos_locales],[FG_otro_barco])
GO
-- Se crea como normalmente, pero con dos requerimientos adicionales:
-- 1. La localizaci�n de almacenamiento se la da el esquema de partici�n
-- 2. Hay que especificar la columna que se utilizar� para particionar
DROP TABLE IF EXISTS Barco
GO
CREATE TABLE Barco
(
ID_Barco int IDENTITY(1,1) NOT NULL,
Nombre varchar(50),
Tama�o varchar(50) null,
ID_Origen int not null,
)
ON PS_origen_barco (ID_Origen)
GO

SELECT *,$Partition.FN_origen_barco(id_origen) AS
Partition
FROM Barco where id_origen = 1
GO
Partition
FROM Barco
Where Id_origen = 2
GO

INSERT INTO Barco
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

[FG_clientes1990_2000]
GO
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
AS RANGE RIGHT
FOR VALUES ('1970-1-1','1990-1-1')
GO
AS PARTITION FN_nacimiento_fecha
TO
(FG_clientes_antes1970,FG_clientes1970_1990,FG_clientes1990_2000,
FG_clientes_despues2000)
GO
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
Partition
FROM Clientes
GO
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