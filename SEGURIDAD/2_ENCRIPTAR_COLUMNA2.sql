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

--Insert into our table

INSERT INTO patientdata
VALUES		(1,
			'Jack',
			'Doctor1',
			ENCRYPTBYKEY(key_guid('Doctor1key'),'11111111'),
			ENCRYPTBYKEY(key_guid('Doctor1key'),'Cut'))
GO

INSERT INTO patientdata
VALUES		(2,
			'Jill',
			'Doctor1',
			ENCRYPTBYKEY(key_guid('Doctor1key'),'22222222'),
			ENCRYPTBYKEY(key_guid('Doctor1key'),'Bruise'))
GO

INSERT INTO patientdata
VALUES		(3,
			'Jim',
			'Doctor1',
			ENCRYPTBYKEY(key_guid('Doctor1key'),'33333333'),
			ENCRYPTBYKEY(key_guid('Doctor1key'),'Headache'))
GO
SELECT * FROM Patientdata

--Close all opened Keys

CLOSE ALL SYMMETRIC KEYS
GO
REVERT

-------------
--DOCTOR2


EXECUTE AS USER ='doctor2'
PRINT USER
GO
OPEN SYMMETRIC KEY doctor2key
	DECRYPTION BY CERTIFICATE doctor2cert
GO
--	View the list of open keys in the session
SELECT *
FROM sys.openkeys
GO

--Insert into our table

INSERT INTO patientdata
VALUES		(4,
			'Rick',
			'Doctor2',
			ENCRYPTBYKEY(key_guid('Doctor2key'),'44444444'),
			ENCRYPTBYKEY(key_guid('Doctor2key'),'Cut'))
GO

INSERT INTO patientdata
VALUES		(5,
			'Mark',
			'Doctor2',
			ENCRYPTBYKEY(key_guid('Doctor2key'),'55555555'),
			ENCRYPTBYKEY(key_guid('Doctor2key'),'Evans'))
GO

INSERT INTO patientdata
VALUES		(6,
			'Milton',
			'Doctor2',
			ENCRYPTBYKEY(key_guid('Doctor2key'),'66666666'),
			ENCRYPTBYKEY(key_guid('Doctor2key'),'Cold'))
GO
SELECT [name],uid,[symptom] FROM Patientdata

--Close all opened Keys

CLOSE ALL SYMMETRIC KEYS
GO
REVERT

SELECT [name],uid,[symptom] FROM Patientdata



EXECUTE AS USER ='doctor1'
PRINT USER
GO
OPEN SYMMETRIC KEY doctor1key
	DECRYPTION BY CERTIFICATE doctor1cert
GO

SELECT id,
name,
doctorname,
CONVERT(VARCHAR, Decryptbykey(uid)) AS UID,
CONVERT(VARCHAR, Decryptbykey(symptom)) AS Sintomas
FROM patientdata
GO

CLOSE ALL SYMMETRIC KEYS
GO
REVERT
-----------------------
--Doctor2


EXECUTE AS USER ='doctor2'
PRINT USER
GO
OPEN SYMMETRIC KEY doctor2key
	DECRYPTION BY CERTIFICATE doctor2cert
GO

SELECT id,
name,
doctorname,
CONVERT(VARCHAR, Decryptbykey(uid)) AS UID,
CONVERT(VARCHAR, Decryptbykey(symptom)) AS Sintomas
FROM patientdata
GO

CLOSE ALL SYMMETRIC KEYS
GO
REVERT


