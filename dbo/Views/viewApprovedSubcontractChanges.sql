
CREATE VIEW dbo.viewApprovedSubcontractChanges AS
	--
	-- Updated: 2016-02-22 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT		tblPWALog.ParentPWAID, SUM(tblPWALog.PWALogAmount) AS ApprovedChanges
	FROM		tblPWALog
				INNER JOIN tvalPWAStatus ON tblPWALog.PWAStatusID = tvalPWAStatus.PWAStatusID
	WHERE		(tblPWALog.ParentPWAID IS NOT NULL)
				AND (tblPWALog.PWALogTypeID = 2)
				AND (tvalPWAStatus.PWAStatusName IN ('Sent To Sub', 'Approved', 'Approve Unsigned'))
				AND (tblPWALog.IsDeleted='N')
	GROUP BY	tblPWALog.ParentPWAID

GO

