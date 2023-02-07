-- Create a self-signed certificate

CREATE CERTIFICATE doctor1cert AUTHORIZATION doctor1
WITH subject = 'abc123.';

CREATE SYMMETRIC KEY doctor1key
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE doctor1cert
GO

CREATE SYMMETRIC KEY doctor2key
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE doctor2cert
GO

SELECT name KeyName,
  symmetric_key_id KeyID,
  key_length KeyLength,
  algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO


GRANT VIEW DEFINITION ON CERTIFICATE::doctor1cert TO doctor1
GO
GRANT VIEW DEFINITION ON SYMMETRIC KEY::doctor1key TO doctor1
GO

GRANT VIEW DEFINITION ON CERTIFICATE::doctor2cert TO doctor2
GO
GRANT VIEW DEFINITION ON SYMMETRIC KEY::doctor2key TO doctor2
GO


-------------------

EXECUTE AS USER ='doctor1'
PRINT USER
GO
OPEN SYMMETRIC KEY doctorkey
	DECRYPTION BY CERTIFICATE doctor1cert
GO
--	View the list of open keys in the session
SELECT *
FROM sys.openkeys
GO

