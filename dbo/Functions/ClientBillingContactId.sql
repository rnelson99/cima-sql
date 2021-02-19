-- =============================================
-- Author:		Lolt
-- Create date: 21-Aug-2014
-- Description:	return tblClientContact.ContactId for Primary ContactBilling
-- =============================================
CREATE FUNCTION [dbo].[ClientBillingContactId] 
(
	@ClientId int = 0
)
RETURNS int
AS
BEGIN
	DECLARE @Result int = 0
	DECLARE @ContactId int
	IF @ClientId > 0 
		BEGIN   -- First choice is Primary ContactBilling
			SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
				AND primaryContactBilling = 1
			-- Otherwise Primary Contracts
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
				AND primaryContactContracts = 1
			-- Otherwise just pick one
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
		END	
		SET @result=ISNULL(@ContactId,0)
	RETURN @Result
END

GO

