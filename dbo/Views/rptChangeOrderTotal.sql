CREATE VIEW rptChangeOrderTotal AS

	SELECT		a.ChangeOrderID, a.ChangeNum, a.BillingStatus, a.[Desc], a.ProjectID, a.ProjectNum, a.ProjectName, a.ClientCompany, a.ClientContact, a.ClientFullAddress,
				'Overhead' AS ScopeItem, NULL AS qty, '' AS Unit, NULL AS UnitPrice, CAST(SUM(a.TotalPrice_CALC) AS Decimal(18, 2)) AS TotalPrice_CALC, b.GCOHP,
				b.GCOHPPercent, a.ChangeNumRev
	FROM		dbo.rptChangeOrder AS a INNER JOIN
				dbo.tblChangeOrder AS b ON a.ChangeOrderID = b.ChangeOrderID
	GROUP BY	a.ChangeOrderID, a.ChangeNum, a.BillingStatus, a.[Desc], a.ProjectID, a.ProjectNum, a.ProjectName, a.ClientCompany, a.ClientContact, a.ClientFullAddress,
				b.GCOHP, b.GCOHPPercent, a.ChangeNumRev

GO

