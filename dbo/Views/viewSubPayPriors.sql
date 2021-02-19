CREATE VIEW dbo.viewSubPayPriors AS

	--WITH Subcontracts(PWALogId, SubPayAppSequence) AS (SELECT DISTINCT PWALogID, SubPayAppSequence FROM dbo.tblSubPayApp)
	--SELECT     b.PWALogId, b.SubPayAppSequence, c.PWALogAmount, ISNULL(d.ApprovedChanges, 0) AS PWAChanges, SUM(ISNULL(a.WorkCompleted, 0)) AS PriorWorkCompleted, 
	--					SUM(ISNULL(a.StoredMaterial, 0)) AS PriorStoredMaterial, CAST((SUM(ISNULL(a.WorkCompleted, 0)) + SUM(ISNULL(a.StoredMaterial, 0))) / (c.PWALogAmount + ISNULL(d.ApprovedChanges, 0)) 
	--					AS decimal(18, 2)) AS LastPctComplete
	--FROM         dbo.tblSubPayApp AS a INNER JOIN
	--					Subcontracts AS b ON a.PWALogID = b.PWALogId AND a.SubPayAppSequence < b.SubPayAppSequence INNER JOIN
	--					dbo.tblPWALog AS c ON b.PWALogId = c.PWALogID LEFT OUTER JOIN
	--					dbo.viewApprovedSubcontractChanges AS d ON b.PWALogId = d.ParentPWAID
	--WHERE     (c.PWALogAmount <> 0)
	--GROUP BY b.PWALogId, b.SubPayAppSequence, c.PWALogAmount, d.ApprovedChanges

	WITH		Subcontracts(PWALogId, SubPayAppSequence) AS (SELECT DISTINCT PWALogID, SubPayAppSequence FROM tblSubPayApp WHERE IsDeleted='N')
	SELECT		Subcontracts.PWALogId, Subcontracts.SubPayAppSequence, tblPWALog.PWALogAmount, ISNULL(viewApprovedSubcontractChanges.ApprovedChanges, 0) AS PWAChanges, 
				SUM(ISNULL(tblSubPayApp.WorkCompleted, 0)) AS PriorWorkCompleted, 
				SUM(ISNULL(tblSubPayApp.StoredMaterial, 0)) AS PriorStoredMaterial,
				CAST((SUM(ISNULL(tblSubPayApp.WorkCompleted, 0)) + SUM(ISNULL(tblSubPayApp.StoredMaterial, 0))) / (tblPWALog.PWALogAmount + ISNULL(viewApprovedSubcontractChanges.ApprovedChanges, 0)) AS decimal(18, 2)) AS LastPctComplete
	FROM		tblSubPayApp INNER JOIN
				Subcontracts ON tblSubPayApp.PWALogID = Subcontracts.PWALogId AND tblSubPayApp.SubPayAppSequence < Subcontracts.SubPayAppSequence INNER JOIN
				tblPWALog ON Subcontracts.PWALogId = tblPWALog.PWALogID LEFT OUTER JOIN
				viewApprovedSubcontractChanges ON Subcontracts.PWALogId = viewApprovedSubcontractChanges.ParentPWAID
	WHERE		(tblPWALog.PWALogAmount <> 0) AND (tblSubPayApp.IsDeleted='N')
	GROUP BY	Subcontracts.PWALogId, Subcontracts.SubPayAppSequence, tblPWALog.PWALogAmount, viewApprovedSubcontractChanges.ApprovedChanges

GO

