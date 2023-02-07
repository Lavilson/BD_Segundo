USE Pubs
GO
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [au_id]
      ,[title_id]
      ,[au_ord]
      ,[royaltyper]
  FROM [pubs].[dbo].[titleauthor]
  ORDER BY [royaltyper]
GO

-- 30 40 100
CREATE OR ALTER PROCEDURE [dbo].[Royalties]
	@percentage int = 30 
WITH ENCRYPTION
AS
	select au_id 
	from titleauthor
	where titleauthor.royaltyper = @percentage
GO

EXECUTE [Royalties]
GO

--au_id
--267-41-2394
--472-27-2349


EXECUTE [Royalties] 100
GO

--au_id
--172-32-1176
--213-46-8915
--238-95-7766
--274-80-9391
--486-29-1786
--486-29-1786
--648-92-1872
--712-45-1867
--807-91-6654
--998-72-3567

SP_HELP [Royalties]
GO
SP_HELPTEXT [Royalties]
GO

-- The text for object 'Royalties' is encrypted.
