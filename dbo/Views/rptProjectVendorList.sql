
CREATE VIEW dbo.rptProjectVendorList AS
	--
	-- Updated: 2016-02-22 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	WITH	ProjectVendors(ProjectId, VendorId) AS	(SELECT DISTINCT ProjectID, VendorID FROM tblPWALog WHERE tblPWALog.IsDeleted='N')
    SELECT	ProjectVendors.ProjectId
			, tblProject.ProjectNum
			, tblProject.ProjectName
			, tblVendor.Vendor
			, tblVendor.VendorID
			, tblVendorContact.FirstName
			, tblVendorContact.LastName
			, tblVendorContact.OfficePhone
			, tblVendorContact.MobilePhone
			, tblVendorContact.EMail
     FROM	ProjectVendors 
			INNER JOIN tblProject ON ProjectVendors.ProjectId = tblProject.ProjectID
			INNER JOIN tblVendor ON tblVendor.VendorID = ProjectVendors.VendorId
			LEFT OUTER JOIN tblVendorContact ON tblVendorContact.ContactId = dbo.VendorContractsContactId(ProjectVendors.VendorId)

GO

