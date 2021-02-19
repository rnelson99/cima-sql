CREATE VIEW dbo.viewPWAVendorContacts AS

SELECT DISTINCT 
                      dbo.tblPWALog.PWALogID, dbo.tblProject.ProjectID, (ISNULL(dbo.tblVendorContact.FirstName,'') + ' ' + ISNULL(dbo.tblVendorContact.LastName,'')) AS [Super Name], 
                      dbo.tblVendorContact.MobilePhone AS [Super Mobile], dbo.tblVendorContact.OfficePhone AS [Super Office], dbo.tblVendorContact.EMail AS [Super Email], 
                      dbo.tblVendorContact.primaryContactContracts, dbo.tblVendorContact.primaryContactJobsite, dbo.tblVendorContact.primaryContactPayApp
FROM         dbo.tblProject INNER JOIN
                      dbo.tblPWALog ON dbo.tblProject.ProjectID = dbo.tblPWALog.ProjectID INNER JOIN
                      dbo.tblVendor ON dbo.tblPWALog.VendorID = dbo.tblVendor.VendorID LEFT OUTER JOIN
                      dbo.tblVendorContact ON dbo.tblVendor.VendorID = dbo.tblVendorContact.VendorId AND dbo.tblVendor.VendorID = dbo.tblVendorContact.VendorId
WHERE    (ISNULL(dbo.tblVendorContact.FirstName,'') + ' ' + ISNULL(dbo.tblVendorContact.LastName,'') IS NOT NULL)

GO

