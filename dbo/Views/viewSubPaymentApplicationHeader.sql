CREATE VIEW dbo.viewSubPaymentApplicationHeader AS

	SELECT a.PWALogID, b.VendorID, b.Vendor, c.ProjectName, c.ProjectStreet + ', ' + c.ProjectCity AS ProjectAddress,
		CASE WHEN len(pwalognumber) = 1 THEN c.ProjectNum + '.0' + CAST(a.pwalognumber AS char) ELSE c.ProjectNum + '.' + CAST(a.pwalognumber AS char) END AS PWANum,
		a.PWALogAmount AS OriginalContract, CAST(ISNULL(e.ApprovedChanges, 0) AS money) AS ApprovedChanges,
		b.VendorShortName, c.ProjectShortName
	FROM tblPWALog AS a
		INNER JOIN tblVendor AS b ON a.VendorID = b.VendorID
		INNER JOIN tblProject AS c ON a.ProjectID = c.ProjectID
		LEFT OUTER JOIN	viewApprovedSubcontractChanges AS e ON a.PWALogID = e.ParentPWAID

GO

