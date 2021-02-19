
CREATE VIEW dbo.TotalRequiredFromUnapprovedPWAs AS
	--
	-- Updated: 2016-02-22 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT		tblPWALog.ProjectID, tblPWADetailFunding.MasterConstDivCodeID, SUM(ISNULL(tblPWADetailFunding.RequiredAmount, 0)) AS Required
	FROM		tblPWALog
				INNER JOIN tblPWADetailFunding ON tblPWALog.PWALogID = tblPWADetailFunding.PWALogID
	WHERE		(tblPWALog.PWAStatusID NOT IN (5, 6, 7))
				AND (tblPWALog.IsDeleted='N')
	GROUP BY	tblPWALog.ProjectID, tblPWADetailFunding.MasterConstDivCodeID

GO

