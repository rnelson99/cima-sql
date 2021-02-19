/*
	For use by srptScopeAndSchedule_Vendors
*/
CREATE VIEW qryScopeAndSchedule_Vendors
AS
SELECT a.ProjectId,b.Vendor,d.FirstName,d.Lastname,
d.officephone as Phone, d.MobilePhone as Mobile,d.Email,
CASE  WHEN len(d.email) <= 45 THEN d.email ELSE
REPLACE(d.email,'@',Char(10) + Char(13) + '@')
END as EmailFormatted
FROM tblProjectWork a LEFT JOIN tblVendor b ON a.Vendor=b.VendorId
JOIN tblProject c ON a.ProjectId=c.ProjectId JOIN tblVendorContact d ON d.vendorId=b.vendorid
WHERE d.contactid=dbo.VendorContractsContactId(b.vendorid)

GO

