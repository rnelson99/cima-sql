


CREATE VIEW [dbo].[viewPWASuperintendent]
AS
SELECT DISTINCT 
                      dbo.tblPWALog.PWALogID, dbo.tblProject.ProjectID, dbo.tblVendorContact.FirstName + ' ' + dbo.tblVendorContact.LastName AS [Super Name], 
                      dbo.tblVendorContact.MobilePhone AS [Super Mobile], dbo.tblVendorContact.OfficePhone AS [Super Office], dbo.tblVendorContact.EMail AS [Super Email]
FROM         dbo.tblProject INNER JOIN
                      dbo.tblPWALog ON dbo.tblProject.ProjectID = dbo.tblPWALog.ProjectID INNER JOIN
                      dbo.tblVendor ON dbo.tblPWALog.VendorID = dbo.tblVendor.VendorID INNER JOIN
                      dbo.tblVendorContact ON dbo.tblVendor.VendorID = dbo.tblVendorContact.VendorId AND dbo.tblVendor.VendorID = dbo.tblVendorContact.VendorId
WHERE     dbo.PWASuperintendentId(PWALogId) > 0

GO

