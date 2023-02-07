----ENCRIPTAR COLUMNAS

USE master
GO
CREATE LOGIN BankManagerLogin WITH PASSWORD='abc123.'
GO
CREATE DATABASE MiBanco
GO
USE MiBanco
DROP USER IF EXISTS BankManagerUser
GO
CREATE USER BankManagerUser FOR LOGIN BankManagerLogin
GO

DROP TABLE IF EXISTS Customers
GO

CREATE TABLE Customers
	(customer_id INT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	social_security_number varbinary(100) NOT NULL)
GO
REVERT

GRANT SELECT, INSERT, UPDATE, DELETE ON Customers
TO BankManagerUser
GO

CREATE SYMMETRIC KEY BankManager_User_Key
AUTHORIZATION BankManagerUser
WITH ALGORITHM=AES_256
ENCRYPTION BY PASSWORD='abc123.'
GO

EXECUTE AS USER='BankManagerUser'
GO

OPEN SYMMETRIC KEY [BankManager_User_Key]
DECRYPTION BY PASSWORD='abc123.'
GO
INSERT INTO  Customers VALUES (1,'Howard','Stern',ENCRYPTBYKEY(Key_GUID('BankManager_User_Key'),'455-14-1423'))
INSERT INTO  Customers VALUES (2,'Donald','Trump',ENCRYPTBYKEY(Key_GUID('BankManager_User_Key'),'482-45-1155'))
INSERT INTO  Customers VALUES (3,'Bill','Gates',ENCRYPTBYKEY(Key_GUID('BankManager_User_Key'),'153-78-4512'))
GO
SELECT * FROM Customers

CLOSE ALL SYMMETRIC KEYS

-- Para desencriptar

OPEN SYMMETRIC KEY [BankManager_User_Key]
DECRYPTION BY PASSWORD='abc123.'
GO

SELECT Customer_id,first_name + ' ' + last_name AS [Nombre Cliente],
CONVERT(VARCHAR,DECRYPTBYKEY(social_security_number))
AS 'Número Seguridad Social'
FROM Customers
GO

--Customer_id	Nombre Cliente	Número Seguridad Social
--1				Howard Stern	455-14-1423
--2				Donald Trump	482-45-1155
--3				Bill Gates	153-78-4512

CLOSE ALL SYMMETRIC KEYS
GO
REVERT