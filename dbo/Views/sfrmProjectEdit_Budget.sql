/*  View for sfrmProjectEdit_Budget
    Displays DivCode, Category and Item from tblConstDivCodes
*/
CREATE VIEW sfrmProjectEdit_Budget
AS
SELECT
a.BudgetID,a.ProjectID,a.MasterConstDivCodeID,a.BaseBudgetAmount,  b.ConstructionDivCode,
b.AcctCat, b.AcctItem
FROM dbo.tblBudget a LEFT JOIN dbo.tblConstDivCodes b ON a.MasterConstDivCodeID=b.codeid

GO

