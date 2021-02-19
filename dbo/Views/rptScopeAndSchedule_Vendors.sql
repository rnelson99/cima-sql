CREATE VIEW rptScopeAndSchedule_Vendors AS

	SELECT     a.ProjectID, d.ClientName, c.LocationStreet AS ClientStreet, ISNULL(c.LocationCity, '') + ', ' + c.Zip AS CityZip, b.OfficePhone AS ClientPhone, b.MobilePhone AS MobileNumber, 
						  b.EMail AS ClientEMail, sup.UserInitials AS CIMASup, pm.UserInitials AS CIMAProjectManager, a.ProjectStartDate
	FROM         dbo.tblProject AS a LEFT OUTER JOIN
						  dbo.tblClientContact AS b ON a.ClientID = b.ClientId LEFT OUTER JOIN
						  dbo.tblClientLocation AS c ON a.ClientID = c.ClientId LEFT OUTER JOIN
						  dbo.tvalUserSecurity AS sup ON a.CIMASup = sup.UserSecurityID LEFT OUTER JOIN
						  dbo.tvalUserSecurity AS pm ON a.CIMAProjectManager = pm.UserSecurityID INNER JOIN
						  dbo.tblClient AS d ON a.ClientID = d.ClientID
	WHERE     (b.ContactId = dbo.ClientContractsContactId(a.ClientID, a.ProjectID)) AND (c.DefaultLocation = 1)

GO

