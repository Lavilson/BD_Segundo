


USE MASTER
GO
DROP DATABASE IF EXISTS SecureDB
GO

-- Creamos la base de datos de prueba
USE MASTER
GO
CREATE DATABASE SecureDB
GO

-- Usamos nuestra base de datos de demo
USE SecureDB
GO
--— Creamos una tabla cliente con una columna TarjetaCredito
--— de tipo varbinary para que contenga la informacion encriptada
CREATE TABLE dbo.Cliente
(CodigoCliente INT NOT NULL IDENTITY(1,1)
,Nombres VARCHAR(100) NOT NULL
,TarjetaCredito VARBINARY(128))
GO
--  insertamos un valor
INSERT INTO dbo.Cliente (Nombres, TarjetaCredito)
VALUES ('pepe', ENCRYPTBYPASSPHRASE
('EstaEsMiFraseSecreta','1111-1111-1111-1111'))
GO
-- Intentamos hacer un select convencional
SELECT CodigoCliente, Nombres, TarjetaCredito
FROM dbo.Cliente
go

--CodigoCliente	Nombres	TarjetaCredito
--1	pepe	0x0200000001E549F2D8B961FA334E801FAB3AC10BD4C3CE233BE98DD6CF4B6058292BA935B02DF5FCF2D453A859CF923FCBAAE5F2

-- Intentamos hacer un select con una frase incorrecta
SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE('EstaNoEsMiFraseSecreta',TarjetaCredito))
FROM dbo.Cliente
go

--CodigoCliente	Nombres	(No column name)
--1				pepe	NULL


-- Ahora hacemos un select con la frase correcta
SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50), 
DECRYPTBYPASSPHRASE('EstaEsMiFraseSecreta',TarjetaCredito)) AS TarjetaCredito
FROM dbo.Cliente
go

--CodigoCliente	Nombres	(No column name)
--1				pepe	1111-1111-1111-1111

-- Este método adicionalmente tiene una variante para dar un poco mas de seguridad a los datos y 
-- es que las funciones ENCRYPTBYPASSPHRASE y DECRYPTBYPASSPHRASE aceptan un tercer parámetro que 
-- es el autenticador, el cual tiene que ser colocado para desencriptar la información si es que se encriptó 
--con el autenticador. 
-- El autenticador podría ser el usuario que guardo la información, de esta manera cada usuario tendría 
-- encriptada su información y esta no sería visible a los demás usuarios. 

-- Añadimos un Autenticador
DECLARE @v_Usuario SYSNAME
-- SET @v_Usuario = 'cmm'
SET @v_Usuario = SYSTEM_USER
PRINT SYSTEM_USER
INSERT INTO dbo.Cliente (Nombres, TarjetaCredito)
VALUES ('ana', ENCRYPTBYPASSPHRASE('EstaEsMiFraseSecreta','2222-2222-2222-2222'
				,1,@v_Usuario))
GO

-- Intentamos hacer un select convencional
SELECT CodigoCliente, Nombres, TarjetaCredito
FROM dbo.Cliente
go

--CodigoCliente	Nombres	TarjetaCredito
--1				pepe	0x0200000001E549F2D8B961FA334E801FAB3AC10BD4C3CE233BE98DD6CF4B6058292BA935B02DF5FCF2D453A859CF923FCBAAE5F2
--2				ana	    0x020000007E87EDB1116210F2B901B3C894A0C8C0C9550161A492AD43CD369452F66C720EEDFAA25B48E406AB47EC506F7A20CCB7F13987E2977BA500D7C7A4B64A03778A

--  Ahora hacemos un select con la frase correcta
--  y con el autenticador correcto
DECLARE @v_Usuario SYSNAME
SET @v_Usuario = SYSTEM_USER
SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50), 
DECRYPTBYPASSPHRASE('EstaEsMiFraseSecreta',
TarjetaCredito,1,@v_Usuario))
FROM dbo.Cliente
go

--CodigoCliente	Nombres	(No column name)
--1	pepe	NULL
--2	ana	2222-2222-2222-2222

--  Ahora hacemos un select con la frase correcta
--  y con el autenticador INCORRECTO

DECLARE @v_Usuario SYSNAME
SET @v_Usuario = 'PEPE'
SELECT CodigoCliente, Nombres, CONVERT(VARCHAR(50), DECRYPTBYPASSPHRASE('EstaEsMiFraseSecreta',
TarjetaCredito,1,@v_Usuario))
FROM dbo.Cliente
go

--CodigoCliente	Nombres	(No column name)
--1				pepe	NULL
--2				ana		NULL