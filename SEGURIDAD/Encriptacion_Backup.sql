USE MASTER 
DROP DATABASE IF EXISTS [MyTDETest]
GO
CREATE DATABASE [MyTDETest]
GO
USE [MyTDETest]
GO


CREATE TABLE [dbo].[authors](
	[au_id] [varchar](20) NOT NULL,
	[au_lname] [varchar](40) NOT NULL,
	[au_fname] [varchar](20) NOT NULL,
	[phone] [char](12) NOT NULL,
	[address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL)
GO
USE MASTER
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD ='abc123.';
GO

CREATE CERTIFICATE MyServerCert
WITH SUBJECT = 'MI CERTIFICADO TDE'
GO

SELECT * FROM
sys.certificates

USE MyTDETest
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert
GO

--Warning: The certificate used for encrypting the database encryption key has not been backed up. 
--You should immediately back up the certificate and the private key associated with the certificate. 
--If the certificate ever becomes unavailable or if you must restore or attach the database on another server, 
--you must have backups of both the certificate and the private key or you will not be able to open the database.


USE master
GO
-- BACKUP DATABASE WITH ENCRYPTION OPTION & REQUIRED ENCRYPTION ALGORITHM

BACKUP DATABASE MyTDETest
TO DISK = 'C:\TEMP\MyTDETest.bak'
WITH ENCRYPTION
(
ALGORITHM = AES_256,
SERVER CERTIFICATE = MyServerCert
),
STATS = 10
--- GUARDAR CERTIFICADO
BACKUP CERTIFICATE MyServerCert
	TO FILE = 'C:\TEMP\MyServerCert'
	WITH PRIVATE KEY
	(
	FILE = 'C:\TEMP\MyServerCert.pvk',
	ENCRYPTION BY PASSWORD = 'abc123.')
GO

-----------------------
--SEGUNDO SERVIDOR

RESTORE DATABASE MyTDETest
FROM DISK = 'C:\TEMP\MyTDETest.bak'
WITH FILE = 1, NOUNLOAD, STATS = 5,
MOVE N'MyTDETest' TO 
MOVE N'MyTDETest_log' TO 