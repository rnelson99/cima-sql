
CREATE VIEW dbo.viewPWAFunding AS
	--
	-- Updated: 2016-02-22 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT	tblPWADetailFunding.PWADetailFundingID
			, tblPWADetailFunding.PWALogID
			, tblPWADetailFunding.ProjectID
			, tblPWADetailFunding.MasterConstDivCodeID
			, tblConstDivCodes.ConstructionDivCode
			, viewBudget.ConstructionDivCodeFormatted
			, viewBudget.AcctCat
			, tblConstDivCodes.AcctItem
			, CAST(ISNULL(viewBudget.ApprovedAmount, 0) AS money) - CAST(ISNULL(viewBudget.CommittedAmount, 0) AS money) AS UncommittedAmt
			, CASE WHEN tblPWALog.PWAStatusId IN (4, 5, 7) THEN tblPWADetailFunding.RequiredAmount ELSE 0 END AS CommittedThisPWA
			, ISNULL(viewBudget.CommittedAmount, 0) AS CommittedAllPWA
			, CASE WHEN tblPWALog.PWAStatusId IN (4, 5, 7) THEN 0 WHEN tblPWADetailFunding.RequiredAmount > (CAST(ISNULL(viewBudget.ApprovedAmount, 0) AS money) -
				CAST(ISNULL(viewBudget.CommittedAmount, 0) AS money)) THEN 0 ELSE (CAST(ISNULL(viewBudget.ApprovedAmount, 0) AS money) -
				CAST(ISNULL(viewBudget.CommittedAmount, 0) AS money)) - tblPWADetailFunding.requiredamount END AS ShortFall
	FROM	tblPWADetailFunding
			LEFT OUTER JOIN tblConstDivCodes ON tblPWADetailFunding.MasterConstDivCodeID = tblConstDivCodes.CodeID
			INNER JOIN viewBudget ON tblPWADetailFunding.ProjectID = viewBudget.ProjectID
				AND tblPWADetailFunding.MasterConstDivCodeID = viewBudget.MasterConstDivCodeID
			INNER JOIN tblPWALog ON tblPWADetailFunding.PWALogID = tblPWALog.PWALogID
	WHERE	tblPWALog.IsDeleted='N'

GO

