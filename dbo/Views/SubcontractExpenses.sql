CREATE VIEW dbo.SubcontractExpenses AS

	--
	-- Updated: 2016-02-01 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT	tblPWADetailFunding.ProjectID, tblPWADetailFunding.MasterConstDivCodeID, tblSubPayApp.AppStatus, tblPWADetailFunding.RequiredAmount
	FROM	tblPWADetailFunding
			INNER JOIN tblSubPayApp ON tblPWADetailFunding.PWALogID = tblSubPayApp.PWALogID
	WHERE	tblSubPayApp.IsDeleted='N'

GO

