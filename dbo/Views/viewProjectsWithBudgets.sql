--
-- Create view of Projects having non-zero budgets
CREATE VIEW viewProjectsWithBudgets
AS
WITH ProjectBudgets (ProjectId, BaseBudget)
AS (
	SELECT ProjectId, Sum(Basebudgetamount)
	FROM tblBudget GROUP BY ProjectId)
SELECT  a.ProjectId, a.ProjectNum, a.ProjectName, b.BaseBudget, a.ClientId,a.CIMA_Status
FROM dbo.tblProject a JOIN ProjectBudgets b ON a.ProjectId=b.ProjectId
    WHERE b.BaseBudget > 0

GO

