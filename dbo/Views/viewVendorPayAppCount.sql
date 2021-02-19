CREATE VIEW dbo.viewVendorPayAppCount AS

--SELECT DISTINCT  a.VendorID
--			    ,b.SubPayAppId
--			    ,a.ProjectID
--FROM		    dbo.tblPWALog AS a
--			    INNER JOIN dbo.tblSubPayApp AS b ON a.PWALogID = b.PWALogID 

SELECT DISTINCT  tblPWALog.VendorID
			    ,tblSubPayApp.SubPayAppSequence
			    ,tblPWALog.ProjectID
FROM		    tblPWALog
			    INNER JOIN dbo.tblSubPayApp ON tblPWALog.PWALogID = tblSubPayApp.PWALogID

GO

