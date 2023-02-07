
-- Overview Security

-- Authentication - Authorization

-- sa ENABLE


-- Desde sa

CREATE DATABASE pepe
GO
DROP DATABASE pepe
GO

-- OK

-- From COMPUTER MANAGEMENT
-- USER pepe

-- LOGIN pepe
-- Starting SSMS (without ADMINISTRATOR)
-- FAILS TO CONNECT 


--Usuario de Windows pepe

--Cannot connect to DESKTOP-7CRURLP.

--===================================

--Login failed for user 'DESKTOP-7CRURLP\pepe'. (.Net SqlClient Data Provider)

----------------------------------------

--Cambio a sa Autenticación Mixta sin problema

----------------------------
--Creo login pepe para usuario pepe

--Entra


--Practicamente ningun permiso solo PUBLIC 

---- Tendriamos que crear un LOGIN pepe
---- Ver Imagenes
---- pepe no tiene practicamente permisos sólo los del ROL PUBLIC

CREATE DATABASE pepe
GO

--Msg 262, Level 14, State 1, Line 1
--CREATE DATABASE permission denied in database 'master'.

-- Intenta crear LOGIN  desde pepe
-- ERROR

-- Desde sa 

-- REVOKE GRANT DENY

REVOKE CONNECT SQL FROM [DESKTOP-7CRURLP\pepe]
go
--Commands completed successfully.

--Intentamos conectarnos como pepe por Autenticacion de Windows y fallamos

GRANT CONNECT SQL TO [DESKTOP-7CRURLP\pepe]
GO

--pepe se conecta

DENY CONNECT SQL TO [DESKTOP-7CRURLP\pepe]
go

--pepe falla

--desde GUI ver imagen GRANT CONNECT SQL TO [DESKTOP-7CRURLP\pepe]

--pepe se conecta


--------------------------------------------
/* SEGURIDAD */
-- Syllabus an outline of the subjects in a course of study or teaching.

/* INICIOS DE SESIÓN (LOGIN) */
-- LOGIN WINDOWS
-- desde transact-sql


-- ERROR . NO TIENE CUENTA DE WINDOWS ASOCIADA. 

CREATE LOGIN ana
FROM WINDOWS 
WITH DEFAULT_DATABASE=[master],
DEFAULT_LANGUAGE=[us_english]
GO



--Msg 15407, Level 16, State 1, Line 25
--'ana' is not a valid Windows NT name. 
-- Give the complete name: <domain\username>.


-- ERROR cmm\ana . No interpreta correctamente el \
CREATE LOGIN cmm\ana
FROM WINDOWS WITH DEFAULT_DATABASE=[master],
DEFAULT_LANGUAGE=[us_english]
GO

--Msg 102, Level 15, State 1, Line 33
--Incorrect syntax near '-'.


CREATE LOGIN [cmm\ana]
FROM WINDOWS WITH DEFAULT_DATABASE=[master],
DEFAULT_LANGUAGE=[us_english]
GO

-- ERROR	porque no existe la cuenta Ana
--Msg 15401, Level 16, State 1, Line 42
--Windows NT user or group 'DESKTOP-2GC8NLG\ana' not found. Check the name again.



-- [DESKTOP-B9614GG\cmm]
-- [DESKTOP-B9614GG\ana]


-- CREATE NEW ACCOUNT ANA

CREATE LOGIN [cmm\ana]
FROM WINDOWS 
WITH DEFAULT_DATABASE=[master],
DEFAULT_LANGUAGE=[us_english]
GO

-- ENABLE / DISABLE

ALTER LOGIN [cmm\ana]
	DISABLE ;
GO

ALTER LOGIN [cmm\ana]
	ENABLE ;
GO


DROP LOGIN [DESKTOP-7CRURLP\ana]
GO

/* Creamos un inicio de sesión DE sql server
For security reasons the login is created disabled and with a random password. */
CREATE LOGIN [abel] 
WITH PASSWORD='abel', 
DEFAULT_DATABASE=[master], 
DEFAULT_LANGUAGE=[us_english], 
CHECK_EXPIRATION=OFF, 
CHECK_POLICY=OFF
GO

SELECT *  
FROM sys.server_principals;  
go

SELECT *  
FROM sys.database_principals;
go


select * 
from sys.syslogins
GO

select NAME
from sys.syslogins
GO

USE AdventureWorks2017
GO

SELECT DP1.name AS DatabaseRoleName,   
   isnull (DP2.name, 'No members') AS DatabaseUserName   
 FROM sys.database_role_members AS DRM  
 RIGHT OUTER JOIN sys.database_principals AS DP1  
   ON DRM.role_principal_id = DP1.principal_id  
 LEFT OUTER JOIN sys.database_principals AS DP2  
   ON DRM.member_principal_id = DP2.principal_id  
WHERE DP1.type = 'R'
ORDER BY DP1.name;
go

-- ROLES FIJOS DE SERVIDOR
-- Probamos GUI
-- LOGIN SQL SERVER

CREATE LOGIN [luis]
	WITH PASSWORD='luis', 
	DEFAULT_DATABASE=[master], 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO

/* Utilizamos STORED PROCEDURED  y ALTER SERVER*/

/* Asignamos el rol 'diskadmin' al LOGIN */
--deprecated
EXEC sp_addsrvrolemember 'luis', 'diskadmin' ;
GO

-- VER DESDE GUI. REMOVE DESDE GUI

ALTER SERVER ROLE diskadmin 
	ADD MEMBER luis ;  
GO 


EXEC sp_dropsrvrolemember 'luis', 'diskadmin' ;
GO

ALTER SERVER ROLE diskadmin 
DROP MEMBER luis ;  
GO 

ALTER SERVER ROLE sysadmin
ADD MEMBER luis ;  
GO 

ALTER LOGIN luis
	DISABLE ;
GO
-- Pruebo conexión desde GUI. No se conecta
ALTER LOGIN luis
	ENABLE ;
GO



-- Se conecta
-- Can Create database
CREATE DATABASE luis
GO

DROP DATABASE luis
GO
/* Ver información sobre roles */

EXEC sp_helpsrvrole ;
GO
-- Comprobar GUI

/*  rol 'sysadmin' al LOGIN luis */

EXEC sp_dropsrvrolemember 'luis', 'sysadmin' ;
GO

ALTER SERVER ROLE sysadmin 
	DROP MEMBER luis ;  
GO 



---------------------

------------------------------------------------------

--Para ver la pertenencia al rol, use la rol de servidor (miembros) página SQL Server Management Studio o ejecute la consulta siguiente:
SELECT SRM.role_principal_id, SP.name AS Role_Name,   
SRM.member_principal_id, SP2.name  AS Member_Name  
FROM sys.server_role_members AS SRM  
JOIN sys.server_principals AS SP  
    ON SRM.Role_principal_id = SP.principal_id  
JOIN sys.server_principals AS SP2   
    ON SRM.member_principal_id = SP2.principal_id  
ORDER BY  SP.name,  SP2.name  
GO


---------------------------
-- DATABASE USER 
-- PERMISSIONS	IMPERSONATE


-- FROM GUI		FOLDER SECURITY			 USERS ROLES SCHEMAS

-- USERS
--	WITH    (CON) LOGIN
--	WITHOUT (SIN) LOGIN

USE [AdventureWorks2017]
GO
-- Syntax for SQL Server and Azure SQL Database  
  
-- DROP USER [ IF EXISTS ] user_name


DROP USER IF EXISTS luis
GO

CREATE USER [luis] 
FOR LOGIN [luis] 
GO
-- dbo
SELECT * 
FROM [HumanResources].[Department]
GO
-- USUARIO ACTIVO (diferentes modos)
PRINT user_name()
GO
PRINT USER
GO
SELECT USER 
GO
SELECT USER AS "SESIÓN"
GO
-- dbo

-- Impersonate : Usar Contexto de Seguridad de otra cuenta

-- Sentencias
-- EXECUTE AS              REVERT


EXECUTE AS USER='luis'
GO
PRINT user_name()
GO
PRINT USER
GO
SELECT * 
FROM [HumanResources].[Department]
GO

--Msg 229, Level 14, State 5, Line 528
--The SELECT permission was denied on the object 'Department', 
-- database 'AdventureWorks2017', schema 'HumanResources'.

REVERT
GO

PRINT USER
GO


GRANT SELECT ON [HumanResources].[Department] TO luis
GO


EXECUTE AS USER='luis'
GO
PRINT user_name()
GO
PRINT USER
GO

SELECT * FROM [HumanResources].[Department]
GO

REVERT
GO

REVOKE SELECT ON [HumanResources].[Department] FROM luis
GO
-- FUNCIONA TAMBIEN CON TO
REVOKE SELECT ON [HumanResources].[Department] TO luis
GO

EXECUTE AS USER='luis'
GO
PRINT user_name()
GO
PRINT USER
GO

SELECT * FROM [HumanResources].[Department]
GO

--Msg 229, Level 14, State 5, Line 383
--The SELECT permission was denied on the object 'Department', database 'AdventureWorks2017', schema 'HumanResources'.

REVERT
GO


-- FROM GUI

-- GRANT PERMISSIONS TO LUIS

--  CREATE - DROP USER WITH LOGIN. GENERATE SCRIPT
----------
--SUSER_NAME ( [ server_user_id ] )  
--Returns the login identification name of the user.

DECLARE @sys_usr char(30);  
SET @sys_usr = SYSTEM_USER;  
SELECT 'The current system user is: '+ @sys_usr;  
PRINT 'The current system user is: '+ @sys_usr; 
GO  

----------------------------

-- Using SYSTEM_USER with DEFAULT constraints

USE AdventureWorks2017;  
GO 
-- SCHEMA SALES
DROP TABLE IF EXISTS Sales.Sales_Tracking 
GO  
CREATE TABLE Sales.Sales_Tracking  
(  
    Territory_id int IDENTITY(2000, 1) NOT NULL,  
    Rep_id  int NOT NULL,  
    Last_sale datetime NOT NULL DEFAULT GETDATE(),  
    Rep_tracking_user varchar(30) NOT NULL DEFAULT SYSTEM_USER  
);  
GO  
INSERT Sales.Sales_Tracking (Rep_id)  
VALUES (151);  
INSERT Sales.Sales_Tracking (Rep_id, Last_sale)  
VALUES (293, '19980515');  
INSERT Sales.Sales_Tracking (Rep_id, Last_sale)  
VALUES (27882, '19980620');  
INSERT Sales.Sales_Tracking (Rep_id)  
VALUES (21392);  
INSERT Sales.Sales_Tracking (Rep_id, Last_sale)  
VALUES (24283, '19981130');  
GO

SELECT TOP 2 * 
	FROM Sales.Sales_Tracking   
	ORDER BY Rep_id;  
GO


--Territory_id	Rep_id	Last_sale	SRep_tracking_user
--2000	151	2020-02-11 17:34:53.573	CMM\cmm
--2001	293	1998-05-15 00:00:00.000	CMM\cmm

------------------------
--Using USER to return the database user name
--The following example declares a variable as char, 
-- assigns the current value of USER to it, and then prints the variable 
-- with a text description.

DECLARE @usr char(30)  
SET @usr = user  
SELECT 'The current user''s database username is: '+ @usr  
GO  

                      
-------------------------------------
-- DATABASE USERS 
-- Example USER WITHOUT LOGIN

-- Starting

USE pubs
GO
-- GUI CREATE USER 	WITHOUT LOGIN
DROP USER IF EXISTS juan
GO
CREATE USER juan
	WITHOUT LOGIN
GO

-- DUPLICANDO TABLAS CON	SELECT - INTO

DROP TABLE IF EXISTS Autores
GO
SELECT * 
	INTO Autores
	FROM Authors
GO
SELECT * FROM Autores
GO

-- OTRA FORMA EN LUGAR DE 
-- DROP TABLE IF EXISTS Autores
-- GO
--IF OBJECT_ID('Autores','U') is  null 
--	BEGIN
--		SELECT * 
--		INTO Autores
--		FROM Authors
--	END
--GO

SELECT * FROM Autores
GO
print user
go
-- Impersonate : Usar Contexto de Seguridad de otra cuenta

EXECUTE AS USER='juan'
GO

PRINT user_name()
GO

-- juan
SELECT * FROM Autores
GO

--Msg 229, Level 14, State 5, Line 243
--The SELECT permission was denied on the object 'authors', database 'pubs', schema 'dbo'.

DELETE Autores
GO

--Msg 229, Level 14, State 5, Line 289
--The DELETE permission was denied on the object 'Autores', database 'pubs', schema 'dbo'.

DROP TABLE Autores
GO

--Msg 3701, Level 14, State 20, Line 295
--Cannot drop the table 'Autores', because it does not exist or you do not have permission.


REVERT
GO

PRINT user_name()
GO

-- dbo

-- GRANT (CONCEDER - RETIRAR) PERMISSIONS

GRANT SELECT ON OBJECT::dbo.Autores TO juan
GO
-- EQUIVALENTE A LA SENTENCIA ANTERIOR
GRANT SELECT ON Autores TO juan
GO
-- Impersonate Juan

EXECUTE AS USER='juan'
GO
SELECT * FROM Autores
GO
-- Works
-- But ...
DELETE Autores
GO
--Msg 229, Level 14, State 5, Line 259
--The DELETE permission was denied on the object 'Autores', database 'pubs', schema 'dbo'.

REVERT
GO


/* Damos la propiedad de la tabla autores a juan. Hacemos que juan sea el creador */

GRANT DELETE ON Autores TO Juan
GO

EXECUTE AS USER='juan'
GO
DELETE Autores
GO
-- (23 row(s) affected)
select * from autores
GO
DROP TABLE Autores
GO 
Select * from autores
GO
--Msg 208, Level 16, State 1, Line 922
--Invalid object name 'autores'.
revert
go


/* Concedemos permisos de SELECT a juan sobre la tabla autores */

GRANT SELECT ON OBJECT::dbo.Autores TO juan
GO
EXECUTE AS USER='juan'
GO

PRINT user_name()
GO

SELECT * FROM HumanResources.Employee
GO

REVERT
GO
/* Elimino el permiso de SELECT a juan sobre la table autores */

REVOKE SELECT ON OBJECT::dbo.Autores TO juan
GO

-----------------------------
USE AdventureWorks2017;  
GO 
DROP USER IF EXISTS ANGEL
GO
CREATE USER ANGEL WITHOUT LOGIN ; 
GO
DROP USER IF EXISTS PEDRO
GO
CREATE USER PEDRO WITHOUT LOGIN ;  
GO
DROP USER IF EXISTS ANTIA
GO
CREATE USER ANTIA WITHOUT LOGIN ;  
GO 

DROP TABLE IF EXISTS deliveries3 
GO
CREATE TABLE DBO.deliveries3  
(  
 order_id int IDENTITY(5000, 1) NOT NULL,  
 cust_id  int NOT NULL,  
 order_date smalldatetime NOT NULL DEFAULT GETDATE(),
 -- This function adds a specified number value (as a signed integer) to a specified datepart of an input date value, and then returns that modified value.
  delivery_date smalldatetime NOT NULL DEFAULT  DATEADD(dd, 10, GETDATE()),  
 received_shipment nchar(30) NOT NULL DEFAULT SESSION_USER  
);  
GO 
SELECT * FROM deliveries3
GO

GRANT INSERT ON deliveries3 TO ANGEL,PEDRO,ANTIA
go

-- order_id int IDENTITY(5000, 1) NOT NULL,  
-- order_date smalldatetime NOT NULL DEFAULT GETDATE(),
-- delivery_date smalldatetime NOT NULL DEFAULT  DATEADD(dd, 10, GETDATE()),  
-- received_shipment nchar(30) NOT NULL DEFAULT SESSION_USER 
EXECUTE AS USER = 'ANGEL'  
PRINT USER
GO
INSERT deliveries3 (cust_id)  
	VALUES (7510);  
INSERT deliveries3 (cust_id)  
	VALUES (7231); 
go

SELECT * FROM deliveries3
GO
--Msg 229, Level 14, State 5, Line 780
--The SELECT permission was denied on the object 'deliveries3', database 'AdventureWorks2017', schema 'dbo'.

REVERT;
go
SELECT * FROM deliveries3
GO

--order_id	cust_id	order_date	delivery_date	received_shipment
--5000	7510	2020-02-14 16:36:00	2020-02-24 16:36:00	ANGEL                         
--5001	7231	2020-02-14 16:36:00	2020-02-24 16:36:00	ANGEL 

--PRINT USER
--GO   
                     
EXECUTE AS USER = 'PEDRO'  
INSERT deliveries3 (cust_id)  
	VALUES (7028);  
REVERT; 
go
SELECT * FROM deliveries3
GO


EXECUTE AS USER = 'ANTIA'  
INSERT deliveries3 (cust_id)  
	VALUES (7392);  
INSERT deliveries3 (cust_id)  
	VALUES (7452);  
SELECT * FROM deliveries3
go
--Msg 229, Level 14, State 5, Line 913
--The SELECT permission was denied on the object 'deliveries3', database 'AdventureWorks2017', schema 'dbo'.

REVERT;  
GRANT SELECT ON deliveries3 TO ANTIA
GO
EXECUTE AS USER = 'ANTIA' 
GO
SELECT order_id AS 'Order #', cust_id AS 'Customer #',   
   delivery_date AS 'When Delivered', received_shipment AS 'Received By'  
FROM deliveries3  
ORDER BY order_id;  
GO  
-- ADD  order_date 
SELECT order_id AS 'Order #', cust_id AS 'Customer #', order_date,  
   delivery_date AS 'When Delivered', received_shipment AS 'Received By'  
FROM deliveries3  
ORDER BY order_id;  
GO
SELECT order_id AS 'Order #', cust_id AS 'Customer #', order_date AS 'Fecha Pedido',  
   delivery_date AS 'When Delivered', received_shipment AS 'Received By'  
FROM deliveries3  
ORDER BY order_id;  
GO

--Order #	Customer #	When Delivered	Received By
--5000	7510	2020-02-21 18:03:00	ANGEL                         
--5001	7231	2020-02-21 18:03:00	ANGEL                         
--5002	7028	2020-02-21 18:03:00	PEDRO                         
--5003	7392	2020-02-21 18:03:00	ANTIA                         
--5004	7452	2020-02-21 18:03:00	ANTIA   

----------------------
USE AdventureWorks2017;  
GO  
--Create two temporary principals  
--DROP LOGIN IF EXISTS login1,login2
--GO
-- DROP LOGIN IF EXISTS login1
-- No funcionan
-- DROP LOGIN login_name  

CREATE LOGIN login1 WITH PASSWORD = 'Abcd1234.';  
CREATE LOGIN login2 WITH PASSWORD = 'Abcd1234.';  
GO  
CREATE USER user1 FOR LOGIN login1;  
CREATE USER user2 FOR LOGIN login2;  
GO  
--Give IMPERSONATE permissions on user2 to user1  
--so that user1 can successfully set the execution context to user2.  
GRANT IMPERSONATE ON USER:: user2 TO user1;  
GO  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
-- Set the execution context to login1.   
EXECUTE AS LOGIN = 'login1';  
--Verify the execution context is now login1.  
SELECT SUSER_NAME(), USER_NAME();  
--Login1 sets the execution context to login2.  
EXECUTE AS USER = 'user2';  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
-- The execution context stack now has three principals: the originating caller, login1 and login2.  
--The following REVERT statements will reset the execution context to the previous context.  
REVERT;  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
REVERT;  
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
  
  -- login1	user1
-- Si intento borrado me da errores

REVERT
--Display current execution context.  
SELECT SUSER_NAME(), USER_NAME();  
go

-- CMM\cmm


--Remove temporary principals.  
DROP LOGIN login1;  
DROP LOGIN login2;  
DROP USER user1;  
DROP USER user2;  
GO

-- Commands completed successfully.

------------------------------
-- GRANT Conceder
-- WITH GRANT OPTION

-- Owner to Juan - Juan To ana
/* Concedemos permisos a juan, y hacemos que este pueda otorgar permisos a otros usuarios 
--de la base de datos */
USE Pubs
GO
DROP TABLE IF EXISTS Autores
GO
SELECT *
	INTO Autores
	FROM Authors
GO
SELECT [au_lname],[au_fname],[phone]
	INTO Autores
	FROM Authors
	WHERE [STATE] = 'CA'
GO
SELECT * FROM Autores
GO
DROP USER IF EXISTS Juan
Go
CREATE USER juan without login
GO
PRINT USER
go

-- WITH GRANT OPTION
-- Same sentences
-- JUAN TRANSMITE EL PERMISO A ANA

GRANT SELECT ON OBJECT::dbo.Autores TO juan
	WITH GRANT OPTION
GO
GRANT SELECT ON Autores TO juan
	WITH GRANT OPTION
GO
EXECUTE AS USER='juan'
GO
PRINT user_name()
GO
SELECT * FROM Autores
GO
REVERT
GO
CREATE USER ana without login
GO
EXECUTE AS USER='ana'
GO
PRINT user_name()
GO
SELECT * FROM Autores
GO
--Msg 229, Level 14, State 5, Line 419
--The SELECT permission was denied on the object 'Autores', database 'pubs', schema 'dbo'.

REVERT
EXECUTE AS USER='juan'
GO
PRINT user_name()
GO
GRANT SELECT ON OBJECT::dbo.Autores TO ana
GO
REVERT
EXECUTE AS USER='ana'
GO
PRINT user_name()
GO
SELECT * FROM Autores
GO
REVERT

/* Eliminamos permisos a juan, y por defecto, a los demás usuarios (ANA)*/

REVOKE SELECT ON AUTORES TO JUAN CASCADE
GO

EXECUTE AS USER='ana'
GO
PRINT user_name()
GO
SELECT * FROM Autores
GO
--Msg 229, Level 14, State 5, Line 458
--The SELECT permission was denied on the object 'Autores', database 'pubs', schema 'dbo'.
----------------------------------

-- METADATA
-- Query below returns list of users in current database.

select name as username,
       create_date,
       modify_date,
       type_desc as type,
       authentication_type_desc as authentication_type
from sys.database_principals
where type not in ('A', 'G', 'R', 'X')
      and sid is not null
      and name != 'guest'
order by username;
GO

--username	create_date	modify_date	type	authentication_type
--ANGEL	2020-02-14 16:29:19.690	2020-02-14 16:29:19.690	SQL_USER	NONE
--ANTIA	2020-02-11 18:00:15.320	2020-02-11 18:00:15.320	SQL_USER	NONE
--CMM\ana	2020-02-11 15:56:45.400	2020-02-11 15:56:45.400	WINDOWS_USER	WINDOWS
--dbo	2003-04-08 09:10:42.287	2017-10-27 14:33:01.273	WINDOWS_USER	WINDOWS
--juan	2020-02-11 16:39:59.533	2020-02-11 16:39:59.533	SQL_USER	INSTANCE
--luis	2020-02-11 16:48:26.993	2020-02-11 16:48:26.993	SQL_USER	INSTANCE
--PEDRO	2020-02-11 18:00:15.300	2020-02-11 18:00:15.300	SQL_USER	NONE


-----------------------------------------------
--  SCHEMAS (Object Containers susch as tables,views, sp,...) 
-- Contenedores de objetos.
 
-- GUI SCHEMAS IN PUBS (DBO) - AdventureWorks2017 (SALES- [HumanResources]-...)

USE AdventureWorks2017
GO

-- Old block of code = SNIPPET
IF EXISTS (SELECT * 
			FROM sys.schemas 
			WHERE name = 'ventas')
	DROP SCHEMA ventas
GO

-- New block of code  SQL Server 2016 or above
DROP SCHEMA IF EXISTS ventas
GO
-- Add new schema.
CREATE SCHEMA ventas --AUTHORIZATION [dbo]
GO
DROP SCHEMA ventas
GO

---------------------------------
USE pubs
GO
DROP USER IF EXISTS Juan
go
CREATE USER juan without login
GO

DROP SCHEMA IF EXISTS Prod
GO
CREATE SCHEMA Prod AUTHORIZATION juan
GO

/* Creamos una tabla dentro del esquema Prod */

CREATE TABLE Prod.Article (
	ID INT,
	NAME CHAR(32))
GO

/* Eliminamos el esquema */

DROP SCHEMA Prod
GO

---Msg 3729, Level 16, State 1, Line 522
--Cannot drop schema 'Prod' because it is being referenced by object 'Article'.

/* da un error porque tiene un objecto: Mens. 3729, Nivel 16, Estado 1, Línea 1 No se puede drop schema 'Prueba' porque se le hace referencia en el objeto 'Prueba'.*/

DROP TABLE Article
GO

--Msg 3701, Level 11, State 5, Line 1180
--Cannot drop the table 'Article', because it does not exist or you do not have permission.

DROP TABLE Prod.Article
GO

DROP SCHEMA Prod
GO


-- 
USE AdventureWorks2017
GO

--  Moving objects among (ENTRE) schemas
--  GUI

ALTER SCHEMA HumanResources TRANSFER Person.Address
GO

ALTER SCHEMA Person TRANSFER HumanResources.Address
GO
-------------
-- METADATA
-- Ver los nombres y propietarios de los diferentes 'schemas' 
-- que hay en 'AdventureWorks2017'

SELECT SCHEMA_NAME, SCHEMA_OWNER
FROM AdventureWorks2017.INFORMATION_SCHEMA.SCHEMATA 
GO
-- Mostrar información sobre los esquemas disponibles
SELECT *
FROM sys.schemas ;
GO
-- Mostrar información sobre el esquema de un usuario
SELECT name, default_schema_name
	FROM sys.database_principals
	WHERE type = 'S'
	AND name = 'JUAN' ;
GO


-- Mostrar el propietario de un 'schema'
--	ejemplo de uso de 'alias'
SELECT s.name, u.name AS OWNER
	FROM sys.schemas s, sys.database_principals u
	WHERE s.principal_id = u.principal_id ;
GO

-- Mostrar todos los objetos que hay en un 'schema'
SELECT o.name, o.schema_id, o.type_desc
	FROM sys.objects o, sys.schemas s
	WHERE o.schema_id = s.schema_id
	AND s.name = 'HumanResources' ;
GO
--------

-- Transferir la propiedad de un TIPO DE USUARIO
-- El ejemplo siguiente crea un tipo en el esquema Production y, 
-- a continuación, 
-- transfiere el tipo al esquema Person.

USE AdventureWorks2017;  
GO  
  
CREATE TYPE Production.TestType 
FROM [varchar](10) NOT NULL ;  
GO  
  
-- Check the type owner.  
SELECT sys.types.name, sys.types.schema_id, sys.schemas.name  
    FROM sys.types JOIN sys.schemas   
        ON sys.types.schema_id = sys.schemas.schema_id   
    WHERE sys.types.name = 'TestType' ;  
GO  
  
-- Change the type to the Person schema.  

ALTER SCHEMA Person TRANSFER type::Production.TestType ;  
GO  
  
-- Check the type owner.  
SELECT sys.types.name, sys.types.schema_id, sys.schemas.name  
    FROM sys.types JOIN sys.schemas   
        ON sys.types.schema_id = sys.schemas.schema_id   
    WHERE sys.types.name = 'TestType' ;  
GO
----------------------------------------
--PERMISOS SOBRE ESQUEMAS

/* Concedemos permisos de consultar, actualizar y borrar */

-- Grant permissions to Ana on HumanResources
-- then deny permissions on HumanResources.Employee

USE AdventureWorks2017
GO
DROP USER IF EXISTS ana
GO
CREATE USER ana WITHOUT LOGIN
GO

GRANT SELECT,UPDATE,DELETE ON SCHEMA::HumanResources
	TO ana
GO
EXECUTE AS USER='ana'
GO
PRINT user_name()
GO
SELECT * FROM HumanResources.Employee
GO
SELECT * FROM HumanResources.Department
GO
-- OUT SCHEMA HumanResources
SELECT * FROM [Person].[Address]
GO
--Msg 229, Level 14, State 5, Line 1293
--The SELECT permission was denied on the object 'Address', database 'AdventureWorks2017', schema 'Person'.

REVERT
GO
grant revoke deny 
-- DENY (DENEGAR)
-- HumanResources.Employee

DENY SELECT,UPDATE,DELETE ON HumanResources.Employee TO ana
GO
-- Try Out with ana

EXECUTE AS USER='ana'
GO
PRINT user_name()
GO
SELECT * FROM HumanResources.Employee /* este no podemos verlo */
GO
--Msg 229, Level 14, State 5, Line 547
--The SELECT permission was denied on the object 'Employee', database 'AdventureWorks2017', schema 'HumanResources'.

SELECT * FROM HumanResources.JobCandidate /* este podemos verlo */
GO
-- Works

-- GUI FROM PRINCIPAL (ANA) SECURABLE(HumanResources.Employee)

-----------------
-- Forum problem

-- DROP User owns SCHEMA


-- Unable to delete a database role, somehow my custom database role 
-- had become the owner of the db_datareader role.

-- Error

--Deletion of the role was not possible due to the following error:

--Error: 15138 The database principal owns a schema in the database, 
-- and cannot be dropped.

--The solution is straightforward:

--First find out which schema is being owned by the rolename:

REVERT
go
USE AdventureWorks2017
GO
DROP TABLE IF EXISTS ventas.password
GO
DROP SCHEMA IF EXISTS Ventas
Go
CREATE SCHEMA ventas -- OWNER DBO
GO

DROP USER IF EXISTS Ana
go
CREATE USER ana WITHOUT LOGIN
GO

ALTER AUTHORIZATION
	ON SCHEMA::ventas
	TO ana --OWNER
GO

SELECT name 
FROM sys.schemas
 WHERE principal_id = USER_ID('ana' )
GO
-- ventas

DROP TABLE IF EXISTS ventas.password
GO
EXECUTE AS USER ='ana'
GO
-- Pese a que ana es "owner" es SCHEMA VENTAS no puede crear Tablas
CREATE TABLE ventas.[Password](
	[BusinessEntityID] [int] NOT NULL,
	[PasswordHash] [varchar](128) NOT NULL,
	[PasswordSalt] [varchar](10) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Password_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--Msg 262, Level 14, State 1, Line 1135
--CREATE TABLE permission denied in database 'AdventureWorks2017'.

PRINT USER
GO
--ANA

REVERT
GO

GRANT CREATE TABLE TO ana
GO
EXECUTE AS USER ='ana'
GO
-- Pese a que ana es "owner" es SCHEMA VENTAS no puede crear Tablas
CREATE TABLE ventas.[Password](
	[BusinessEntityID] [int] NOT NULL,
	[PasswordHash] [varchar](128) NOT NULL,
	[PasswordSalt] [varchar](10) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Password_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
-- Commands completed successfully.
-- Ver GUI
REVERT
GO
--DBO
DROP SCHEMA ventas
GO

--Msg 3729, Level 16, State 1, Line 628
--Cannot drop schema 'ventas' because it is being referenced by object 
-- 'Password'.

-- no
--DROP TABLE ventas.[Password]
--GO
--SELECT * FROM ventas.[Password]
--GO
--Msg 208, Level 16, State 1, Line 925
--Invalid object name 'ventas.Password'.

DROP USER ana
GO
--Msg 15138, Level 16, State 1, Line 926
--The database principal owns a schema in the database, and cannot be dropped.

ALTER AUTHORIZATION ON SCHEMA::ventas TO dbo
GO
-- After which you can drop the USER

DROP USER ana
GO

-- Same problem with ROLES

DROP SCHEMA ventas 
GO
--Msg 3729, Level 16, State 1, Line 674
--Cannot drop schema 'ventas' because it is being referenced by object 'Password'.
DROP TABLE ventas.[Password]
GO

DROP SCHEMA ventas 
GO
---------------
-- ROLES

--  DATABASE ROLES

-- FIXED	USER	APPLICATION


-- Server roles fixed (FIJOS)
-- DOCUMENTACIÓN MICROSOFT ROLES FIJOS

-- Server Roles
sp_helpSrvRole
GO
USE AdventureWorks2017
GO
-- Database Roles
sp_helpRole 
GO

-- Syntax for SQL Server  
  
-- DROP ROLE [ IF EXISTS ] role_name  
-- Rol Database Fixed

DROP USER IF EXISTS maria
go
CREATE USER maria WITHOUT LOGIN
GO
-- NEW VERSION
ALTER ROLE db_owner ADD member maria
GO

-- OLD VERSION DEPRECATED
EXEC sp_addrolemember 'db_owner', 'maria';
GO

-- GUI ROLES

execute as user='maria'
Go
create table demaria(id int)
GO
-- Commands completed successfully.

drop table demaria
go

-- Commands completed successfully.

REVERT
GO

-- DROPPING maria 

ALTER ROLE db_owner DROP member maria
GO
EXEC sp_droprolemember 'db_owner', 'maria';
GO
--GUI
execute as user='maria'
Go
create table demaria(id int)
GO
--Msg 262, Level 14, State 1, Line 1521
--CREATE TABLE permission denied in database 'AdventureWorks2017'.

REVERT
GO

--------------------

-- DATABASE ROLE USER

USE AdventureWorks2017
GO
-- 
-- GUI

/****** Object:  DatabaseRole [MARKETING]    Script Date: 21/02/2020 16:41:41 ******/
CREATE ROLE [MARKETING]
GO

DROP ROLE MARKETING
GO

-- Exists ?

-- USER ROLES

DROP ROLE IF EXISTS Especialistas
GO
CREATE ROLE Especialistas
GO

-- SQL Server 2014

if not exists (select 1 
				from sys.database_principals 
				where name='Especialistas' 
						and Type = 'R')
		begin
			CREATE ROLE Especialistas 
		end	
GO
if   exists (select 1 
				from sys.database_principals 
				where name='Especialistas' 
						and Type = 'R')
		begin
			drop ROLE Especialistas
		end	
else
		begin
			CREATE ROLE Especialistas 
		end	
GO

DROP TABLE IF EXISTS  HumanResources.Empleado
GO
SELECT *
	INTO HumanResources.Empleado
	FROM HumanResources.Employee
GO
-- (290 rows affected)

SELECT * FROM HumanResources.Empleado
GO

DROP USER IF EXISTS Veronica
GO
CREATE USER Veronica WITHOUT LOGIN
GO

-- TRY OUT
EXECUTE AS USER = 'Veronica'
GO
SELECT * from HumanResources.Empleado
GO
--Mens. 229, Nivel 14, Estado 5, Línea 1
--Se denegó el permiso SELECT en el objeto 'Employee', base de datos 'AdventureWorks2012', esquema 'HumanResources'.

REVERT
GO
-- Permitir hacer consultas sobre 'HumanResources.Employee' 
-- al 'role' Especialistas

GRANT SELECT ON HumanResources.Empleado TO Especialistas ;
GO

-- 'role' de base de datos 'Especialistas' usuario Verónica

-- Deprecated
EXEC sp_addrolemember  'Especialistas', 'Veronica' ;
GO
-- Recommended
ALTER ROLE especialistas ADD member Veronica
GO

sp_helproleMember 'Especialistas'
GO

--DbRole				MemberName	MemberSID
--Especialistas			  Veronica	0x010500000000000903000000B777334845DDC543BD0AB44ADAFC311B

--METADATA

SELECT pm.state_desc PermType,
  pm.permission_name PermName, 
  pm.class_desc PermClass, 
  CASE
    WHEN pm.class_desc = 'schema' THEN sc.name
    ELSE OBJECT_NAME(pm.major_id)
  END ObjectName
FROM sys.database_principals pr
  LEFT JOIN sys.database_permissions pm
    ON pr.principal_id = pm.grantee_principal_id
  LEFT JOIN sys.schemas sc
    ON pm.major_id = sc.schema_id
WHERE pr.name = 'Especialistas';
GO

--PermType	PermName	PermClass			ObjectName
--GRANT	    SELECT		OBJECT_OR_COLUMN		Empleado

-- To view the current roles/permissions granted to any database user in Azure SQL Database or in general for a MSSQL Server instance

SELECT r.name role_principal_name, m.name AS member_principal_name
FROM sys.database_role_members rm 
JOIN sys.database_principals r 
    ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m 
    ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('especialistas');
go

--role_principal_name			member_principal_name
--Especialistas					Veronica

-- Impersonate
EXECUTE AS USER = 'Veronica'
GO
SELECT * from HumanResources.Empleado
-- (290 rows affected)
GO
REVERT
GO

GRANT INSERT,DELETE,UPDATE ON HumanResources.Empleado TO Especialistas 
GO
DROP USER IF EXISTS pepe
GO
CREATE USER Pepe without login
GO
ALTER ROLE especialistas ADD member pepe
GO

SELECT r.name role_principal_name, m.name AS member_principal_name
FROM sys.database_role_members rm 
JOIN sys.database_principals r 
    ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m 
    ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('especialistas');
go

--role_principal_name				member_principal_name
--Especialistas						Veronica
--Especialistas						Pepe


-- DENY DELETE FROM pepe

DENY DELETE ON HumanResources.Empleado To pepe
GO

EXECUTE AS USER='pepe'
GO
SELECT * FROM HumanResources.Empleado
GO
-- (290 rows affected)

DELETE HumanResources.Empleado
GO
--Msg 229, Level 14, State 5, Line 823
--The DELETE permission was denied on the object 'Empleado', database 'AdventureWorks2017', schema 'HumanResources'.
REVERT
go
EXECUTE AS USER = 'Veronica'
GO
DELETE HumanResources.Empleado
GO
-- (290 rows affected)

SELECT * FROM HumanResources.Empleado
go

-- (0 rows affected)

DROP TABLE HumanResources.Empleado
go

--Msg 3701, Level 14, State 20, Line 1481
--Cannot drop the table 'Empleado', because it does not exist or you do not have permission.

REVERT
go
GRANT CONTROL ON HumanResources.Empleado TO VERONICA
GO
DROP ROLE especialistas
GO
--Msg 15151, Level 16, State 1, Line 1490
--Cannot drop the role 'especialistas', because it does not exist or you do not have permission.

ALTER ROLE especialistas DROP member pepe --,veronica
GO
-- Commands completed successfully.

SELECT r.name role_principal_name, m.name AS member_principal_name
FROM sys.database_role_members rm 
JOIN sys.database_principals r 
    ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m 
    ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('especialistas');
go

--role_principal_name				member_principal_name
--Especialistas						Veronica

ALTER ROLE especialistas DROP member veronica
GO

SELECT r.name role_principal_name, m.name AS member_principal_name
FROM sys.database_role_members rm 
JOIN sys.database_principals r 
    ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m 
    ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('especialistas');
go

-- role_principal_name	member_principal_name

DROP ROLE especialistas
GO

------------------
-- WITH GRANT OPTION and ROLES

USE pubs;
GO
DROP USER If Exists Federico
GO
CREATE USER Federico WITHOUT LOGIN
GO
DROP USER If Exists maria
GO
CREATE USER Maria WITHOUT LOGIN;
GO

DROP ROLE If Exists Editores
GO
CREATE ROLE Editores;
GO
ALTER ROLE Editores ADD MEMBER Federico
GO
-- ver gui esta Federico pero no maria

--sp_addrolemember Editores, maria
--GO
GRANT SELECT ON dbo.authors TO Editores WITH GRANT OPTION
GO

-- VER GUI ROL Editores	PROPERTIES : GENERAL SECURABLES

-- Comandos completados correctamente.
EXECUTE AS USER='maria'
GO
SELECT * from Authors;
GO
SELECT USER
GO
REVERT
GO

EXECUTE AS USER = 'federico';
GO
SELECT USER_NAME()
Go
SELECT * FROM dbo.authors
GO
-- this does not work
GRANT SELECT ON dbo.authors TO Maria;
GO

--Msg 15151, Level 16, State 1, Line 1473
--Cannot find the object 'authors', because it does not exist or you do not have permission.

-- this works . ADD     AS Editores

GRANT SELECT ON dbo.authors TO Maria AS Editores;
GO
-- Comandos completados correctamente.
REVERT

EXECUTE AS USER='maria'
GO

SELECT * from Authors;
GO
SELECT USER
GO
-- funciona
REVERT
GO
--
ALTER ROLE Editores DROP MEMBER Federico
GO

EXECUTE AS USER='Federico'
GO
SELECT * from Authors;
GO

--Msg 229, Level 14, State 5, Line 1512
--The SELECT permission was denied on the object 'authors', database 'pubs', schema 'dbo'.

SELECT USER
GO
REVERT
GO

-- sin embargo maria sigue pudiendo consultar. Ver gui maria
EXECUTE AS USER='maria'
GO
SELECT * from Authors;
GO
-- WORKS. SIN EMBARGO MARIA NO ESTA EN EL ROL EDITORES. VER GUI 
SELECT USER
GO
REVERT
GO

-- ¿error de sql server? deberia dar error ya que maria no es miembro del Rol Editores
ALTER ROLE Editores DROP MEMBER maria
GO
-- Commands completed successfully.



--------------------------
-- Column Level Permissions
-- Permisos sobre campos de Tablas

-- Creamos a Pablo
Use [Northwind]
GO
drop user if exists pablo
GO
create user Pablo without login
GO

sp_help Employees
GO
sp_help dbo.Employees
GO
sp_help "dbo.Employees"
GO

GRANT SELECT ON OBJECT::dbo.Employees (EmployeeId, LastName, Firstname,city) 
TO Pablo;
GO

--Nota:
-- Ir al GUI en Permisos de la Tabla Employees
--  Seleccionar Vigente (Effective)
--	Permisos de Columnas con SELECT seleccionado

print user 
-- Impersonate
EXECUTE AS USER= 'Pablo'
Go
Print User
Go
SELECT *
FROM Employees
GO
--Msg 230, Level 14, State 1, Line 1203
--The SELECT permission was denied on the column 'Title' of the object 'Employees', database 'Northwind', schema 'dbo'.
--Msg 230, Level 14, State 1, Line 1203

--Consequently, the first query in the following code snippet will succeed, but the second will
--fail with a permission denied error:

SELECT FirstName, LastName,City
FROM dbo.Employees;
Go

-- Funciona

SELECT FirstName + ' ..............' + LastName as Employee
FROM dbo.Employees
ORDER BY LastName, FirstName;
GO
-- Works !!!

SELECT LastName+ ', ' + FirstName AS 'Empleados de la empresa'
FROM dbo.Employees
ORDER BY LastName, FirstName;
GO

-- No permission over column Title and Address

SELECT FirstName,LastName, [Title],[Address]
FROM dbo.Employees
Go
--Msg 230, Level 14, State 1, Line 34
--The SELECT permission was denied on the column 'Title' of the object 'Employees', database 'Northwind', schema 'dbo'.
--Msg 230, Level 14, State 1, Line 34
--The SELECT permission was denied on the column 'Address' of the object 'Employees', database 'Northwind', schema 'dbo'.


SELECT FirstName + ' , ' + LastName as Empleado
FROM dbo.Employees
ORDER BY [HireDate] DESC;
GO

--Mens. 230, Nivel 14, Estado 1, Línea 1
--Se denegó el permiso SELECT en la columna 'HireDate' del objeto 'Employees', base de datos 'Northwind', esquema 'dbo'.

REVERT
GO



-- USING in Order By

USE AdventureWorks2017
GO

CREATE USER juan WITHOUT LOGIN
GO
--To assign permissions to columns, you can use GRANT SELECT ON <object>, and add the
--list of granted columns in parenthesis, as shown in the following example:
GRANT SELECT ON OBJECT::HumanResources.Employee ([BusinessEntityID],[JobTitle],[OrganizationLevel]) TO juan
GO
--This code allows members of the HumanResourceAssistant database role to read only
--four columns of the dbo.Employee table. The columns Birthdate or Salary cannot
--be selected.
--Consequently, the first query in the following code snippet will succeed, but the second will
--fail with a permission denied error:

EXECUTE AS USER = 'juan'
GO
SELECT [BusinessEntityID],[JobTitle]
FROM HumanResources.Employee
ORDER BY [JobTitle]
GO

-- Works

SELECT [BusinessEntityID],[JobTitle]
FROM HumanResources.Employee
ORDER BY [HireDate] DESC;
GO

--Msg 230, Level 14, State 1, Line 969
--The SELECT permission was denied on the column 'HireDate' of the object 'Employee', database 'AdventureWorks2017', schema 'HumanResources'.

REVERT
GO
--In fact, the second query is an attempt to cheat; as a member of HumanResourceAssistant,
--I have no permission to read the Salary column, but could I use it in ORDER BY to get a sense
--of who are the most paid employees? Of course not.
--You can also use the column-level permission to forbid modification of some columns:
GRANT SELECT ON OBJECT::dbo.Employee TO HumanResourceEmployee;
GRANT UPDATE ON OBJECT::dbo.Employee (LastName, Firstname, email) TO
HumanResourceEmployee;
--The HumanResourceEmployee members will be able to view all the employee information,
--and to change their name and e-mails, but they will not be able to change their salary or
--other information.
-----------
-- Permisos sobre Columnas y Roles


USE Tempdb
-- USE Pubs
GO
--CREATE SCHEMA Becarios
--Go
--CREATE TABLE Becarios.Employee ..................
--Go
DROP TABLE IF EXISTS Employee
go
CREATE TABLE Employee 
		( EmployeeID INT IDENTITY(1,1),-- PRIMARY KEY, 
		FirstName VARCHAR(20) NOT NULL, 
		MiddleName VARCHAR(20) NULL, 
		SurName VARCHAR(20) NOT NULL, 
		SSN CHAR(9) NOT NULL, 
		Salary INT NOT NULL
		CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID) );
GO


INSERT INTO dbo.Employee (FirstName, MiddleName, SurName, SSN, Salary) 
	VALUES ('John', 'Mark', 'Doe', '111223333', 50000)
	-- ,('Jane', 'Eyre', 'Doe', '222334444', 65000); 
INSERT INTO dbo.Employee (FirstName, MiddleName, SurName, SSN, Salary) 
	VALUES ('Jane', 'Eyre', 'Doe', '222334444', 65000);
Go


-- Let's go ahead and set up two users and two roles
DROP ROLE If Exists HR_Employee
GO
CREATE ROLE HR_Employee; 
GO 

DROP ROLE If Exists HR_Intern
GO
CREATE ROLE HR_Intern; 
GO 



DROP USER IF Exists SalaryPerson
GO
CREATE USER SalaryPerson WITHOUT LOGIN; 
GO 
ALTER ROLE HR_Employee ADD MEMBER SalaryPerson 
GO
-- Or
EXEC sp_addrolemember @membername = 'SalaryPerson',
 @rolename = 'HR_Employee'; 
GO 


DROP USER IF Exists SummerIntern
GO
CREATE USER SummerIntern WITHOUT LOGIN; 
GO 
EXEC sp_addrolemember 'SummerIntern','HR_Intern';
 GO
ALTER ROLE HR_Intern ADD MEMBER SummerIntern
GO




--Grants SELECT permission against the dbo.Employee
--table to HR_Employee role members

GRANT SELECT ON dbo.Employee TO HR_Employee;
GO
--Now, we don't want interns to have this level of permissions. We only want them to
--have access to specific columns. There's a way to do this. Immediately after the
--table name, we can specify the columns we want to grant permission to (or DENY,
--if we needed to do that) within a set of parentheses, like so:

GRANT SELECT ON dbo.Employee (EmployeeID, FirstName, MiddleName,
SurName) TO HR_Intern
GO

--This should work just fine, because HR_Employees can SELECT against
-- the whole table:

EXECUTE AS USER = 'SalaryPerson';
 GO 
 SELECT * FROM dbo.Employee; 
 GO 

-- 1	John	Mark	Doe	111223333	50000
-- 2	Jane	Eyre	Doe	222334444	65000

 REVERT; 
 GO

 --This will fail with a couple of access denied errors, listing the columns 
 -- the user cannot access:

 EXECUTE AS USER = 'SummerIntern'; 
 GO
  SELECT * FROM dbo.Employee
GO

--  Mens. 230, Nivel 14, Estado 1, Línea 1
--Se denegó el permiso SELECT en la columna 'SSN' del objeto 'Employee', base de datos 'TrainingDB', esquema 'dbo'.
--Mens. 230, Nivel 14, Estado 1, Línea 1
--Se denegó el permiso SELECT en la columna 'Salary' del objeto 'Employee', base de datos 'TrainingDB', esquema 'dbo'.


 -- This will work, because the columns in the query are accessible to HR_Intern:

 SELECT EmployeeID, FirstName, SurName FROM dbo.Employee;
 GO 
 --	1	John	Doe
--	2	Jane	Doe

 REVERT 
 GO
--That's how to restrict using column permissions. Incidentally, you can do the same
-- for DENY. Therefore, if a group of users already have access to columns 
--they shouldn't, and you can't rework security in this manner, 
--you could use DENY if you had to, like so:

-- DENY SELECT ON dbo.Employee (SSN, Salary) TO HR_Intern;

-- Since DENY trumps any other permissions, this will effectively block access 
-- to those columns. This should be used as a last resort, obviously, because 
-- the use of DENY is not intuitive. 
--And DENY at the column level is another step removed 
-- from what we're used to when looking at permissions.

ALTER ROLE HR_Intern DROP MEMBER SummerIntern;
GO
EXECUTE AS USER = 'SummerIntern';
GO
SELECT EmployeeID, FirstName, SurName 
FROM dbo.Employee;
GO 
--Mens. 229, Nivel 14, Estado 5, Línea 1
--Se denegó el permiso SELECT en el objeto 'Employee', base de datos 'TrainingDB', esquema 'dbo'.



--------------------
-- Permiso EXECUTE con Procedimientos Almacenados

-- Conceder permiso para ejecución de procedimientos a usuarios 
-- o Roles


USE AdventureWorks2017
GO
DROP USER IF EXISTS Pepe
Go
CREATE USER Pepe WITHOUT LOGIN
GO
print user
go
-- Creamos Usuario Pepe sin Login
GRANT EXECUTE ON dbo.uspGetEmployeeManagers
	TO pepe
GO
SETUSER 'pepe' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;
GO
-- Funciona
-- Intento ejecutar otro Procedimiento
EXEC [dbo].[uspGetManagerEmployees] 3
GO
--Msg 229, Level 14, State 5, Procedure uspGetManagerEmployees, Line 290
--The EXECUTE permission was denied on the object 'uspGetManagerEmployees', database 'AdventureWorks2017', schema 'dbo'.
SETUSER
Go

GRANT EXECUTE ON dbo.[uspGetManagerEmployees]
TO pepe
go

REVOKE EXECUTE ON [dbo].[uspGetEmployeeManagers] TO pepe AS [dbo]
GO
SETUSER 'pepe' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;
GO
--Msg 229, Level 14, State 5, Procedure uspGetEmployeeManagers, Line 302
--The EXECUTE permission was denied on the object 'uspGetEmployeeManagers', database 'AdventureWorks2017', schema 'dbo'.
EXECUTE uspGetManagerEmployees 3
GO
-- Funciona
SETUSER
GO
------------------
-- TODOS SP - DENY

DROP USER IF EXISTS PACO
GO
CREATE USER PACO WITHOUT LOGIN 
GO
GRANT EXECUTE ON DATABASE::AdventureWorks2017
	TO PACO ;
GO

SETUSER 'PACO' 
GO
EXECUTE uspGetEmployeeManagers 3 ;
GO
EXEC [dbo].[uspGetManagerEmployees] 3
GO
SETUSER
GO

-- Prueba con DENY
DENY EXECUTE ON [dbo].[uspGetEmployeeManagers] TO pepe AS [dbo]
GO
SETUSER 'PACO' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;
GO
--Msg 229, Level 14, State 5, Procedure dbo.uspGetEmployeeManagers, Line 1 [Batch Start Line 1510]
--The EXECUTE permission was denied on the object 'uspGetEmployeeManagers', database 'AdventureWorks2017', schema 'dbo'.
EXEC [dbo].[uspGetManagerEmployees] 3
GO

-- Funciona
SETUSER
Go

---------------------------------------------
GRANT EXECUTE ON DATABASE::AdventureWorks2017
	TO pepe ;
GO
SETUSER 'pepe' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;
GO
--Msg 229, Level 14, State 5, Procedure uspGetEmployeeManagers, Line 302
--The EXECUTE permission was denied on the object 'uspGetEmployeeManagers', database 'AdventureWorks2017', schema 'dbo'.

SETUSER
GO


-----------------------
-- Otra version
GRANT EXECUTE ON DATABASE::AdventureWorks2017
	TO ana ;
GO

-- Impersonate de otro modo
-- Cambiamos al usuario ana . Otra Forma
SETUSER 'ana' ;
GO
-- Dejamos el usuario 'ana'
SETUSER ;
GO 
-- Fin Impersonate de otro modo

-- Impersonación del usuario ana
EXECUTE AS USER = 'ana' ;
GO
-- Dejamos el usuario ana
REVERT ;
GO

-- Comprobamos que usuario somos
SELECT USER ;
GO

-- Ejecutar Procedimiento uspGetEmployeeManagers 
-- dando Parametro de entrada 3

EXECUTE dbo.uspGetEmployeeManagers 3 ;
-- Funciona
GO 
REVERT
Go


-- Denegamos el permiso de ejecución para el usuario 'Veronica'


DENY EXECUTE ON DATABASE::AdventureWorks2017
	TO ana ;
GO

-- Comprobamos que usuario somos
SELECT USER ;
GO

-- Intentamos ejecutar de nuevo como usuario ana
SETUSER 'ana' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;

--Mens 229, Nivel 14, Estado 5, Procedimiento uspGetEmployeeManagers, Línea 1
--Se denegó el permiso EXECUTE en el objeto 'uspGetEmployeeManagers', base de datos 'AdventureWorks2012', esquema 'dbo'.

SETUSER ;
GO
-- Con Procedimiento uspGetEmployeeManagers
GRANT EXECUTE ON dbo.uspGetEmployeeManagers
	TO ana ;
GO
SETUSER 'ana' 
GO
EXECUTE dbo.uspGetEmployeeManagers 3 ;

--Msg 229, Level 14, State 5, Procedure uspGetEmployeeManagers, Line 273
--The EXECUTE permission was denied on the object 'uspGetEmployeeManagers', database 'AdventureWorks2017', schema 'dbo'.
GO
revert
--Msg 15357, Level 16, State 1, Line 278
--The current security context was set by "SetUser". It cannot be reverted by statement "Revert".
SETUSER
GO

---------------------------
CREATE USER ana WITHOUT LOGIN 
GO
-- Role's Members

ALTER ROLE Especialistas ADD MEMBER ana
GO
SELECT m.name MemberName
FROM sys.database_role_members rm 
  JOIN sys.database_principals r
    ON rm.role_principal_id = r.principal_id
  JOIN sys.database_principals m
    ON rm.member_principal_id = m.principal_id
WHERE r.name = 'Especialistas'; 
GO

GRANT SELECT ON DATABASE::AdventureWorks2017 TO Especialistas
GO
GRANT EXECUTE ON OBJECT::HumanResources.uspUpdateEmployeeHireInfo TO Especialistas 
GO
-- Roles - Permissions

SELECT pm.state_desc PermType,
  pm.permission_name PermName, 
  pm.class_desc PermClass, 
  CASE
    WHEN pm.class_desc = 'schema' THEN sc.name
    ELSE OBJECT_NAME(pm.major_id)
  END ObjectName
FROM sys.database_principals pr
  LEFT JOIN sys.database_permissions pm
    ON pr.principal_id = pm.grantee_principal_id
  LEFT JOIN sys.schemas sc
    ON pm.major_id = sc.schema_id
WHERE pr.name = 'Especialistas';
GO


SELECT * FROM HumanResources.Employee; 
 
SELECT * FROM HumanResources.EmployeePayHistory;
 
SELECT * FROM HumanResources.JobCandidate; 
 
SELECT * FROM Person.Person; 
 
EXEC HumanResources.uspUpdateEmployeeHireInfo 
  5, 'Design Engineer II', '2008-01-06', '2016-07-14', 44.2938, 2, 1;


REVOKE EXECUTE ON OBJECT::HumanResources.uspUpdateEmployeeHireInfo TO Especialistas;
REVOKE SELECT ON SCHEMA::HumanResources TO Especialistas;
REVOKE SELECT ON OBJECT::HumanResources.JobCandidate TO Especialistas;  

DROP ROLE Especialistas
GO

-- If don't exists ...

--Msg 15151, Level 16, State 1, Line 683
--Cannot drop the role 'Especialistas', because it does not exist or you do not have permission.

-----------------------------


/* ROLES DE APLICACIÓN */
/* Utilizan una aplicación para conectarse a nuestra base de datos. */

/* Creamos el rol de aplicacion */

USE AdventureWorks2017
GO
DROP ROLE IF Exists AplicacionAlmacen
GO
CREATE APPLICATION ROLE AplicacionAlmacen
	WITH PASSWORD = 'abcd123.',
	DEFAULT_SCHEMA = dbo;
GO

--/* Eliminar el rol */

DROP APPLICATION ROLE AplicacionAlmacen
GO

/* Conceder permisos al rol "SOBRE UNA VISTA: v" */

GRANT SELECT ON Sales.vSalesPersonSalesByFiscalYears TO AplicacionAlmacen
GO

/* Hago una consulta y funciona*/ 

-- WHO ???

PRINT USER
SELECT USER ;
SELECT USER_NAME();
GO

SELECT *
	FROM Sales.vSalesPersonSalesByFiscalYears ;
GO


/* IMPERSONAR */

/* Activamos el rol de aplicación AplicacionAlmacen IMPERSONACIÓN */
-- From Application Active Role

EXEC sp_setapprole 'AplicacionAlmacen', 'abcd123.' ;
GO

PRINT USER_NAME()
GO

-- AplicacionAlmacen


/* Consulto la vista a la que le di permisos select y una sobre la cual no tengo permisos */

SELECT COUNT(*)
	FROM Sales.vSalesPersonSalesByFiscalYears ;
GO
-- 14
SELECT *
	FROM Sales.vSalesPersonSalesByFiscalYears ;
GO



SELECT COUNT(*)
	FROM HumanResources.vJobCandidate ;
GO


--SELMsg 229, Level 14, State 5, Line 1934
--The ECT permission was denied on the object 'vJobCandidate', database 'AdventureWorks2017', schema 'HumanResources'.


SELECT *
	FROM HumanResources.vJobCandidate ;
GO
/* Salgo del rol: Si nos impersonamos, ya no podemos volver atrás con REVERT, debemos cerrar la sesión. */

PRINT USER_NAME()
GO

REVERT
/* ERROR */

--Msg 15357, Level 16, State 1, Line 1946
--The current security context was set by "SetApprole". It cannot be reverted by statement "Revert".

 -- QUIT SESSION !!!



/* Modificar el nombre del rol */

ALTER APPLICATION ROLE AplicacionAlmacen
	WITH NAME = Almacen,
	PASSWORD = 'abcd123.' ;
GO


