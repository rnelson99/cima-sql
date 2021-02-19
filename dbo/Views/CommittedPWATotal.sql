CREATE VIEW dbo.CommittedPWATotal AS
	--
	-- Updated: 2016-02-22 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT		tblPWALog.ProjectID
				, tblPWADetailFunding.MasterConstDivCodeID
				, SUM(ISNULL(tblPWADetailFunding.RequiredAmount, 0)) AS TotalCommittedPWAs
	FROM		tblPWALog
				INNER JOIN tblPWADetailFunding ON tblPWALog.ProjectID = tblPWADetailFunding.ProjectID
				AND tblPWALog.PWALogID = tblPWADetailFunding.PWALogID
	WHERE		(tblPWALog.PWAStatusID NOT IN (1, 6))
				AND (tblPWALog.IsDeleted='N')
	GROUP BY	tblPWALog.ProjectID, tblPWADetailFunding.MasterConstDivCodeID
	HAVING		(SUM(ISNULL(tblPWADetailFunding.RequiredAmount, 0)) > 0)

GO

