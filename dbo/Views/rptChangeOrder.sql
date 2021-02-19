CREATE VIEW rptChangeOrder AS

	SELECT		co.ChangeOrderID, co.ChangeNum, co.BillingStatus, co.[Desc], p.ProjectID, p.ProjectNum, p.ProjectName, c.ClientName AS ClientCompany, e.FullName AS ClientContact, 
				'ClientFullAddress' AS ClientFullAddress, cod.ScopeItem, cod.Qty, cod.Unit, cod.UnitPrice, ISNULL(cod.Qty, 0) * ISNULL(cod.UnitPrice, 0) AS TotalPrice_CALC, cod.SortOrder, 
				cod.ChangeOrderDetailID, co.ChangeNumRev
	FROM        dbo.tblChangeOrder AS co LEFT OUTER JOIN
				dbo.tblChangeOrderDetail AS cod ON co.ChangeOrderID = cod.ChangeOrderID INNER JOIN
				dbo.tblProject AS p ON co.ProjectID = p.ProjectID LEFT OUTER JOIN
				dbo.tblClient AS c ON p.ClientID = c.ClientID INNER JOIN
				dbo.tblProjectDefaultContacts AS d ON p.ProjectID = d.ProjectId LEFT OUTER JOIN
				dbo.tblClientContact AS e ON d.ClientContactId = e.ContactId
	WHERE		(cod.OverHeadAndProfitLineItem = 0) AND (cod.SalesTaxLineItem = 0) AND (d.Role = 'Contracts')

GO

