
-- =============================================
-- Author:		Lolt
-- Create date: 20-Aug-2014
-- Description:	return tblVendorContact.ContactId for PWA Superintendent
-- =============================================
CREATE FUNCTION [dbo].[PWASuperintendentId] 
(
	@PWAId int = 0
)
RETURNS int
AS
BEGIN
	DECLARE @Result int = 0
	DECLARE @VendorId int
	DECLARE @ContactId int
	IF @PWAId > 0 
		BEGIN        --  Get VendorID
			SELECT @VendorId = VendorId FROM tblPWALog WHERE PWALogId=@PWAId
			IF @VendorId > 0
			BEGIN   -- First choice is Primary ContactJobsite
				SELECT @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
					AND primaryContactJobsite = 1
				-- Otherwise Primary Contracts
				IF ISNULL(@ContactId,0) = 0 
					SELECT @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
					AND primaryContactContracts = 1
				-- Otherwise just pick one
				IF ISNULL(@ContactId,0) = 0 
					SELECT TOP 1 @ContactId = MIN(ContactId) FROM tblVendorContact WHERE VendorId = @VendorId
			END	
			SET @result=ISNULL(@ContactId,0)
		END
	RETURN @Result
END

GO

