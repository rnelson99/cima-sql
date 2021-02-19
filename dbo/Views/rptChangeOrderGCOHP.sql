CREATE VIEW rptChangeOrderGCOHP AS

	SELECT		a.ChangeOrderID, a.ChangeNum, a.BillingStatus, a.[Desc], a.ProjectID, a.ProjectNum, a.ProjectName, a.ClientCompany, a.ClientContact, a.ClientFullAddress, 
				'General Contractor Markup for Overhead and Profit (GCOH&P).' AS ScopeItem, a.qty, a.Unit, a.UnitPrice, CAST(a.TotalPrice_CALC * b.GCOHPPercent / 100 AS Decimal(18, 2)) AS TotalPrice_CALC, 
				98 AS SortOrder, NULL AS ChangeOrderDetailID, a.ChangeNumRev
	FROM		dbo.rptChangeOrderTotal AS a INNER JOIN
				dbo.tblChangeOrder AS b ON a.ChangeOrderID = b.ChangeOrderID
	WHERE		(b.GCOHP > 0) AND (b.GCOHPPercent > 0)

GO

