USE MASTER 
GO
EXEC sp_configure order
GO
-- A UNO SE ACTIVAN OPCIONES AVANZADAS
EXEC SP_CONFIGURE 'show advanced options', 1
go

-- ACTUALIZAMOS EL VALOR
RECONFIGURE
GO

-- ACTIVAMOS LA CARACTERÍSTICA
EXEC SP_CONFIGURE 'contained database authentication', 1
GO

-- ACTUALIMOS DE NUEVO
RECONFIGURE
GO

-- HASTA AQUI PREPARAMOS EL ENTORNO PARA LO QUE VAMOS A EJECUTAR

DROP DATABASE IF EXISTS Contenida
GO
CREATE DATABASE Contenida
CONTAINMENT=PARTIAL
GO

-- Una verz creada la activamos
USE CONTENIDA
GO

-- Creo usuario LRM, asocio esquema dbo
DROP USER IF EXISTS LRM
GO
CREATE USER LRM
	WITH PASSWORD= 'Abcd1234.',
	DEFAULT_SCHEMA=[dbo]
GO

-- Añadimos el usuario lrm el rol dbo_owner
-- Deprecated
EXEC sp_addrolemember 'db_owner', 'lrm'
GO

--New
ALTER ROLE db_owner
ADD MEMBER lrm
GO

GRANT CONNECT TO LRM 

sp_configure 'show'