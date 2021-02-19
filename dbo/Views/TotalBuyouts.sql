                
CREATE VIEW TotalBuyouts
AS                
SELECT ProjectID,MasterConstDivCodeID, Sum(isnull(BudgetCostChangeAmount,0)) as 'BuyOuts'

FROM dbo.tblBudgetCostChangeLog
WHERE BudgetCostChangeReason='Buy Out'
GROUP BY ProjectID,MasterConstDivCodeID

GO

