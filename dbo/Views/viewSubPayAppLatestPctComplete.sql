CREATE VIEW dbo.viewSubPayAppLatestPctComplete AS

	--
	-- Updated: 2016-02-01 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT	PWALogID, ISNULL(PctComplete, 0) AS LatestPctComplete
	FROM	tblSubPayApp AS a
	WHERE	(SubPayAppSequence IN
			(SELECT MAX(SubPayAppSequence) AS Expr1
			 FROM	tblSubPayApp
			 WHERE	(PWALogID = a.PWALogID)
				AND	(IsDeleted='N')))
			 AND (a.IsDeleted='N')

GO

