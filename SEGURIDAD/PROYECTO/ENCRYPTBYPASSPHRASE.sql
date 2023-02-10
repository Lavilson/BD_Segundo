
USE LONJA_LRM
GO
CREATE TABLE [dbo].[Metodos_Pago](
	[ID_Pago] [int] IDENTITY(1,1)  NOT NULL,
	[Nombre] [varchar](255) NOT NULL,
	TarjetaCredito VARBINARY(128)
)
GO


	

-- Insertamos valor
INSERT INTO [Metodos_Pago] (Nombre, TarjetaCredito)
VALUES ('Lavi', ENCRYPTBYPASSPHRASE
('thisisthepharase','1565-5165-4856-6518'))
GO
SELECT * FROM Metodos_Pago
-- Intentamis hacer un select convencional

SELECT * FROM Metodos_Pago

--ID_Pago	Nombre	TarjetaCredito
--1				pepe	0x020000000A3A169717EBA96DB73F28DF331E268DEFFCBF52A7128002FE02C1C793D6029417D0AF9C5ADDD1150A3D7FA27D22902D

--- Intentamos hacer un select con una frase incorrecta

SELECT ID_Pago, Nombre, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('EstEsMiFjjhraseSecreta', TarjetaCredito))
FROM Metodos_Pago
GO
--1	pepe	NULL


--Ahora hacemos un select con la frase correcta

SELECT ID_Pago, Nombre, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('thisisthepharase', TarjetaCredito)) AS TarjetaCredito
FROM Metodos_Pago
GO
--1	pepe	1111-1111-1111-1111


-- Añadimos un autenticador
DECLARE @v_Usuario SYSNAME
-- SET @v_Usuario = 'lrm'
SET  @v_Usuario = SYSTEM_USER
PRINT SYSTEM_USER
INSERT INTO Metodos_Pago (Nombre, TarjetaCredito)
VALUES ('Josue', ENCRYPTBYPASSPHRASE('thisisthepharase','1565-7456-2345-7894',
			1,@v_Usuario))

SELECT * FROM Metodos_Pago

--Ahora hacemos un select con la frase correcta
-- y con el autenticador correcto
DECLARE @v_Usuario SYSNAME
-- SET @v_Usuario = 'lrm'
SET  @v_Usuario = SYSTEM_USER
SELECT ID_Pago, Nombre, CONVERT(VARCHAR(50),
DECRYPTBYPASSPHRASE ('thisisthepharase', TarjetaCredito,1,@v_Usuario)) AS TarjetaCredito
FROM Metodos_Pago
GO
