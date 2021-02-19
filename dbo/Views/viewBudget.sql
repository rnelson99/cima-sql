CREATE VIEW dbo.viewBudget AS

	SELECT	tblBudget.BudgetID
			, tblBudget.ProjectID
			, tblBudget.MasterConstDivCodeID
			, tblConstDivCodes.ConstructionDivCode
			, (LEFT(ConstructionDivCode,2) + ' ' + SUBSTRING(ConstructionDivCode,3,2) + ' ' + SUBSTRING(ConstructionDivCode,5,11)) AS ConstructionDivCodeFormatted
			, tblConstDiv.DivisionDescription AS AcctCat
			, tblConstDivCodes.AcctItem
			, tblBudget.BaseBudgetAmount
			, dbo.BudgetWithChangeOrders(tblBudget.ProjectID, tblBudget.MasterConstDivCodeID, tblBudget.BaseBudgetAmount) AS WithChangeOrders
			, dbo.BudgetApprovedAmount(tblBudget.ProjectID, tblBudget.MasterConstDivCodeID, tblBudget.BaseBudgetAmount) AS ApprovedAmount
			, dbo.BudgetWithChangeOrders(tblBudget.ProjectID, tblBudget.MasterConstDivCodeID, tblBudget.BaseBudgetAmount) - tblBudget.ProjectedAmount AS BudgetVariance
			, ISNULL(CommittedPWATotal.TotalCommittedPWAs, 0) AS CommittedAmount, ISNULL(SubcontractPayments.Amount, 0) AS SpentAmount, tblBudget.BudgetLastModified
			, tblBudget.ProjectedAmount
	FROM	tblBudget
			LEFT OUTER JOIN CommittedPWATotal ON tblBudget.ProjectID = CommittedPWATotal.ProjectId
				AND tblBudget.MasterConstDivCodeID = CommittedPWATotal.MasterConstDivCodeID
			LEFT OUTER JOIN SubcontractPayments ON tblBudget.ProjectID = SubcontractPayments.ProjectID
				AND tblBudget.MasterConstDivCodeID = SubcontractPayments.MasterConstDivCodeID
				AND SubcontractPayments.AppStatus = 'paid'
			INNER JOIN tblConstDivCodes ON tblBudget.MasterConstDivCodeID = tblConstDivCodes.CodeID
			LEFT OUTER JOIN tblConstDiv ON tblConstDivCodes.DivisionID = tblConstDiv.DivisionID

GO

