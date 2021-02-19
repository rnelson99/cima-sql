CREATE VIEW dbo.viewCumulativeSubPayappDetail AS


	--WITH Subcontracts(PWALogId, SubPayAppSequence) AS (SELECT DISTINCT PWALogID, SubPayAppSequence FROM dbo.tblSubPayApp)
	--	SELECT     b.PWALogId, b.SubPayAppSequence, c.PWALogAmount, ISNULL(d.ApprovedChanges, 0) AS PWAChanges, SUM(ISNULL(a.WorkCompleted, 0)) AS WorkCompleted, SUM(ISNULL(a.StoredMaterial, 
	--							0)) AS StoredMaterial, SUM(ISNULL(a.Retainage, 0)) AS Retainage, CAST((SUM(ISNULL(a.WorkCompleted, 0)) + SUM(ISNULL(a.StoredMaterial, 0))) 
	--							/ (c.PWALogAmount + ISNULL(d.ApprovedChanges, 0)) AS decimal(18, 4)) AS PctComplete
	--	 FROM         dbo.tblSubPayApp AS a INNER JOIN
	--							Subcontracts AS b ON a.PWALogID = b.PWALogId AND a.SubPayAppSequence <= b.SubPayAppSequence INNER JOIN
	--							dbo.tblPWALog AS c ON b.PWALogId = c.PWALogID LEFT OUTER JOIN
	--							dbo.viewApprovedSubcontractChanges AS d ON b.PWALogId = d.ParentPWAID
	--	 GROUP BY b.PWALogId, b.SubPayAppSequence, c.PWALogAmount, d.ApprovedChanges

	--
	-- Updated: 2016-02-01 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	WITH Subcontracts(PWALogId, SubPayAppSequence) AS (SELECT DISTINCT PWALogID, SubPayAppSequence FROM tblSubPayApp WHERE IsDeleted='N')
	SELECT		Subcontracts.PWALogId, Subcontracts.SubPayAppSequence, tblPWALog.PWALogAmount, ISNULL(d.ApprovedChanges, 0) AS PWAChanges,
				SUM(ISNULL(tblSubPayApp.WorkCompleted, 0)) AS WorkCompleted, SUM(ISNULL(tblSubPayApp.StoredMaterial, 0)) AS StoredMaterial,
				SUM(ISNULL(tblSubPayApp.Retainage, 0)) AS Retainage,
				CAST((SUM(ISNULL(tblSubPayApp.WorkCompleted, 0)) + SUM(ISNULL(tblSubPayApp.StoredMaterial, 0))) / (tblPWALog.PWALogAmount + ISNULL(d.ApprovedChanges, 0)) AS decimal(18, 4)) AS PctComplete
	FROM		tblSubPayApp INNER JOIN
				Subcontracts ON tblSubPayApp.PWALogID = Subcontracts.PWALogId AND tblSubPayApp.SubPayAppSequence <= Subcontracts.SubPayAppSequence INNER JOIN
				tblPWALog ON Subcontracts.PWALogId = tblPWALog.PWALogID LEFT OUTER JOIN
				viewApprovedSubcontractChanges AS d ON Subcontracts.PWALogId = d.ParentPWAID
	WHERE		tblSubPayApp.IsDeleted='N'
	GROUP BY	Subcontracts.PWALogId, Subcontracts.SubPayAppSequence, tblPWALog.PWALogAmount, d.ApprovedChanges

GO

