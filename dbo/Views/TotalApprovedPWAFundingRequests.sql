
/*
For ProjectId  and Div Code, total all Approved PWA Funding Requests in the Cost Change Log

    qdf.SQL = "SELECT tblBudgetCostChangeLog.MasterConstDivCodeID, 
    tblBudgetCostChangeLog.ProjectID, " _
                & "Left([BudgetCostChangeReason],16) AS LabelHere, " _
                & "Sum(tblBudgetCostChangeLog.BudgetCostChangeAmount) AS TotalPWAFundingRequests " _
                & "FROM tblBudgetCostChangeLog " _
                & "GROUP BY tblBudgetCostChangeLog.MasterConstDivCodeID, tblBudgetCostChangeLog.ProjectID, Left([BudgetCostChangeReason],16) " _
                & "HAVING (((Left([BudgetCostChangeReason],16))=" & Chr(34) & "PWA Modification" & Chr(34) _
                & ") AND ((tblBudgetCostChangeLog.MasterConstDivCodeID)=" & lngMasterConstDivCodeID _
                & ") AND ((tblBudgetCostChangeLog.ProjectID)=" & glngCurrentProjectID _
                & ") AND ((Sum(tblBudgetCostChangeLog.BudgetCostChangeAmount))>0) " _
                & ")"

*/
CREATE VIEW [dbo].[TotalApprovedPWAFundingRequests]
AS
SELECT a.ProjectId, a.MasterConstDivCodeID, Sum(ISNULL(a.BudgetCostChangeAmount,0)) as TotalPWAFundingRequests
FROM dbo.tblBudgetCostChangeLog a
WHERE Substring(a.BudgetCostChangeReason,1,16) = 'PWA Modification' 
GROUP BY a.ProjectId, a.MasterConstDivCodeID
HAVING Sum(ISNULL(a.BudgetCostChangeAmount,0)) > 0

GO

