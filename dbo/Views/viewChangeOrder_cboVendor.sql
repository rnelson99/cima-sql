
/*  Create view for Vendor combo box on sfrmChangeOrderDetails
	Include all vendors for the current project and DivCode */

CREATE VIEW [dbo].[viewChangeOrder_cboVendor] 
AS
SELECT DISTINCT b.VendorId, b.Vendor, a.ProjectId, a.MasterConstDivCodeId
FROM tblPWADetailFunding a JOIN tblVendor b ON a.VendorId=b.VendorId
    JOIN tblPWALog c ON a.PWALogId = c.PWALogId
WHERE c.PWAStatusId in (4,5,7)

GO

