USE LONJA_LRM
GO
INSERT INTO PRODUCTO(Nombre, Cantidad,Fecha_Captura )
VALUES ('Caballa',2541,'2023-02-1'),
		('Boqueron',843,'2023-02-9'),
		('Merluza',4558,'2023-02-10'),
		('Atún',80000,'2023-02-10');


SELECT Nombre, Cantidad,Fecha_Captura 
FROM PRODUCTO

CREATE OR ALTER PROCEDURE Capturas (@fecha DATE)
WITH ENCRYPTION
AS
   SELECT id_Producto, Nombre, Cantidad, Fecha_Captura
   FROM Producto
   WHERE Fecha_Captura = @fecha
GO


EXECUTE Capturas '2023-02-10'
GO

SP_HELP Capturas
GO
SP_HELPTEXT Capturas
GO

-- The text for object 'Royalties' is encrypted.
