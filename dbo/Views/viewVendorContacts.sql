-- =============================================
-- Author:		Lolt
-- Create date: 21-Aug-2014
-- Description:	Contact Id for Vendor Contact Roles
-- =============================================
CREATE VIEW viewVendorContacts
AS
	SELECT VendorId
	,dbo.VendorJobsiteContactId(VendorId) as 'PrimaryContactJobsiteId'
	,dbo.VendorPayAppContactId(VendorId) as 'PrimaryPayAppContactId'
	,dbo.VendorContractsContactId(VendorId) as 'PrimaryContractsContactId'
	,dbo.VendorWaiversContactId(VendorId) as 'PrimaryWaiversContactId'
	FROM tblVendor

GO

