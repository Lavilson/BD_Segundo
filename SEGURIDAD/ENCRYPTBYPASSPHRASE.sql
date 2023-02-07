USE MASTER
GO

DROP DATABASE IF EXISTS SecureDB
GO
CREATE DATABASE SecureDB
GO

USE SecureDB

-- Creamos una tabla cliente con una columna TarjetaCredito
-- tipo varbinary para que contenga la información encriptada


CREATE TABLE dbo.Cliente
(CodigoCliente INT NOT NULL IDENTITY(1,1),
Nombres VARCHAR(100) NOT NULL,
TarjetaCredito VARBINARY(128)
)
GO
-- Insertamos valor
INSERT INTO DBO.Cliente (Nombres, TarjetaCredito)
VALUES ('pepe', ENCRYPTBYPASSPHRASE
('EstaEsMiFraseSecreta','1111-1111-1111-1111'))
GO

-- Intentamis hacer un select convencional

SELECT * FROM Cliente

--CodigoCliente	Nombres	TarjetaCredito
--1				pepe	0x020000000A3A169717EBA96DB73F28DF331E268DEFFCBF52A7128002FE02C1C793D6029417D0AF9C5ADDD1150A3D7FA27D22902D

--- Intentamos hacer un select con una frase incorrecta

SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('EstEsMiFjjhraseSecreta', TarjetaCredito))
FROM dbo.Cliente
GO
--1	pepe	NULL


--Ahora hacemos un select con la frase correcta

SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('EstaEsMiFraseSecreta', TarjetaCredito)) AS TarjetaCredito
FROM dbo.Cliente
GO
--1	pepe	1111-1111-1111-1111


-- Añadimos un autenticador
DECLARE @v_Usuario SYSNAME
-- SET @v_Usuario = 'lrm'
SET  @v_Usuario = SYSTEM_USER
PRINT SYSTEM_USER
INSERT INTO dbo.Cliente (Nombres, TarjetaCredito)
VALUES ('ana', ENCRYPTBYPASSPHRASE('EstaEsMiFraseSecreta','2222-2222-2222-2222',
			1,@v_Usuario))

SELECT * FROM Cliente

--Ahora hacemos un select con la frase correcta
-- y con el autenticador correcto
DECLARE @v_Usuario SYSNAME
-- SET @v_Usuario = 'lrm'
SET  @v_Usuario = SYSTEM_USER
SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('EstaEsMiFraseSecreta', TarjetaCredito,1,@v_Usuario)) AS TarjetaCredito
FROM dbo.Cliente
GO

--CodigoCliente	Nombres	TarjetaCredito
--1				pepe	NULL
--2				ana		2222-2222-2222-2222


USE AdventureWorks2017;
GO
DROP TABLE IF EXISTS SALES.TARJETADECREDITO
GO
SELECT *
INTO SALES.TARJETADECREDITO
FROM Sales.CreditCard
GO

ALTER TABLE SALES.TARJETADECREDITO
	DROP COLUMN CardNumber_EncryptedbyPassphrase
GO
SELECT * FROM Sales.TARJETADECREDITO
GO

-- Create a column in wich to store the encypted data.
ALTER TABLE SALES.TARJETADECREDITO
	ADD CardNumber_EncryptedbyPassphrase VARBINARY(256);
GO
SELECT * FROM Sales.TARJETADECREDITO
GO

--Update the record for the user´s credit card.
--

--First get the passphrase from the user.
DECLARE @PassphraseEnteredByUser NVARCHAR(128);
SET @PassphraseEnteredByUser = 'Fecha es febrero 2023 y yo soy lrm !';

UPDATE Sales.TARJETADECREDITO
SET CardNumber_EncryptedbyPassphrase =
ENCRYPTBYPASSPHRASE(@PassphraseEnteredByUser,
CardNumber, 1, CONVERT(VARBINARY, CreditCardID))
-- DONDE CreditCardID = '1';

--(19118 rows affected)


-- Get the passphrase from the user.
DECLARE @PassphraseEnteredByUser NVARCHAR(128);
SET @PassphraseEnteredByUser = 'Fecha es febrero 2023 y yo soy lrm !';

--Decrypt the encrypted record.
SELECT CardNumber, CardNumber_EncryptedbyPassphrase
	AS 'Encrypted card number', CONVERT(NVARCHAR,
	DecryptByPassphrase(@PassphraseEnteredByUser,
	CardNumber_EncryptedbyPassphrase, 1,
	CONVERT(VARBINARY, CreditCardID)))
	AS 'Decrypted Card Number'
FROM SALES.TARJETADECREDITO
GO