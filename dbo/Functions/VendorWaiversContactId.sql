-- =============================================
-- Author:		Lolt
-- Create date: 21-Aug-2014
-- Description:	return tblVendorContact.ContactId for Primary Contact Waivers
-- =============================================
CREATE FUNCTION [dbo].[VendorWaiversContactId] 
(
	@VendorId int = 0
)
RETURNS int
AS
BEGIN
	DECLARE @Result int = 0
	DECLARE @ContactId int
	IF @VendorId > 0 
		BEGIN   -- First choice is Primary ContactWaivers
			SELECT @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
				AND primaryContactWaivers = 1
			-- Otherwise Primary Contracts
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
				AND primaryContactContracts = 1
			-- Otherwise just pick one
			IF ISNULL(@ContactId,0) = 0 
				SELECT @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
		END	
		SET @result=ISNULL(@ContactId,0)
	RETURN @Result
END

GO

