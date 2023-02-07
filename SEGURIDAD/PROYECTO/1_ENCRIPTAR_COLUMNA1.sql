
USE LONJA_LRM

-- Encrypt with simple symmetric encryption
CREATE MASTER KEY  ENCRYPTION BY PASSWORD ='abc123.';

SELECT * FROM sys.symmetric_keys;
GO

CREATE CERTIFICATE cert_lrm  
   WITH SUBJECT = 'Datos de clientes';  
GO  

CREATE SYMMETRIC KEY SSN_Key_01  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE cert_lrm;  
GO  



-- Create a column in which to store the encrypted data.
ALTER TABLE [dbo].[Clientes]
    ADD DNI_Encrypted varbinary(128); 
GO


SELECT TOP 10 DNI, DNI_Encrypted 
	FROM [dbo].[Clientes]
GO

-- Open the symmetric key with which to encrypt the data.

OPEN SYMMETRIC KEY SSN_Key_01
   DECRYPTION BY CERTIFICATE cert_lrm;
GO

-- Encrypt the value in column CardNumber using the
-- symmetric key CreditCards_Key11.
-- Save the result in column CardNumber_Encrypted.  


UPDATE [dbo].[Clientes]
SET DNI_Encrypted = EncryptByKey(Key_GUID('SSN_Key_01')  
    , DNI, 1, HASHBYTES('SHA2_256', CONVERT( varbinary  
    , Id_Cliente)));  
GO  

SELECT TOP 10 DNI, DNI_Encrypted 
	FROM [dbo].[Clientes]
GO

SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO


SELECT TOP 3 DNI, DNI_Encrypted 
    AS 'Encrypted card number', CONVERT(varchar,  
	DecryptByKey(DNI_Encrypted, 1 , 
    HashBytes('SHA2_256', CONVERT(varbinary, ID_Cliente))))
    AS 'Decrypted card number' FROM dbo.Clientes
GO


SELECT TOP 3 CardNumber, CardNumber_Encrypted 
    AS 'Encrypted card number', CONVERT(nvarchar,  
	DecryptByKey(CardNumber_Encrypted, 1 , 
    HashBytes('SHA2_256', CONVERT(varbinary, CreditCardID))))
    AS 'Decrypted card number' FROM Sales.TarjetadeCredito
GO