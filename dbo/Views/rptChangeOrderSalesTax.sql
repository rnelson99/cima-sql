CREATE VIEW rptChangeOrderSalesTax AS

	SELECT		a.ChangeOrderID, a.ChangeNum, a.BillingStatus, a.[Desc], a.ProjectID, a.ProjectNum, a.ProjectName, a.ClientCompany, a.ClientContact, a.ClientFullAddress, 'Sales Tax' AS ScopeItem, a.qty, a.Unit, 
				a.UnitPrice, CASE WHEN a.GCOHP > 0 THEN CAST(a.TotalPrice_CALC * (1 + b.GCOHPPercent / 100) * ISNULL(dbo.ProjectSalesTax(b.projectid), 0) AS Decimal(18, 2)) 
				ELSE CAST(a.TotalPrice_CALC * ISNULL(dbo.ProjectSalesTax(b.projectid), 0) AS Decimal(18, 2)) END AS TotalPrice_CALC, 99 AS SortOrder,
				NULL AS ChangeOrderDetailID, a.ChangeNumRev
	FROM		dbo.rptChangeOrderTotal AS a INNER JOIN
				dbo.tblChangeOrder AS b ON a.ChangeOrderID = b.ChangeOrderID
	WHERE		(ISNULL(dbo.ProjectSalesTax(b.ProjectID), 0) > 0)

GO

