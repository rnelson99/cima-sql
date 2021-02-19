CREATE VIEW dbo.viewSubPayAppBilled AS
	--
	-- Updated: 2016-02-01 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT		PWALogID, SUM(ISNULL(WorkCompleted, 0) + ISNULL(StoredMaterial, 0)) AS Billed
	FROM		tblSubPayApp
	WHERE		IsDeleted='N'
	GROUP BY	PWALogID

GO

