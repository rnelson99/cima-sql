CREATE VIEW viewProjectBasics AS

	SELECT		a.ProjectID, a.ProjectNum AS CIMAProjectNum, b.ClientName, a.CIMA_Status AS Status, a.CIMA_Bid AS [Base Contract], 
				ISNULL(dbo.ProjectSalesTax(a.ProjectId), 0) AS SalesTaxRate, a.CIMAChargingSalesTax, a.ClientID, a.ProjectName AS [Project Name], 
				a.ProjectStreet AS [Project Address], a.ProjectCity + ' ' + a.ProjectState + ' ' + a.ProjectZip AS ProjectCity, c.LocationStreet AS ClientStreet, 
				c.LocationCity + ' ' + c.LocationState + ' ' + c.Zip AS ClientCity, ISNULL(d.Salutation, '') + ' ' + ISNULL(d.FirstName, '') + ' ' + ISNULL(d.LastName, '') AS client
	FROM		tblProject AS a INNER JOIN
				tblClient AS b ON a.ClientID = b.ClientID LEFT OUTER JOIN
				tblClientLocation AS c ON b.ClientID = c.ClientId AND c.DefaultLocation = 1 INNER JOIN
				tblClientContact AS d ON d.ContactId = dbo.ClientContractsContactId(a.ClientID, a.ProjectID)

GO

