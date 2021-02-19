-- =============================================
-- Author:		Lolt
-- Create date: 21-Aug-2014
-- Description:	return tblClientContact.ContactId for Primary ContactWaivers
-- =============================================
CREATE FUNCTION [dbo].[ClientWaiversContactId] 
(
	@ClientId int = 0
)
RETURNS int
AS
BEGIN
	DECLARE @Result int = 0
	DECLARE @ContactId int
	IF @ClientId > 0 
		BEGIN   -- First choice is Primary ContactWaivers
			SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
				AND primaryContactWaivers = 1
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

