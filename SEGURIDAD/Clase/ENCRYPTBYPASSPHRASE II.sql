

--The following example updates a record in the SalesCreditCard table and encrypts 
--the value of the credit card number stored in column CardNumber_EncryptedbyPassphrase, 
--using the primary key as an authenticator.

-- Anteriores versiones de SQL Server (antes de SQL Server 2017)
-- Cifra datos mediante una frase de contraseña usando el algoritmo 
-- TRIPLE DES con una longitud de clave de 128 bits.
-- Nota
-- SQL Server 2017 y las versiones posteriores cifran los datos con una 
-- frase de contraseña mediante una clave AES256.
/*


--EncryptByPassPhrase ( { 'passphrase' | @passphrase }   
--    , { 'cleartext' | @cleartext }  
--  [ , { add_authenticator | @add_authenticator }  
--    , { authenticator | @authenticator } ] )  

Argumentos:

passphrase
Frase de contraseña a partir de la cual se genera una clave simétrica.

@passphrase
Variable de tipo nvarchar, char, varchar, binary, varbinary o nchar que contiene una frase de contraseña a partir de la cual se genera una clave simétrica.

texto no cifrado
Texto no cifrado que se va a cifrar.

@cleartext
Una variable de tipo nvarchar, char, varchar, binary, varbinary o nchar que contiene el texto sin cifrar. 
El tamaño máximo es de 8.000 bytes.

add_authenticator
Indica si se cifrará un autenticador junto con el texto sin cifrar. 1 si se va a agregar un autenticador. int.

@add_authenticator
Indica si se cifrará un hash junto con el texto no cifrado.

authenticator
Datos a partir de los cuales se obtiene un autenticador. sysname.

@authenticator
Variable que contiene datos a partir de los cuales se obtiene un autenticador.

Tipos de valor devuelto
varbinary con un tamaño máximo de 8000 bytes.
*/

USE AdventureWorks2019;  
GO 
DROP TABLE IF EXISTS SALES.TARJETADECREDITO
GO
SELECT *
INTO SALES.TARJETADECREDITO
FROM Sales.CreditCard
GO
-- ESTO NO ES NECESARIO, PERO YA TENIA ESTA COLUMNA DE OTRAS PRUEBAS
ALTER TABLE SALES.TARJETADECREDITO
	DROP COLUMN CardNumber_EncryptedbyPassphrase
GO
SELECT * FROM SALES.TARJETADECREDITO
GO
-- Create a column in which to store the encrypted data.  
ALTER TABLE SALES.TARJETADECREDITO   
    ADD CardNumber_EncryptedbyPassphrase VARBINARY(256);   
GO  
SELECT * FROM SALES.TARJETADECREDITO
GO

-- Update the record for the user's credit card.  
-- 
-- First get the passphrase from the user.  
DECLARE @PassphraseEnteredByUser NVARCHAR(128);  
SET @PassphraseEnteredByUser = 'Fecha es febrero 2023 y yo soy cmm !';  

UPDATE SALES.TARJETADECREDITO
SET CardNumber_EncryptedbyPassphrase = 
EncryptByPassPhrase(@PassphraseEnteredByUser  
    , CardNumber, 1, CONVERT(varbinary, CreditCardID))  
-- WHERE CreditCardID = '1';  
GO 
-- (19118 rows affected)

SELECT * FROM SALES.TARJETADECREDITO
GO

-- CreditCardID	CardType	CardNumber	ExpMonth	ExpYear	ModifiedDate	CardNumber_EncryptedbyPassphrase
-- 1	      SuperiorCard	33332664695310	11	2006	2013-07-29 00:00:00.000	0x02000000B2F15653190D2A041E7952B3247F910FC7E9BF85BBF973AD5D1CED32AA7C9E6923626F8FEA06AF4863E1EE304ECEB68746D1654090C65D88CAEA988BA653BB4A697F9FA923D0F5DEF6D02FCA76CC0FFC



-- Get the passphrase from the user.  
DECLARE @PassphraseEnteredByUser NVARCHAR(128);  
SET @PassphraseEnteredByUser = 'Fecha es febrero 2023 y yo soy cmm !'; 
  
-- Decrypt the encrypted record.  
SELECT CardNumber, CardNumber_EncryptedbyPassphrase   
    AS 'Encrypted card number', CONVERT(nvarchar,  
    DecryptByPassphrase(@PassphraseEnteredByUser,
	CardNumber_EncryptedbyPassphrase, 1   
    , CONVERT(varbinary, CreditCardID)))  
    AS 'Decrypted card number' 
FROM SALES.TARJETADECREDITO
    -- WHERE CreditCardID = '1';  
GO  

--CardNumber	Encrypted card number	Decrypted card number
--33332664695310	0x02000000F0DE82805FBCD37F30E295660F886B827C691458446E8EFBFA02410F51990A0C52F42A8B94D81773493A787CDD82BB4EFDCEAFB972C058B5A50361F5318E155C79D08337965B0E4EE068F10B4EBD5B10	33332664695310


-- Nota :
-- EN LA DOCUMENTACIÓN DE MICROSOFT
-- ERROR

-- Get the passphrase from the user.  
DECLARE @PassphraseEnteredByUser NVARCHAR(128);  
SET @PassphraseEnteredByUser = 'Fecha es febrero 2023 y yo soy cmm !'; 
  
-- Decrypt the encrypted record.  
SELECT CardNumber, CardNumber_EncryptedbyPassphrase   
    AS 'Encrypted card number', CONVERT(varchar,  -- ERROR EN EL TIPO
    DecryptByPassphrase(@PassphraseEnteredByUser, CardNumber_EncryptedbyPassphrase, 1   
    , CONVERT(varbinary, CreditCardID)))  
    AS 'Decrypted card number' 
FROM SALES.TARJETADECREDITO
    -- WHERE CreditCardID = '1';  
GO  

-- CardNumber	Encrypted card number	      Decrypted card number
--33332664695310 ..65B0E4EE068F10B4EBD5B10	     3

-- Decrypted card number    NO CORRECTO
