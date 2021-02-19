
-- =============================================
-- Author:		Lolt
-- Create date: 8-Nov-2014
-- Description:	Get Contact Name for PrimaryContractsClient
--	FogBugz 112, 8-Nov-2014  Correct SalesTax computation
-- =============================================
CREATE FUNCTION ClientPrimaryContracts
(
	@ClientId int
)
RETURNS varchar(100)
AS
BEGIN
	DECLARE @Result varchar(100)
	DECLARE @TryName varchar(100)
	
	SET @Result='Contracts Client Name'
--  Try PrimaryContactContracts first
	SELECT @TryName = Min(a.ContactName) FROM viewClientContactNames a JOIN
	tblClientContact b ON a.ContactId= b.ContactId
	WHERE a.ContactName IS NOT NULL AND b.primaryContactContracts = 1 AND 
	   b.ClientId=@ClientId
	IF @TryName IS NOT NULL
	   SET @Result=@TryName
	ELSE
	   BEGIN
	--  Try PrimaryContactBilling next
		SELECT @TryName = Min(a.ContactName) FROM viewClientContactNames a JOIN
		tblClientContact b ON a.ContactId= b.ContactId
		WHERE a.ContactName IS NOT NULL AND b.primaryContactBilling = 1 AND 
			b.ClientId=@ClientId
		IF @TryName IS NOT NULL
		   SET @Result=@TryName
	   END
	RETURN @Result

END

GO

