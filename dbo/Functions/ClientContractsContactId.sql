
-- =========================================================================================================
-- Author:		Lolt
-- Create date: 21-Aug-2014
-- Description:	return tblClientContact.ContactId for Primary ContactContracts
-- Modified date: 27-Jun-2015 (Butz) - Add ProjetID (Case 221 - Contract Summary - Contact Info Incorrect)
-- =========================================================================================================
CREATE FUNCTION [dbo].[ClientContractsContactId] 
(
	@ClientId	int = 0,
	@ProjectId	int = 0
)
RETURNS int
AS
BEGIN
	DECLARE @Result int = 0
	DECLARE @ContactId int
	IF (@ClientId <> 0 AND @ProjectId = 0)
		BEGIN   -- First choice is Primary ContactContracts
			SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
				AND primaryContactContracts = 1
			-- Otherwise Primary Bid
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
				AND primaryContactBid = 1
			-- Otherwise just pick one
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact WHERE ClientId = @ClientId
		END	
	ELSE IF (@ClientId <> 0 AND @ProjectId <> 0)
		-- Section added by Butz: 27-Jun-2015 - Case 221 - Contract Summary - Contact Info Incorrect
		BEGIN
			-- Get first Project Default Contact (Contract)
			SELECT @ContactId = MIN(ClientContactId) FROM tblProjectDefaultContacts
			WHERE ProjectId=@ProjectId AND [Role]='Contracts'
			
			-- If no Contact found, try Bid
			IF ISNULL(@ContactId,0) = 0
				SELECT @ContactId = MIN(ClientContactId) FROM tblProjectDefaultContacts
				WHERE ProjectId=@ProjectId AND [Role]='Bid'
			
			-- If no Contact found, try any
			IF ISNULL(@ContactId,0) = 0
				SELECT @ContactId = MIN(ClientContactId) FROM tblProjectDefaultContacts
				WHERE ProjectId=@ProjectId AND NOT ClientContactId IS NULL
			
			-- If still no Contact found, get from Client
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact
				WHERE ClientId = @ClientId AND primaryContactContracts = 1

			-- Otherwise Primary Bid
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact
				WHERE ClientId = @ClientId AND primaryContactBid = 1
			-- Otherwise just pick one
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblClientContact
				WHERE ClientId = @ClientId
			
		END
		SET @result=ISNULL(@ContactId,0)
	RETURN @Result
END

GO

