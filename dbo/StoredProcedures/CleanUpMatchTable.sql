-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec dbo.CleanUpMatchTable
CREATE PROCEDURE dbo.CleanUpMatchTable
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	select matchid, MatchName, entityid,
		RANK() OVER (PARTITION BY MatchName, EntityID ORDER BY matchid ) as rnk
	into #Results
	from Expense.ExpenseMatch

	delete from Expense.ExpenseMatch where matchid in (
	select matchid from #Results where rnk > 1)
	
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2

	Select id, StartWithMatchName, entityid, VendorCCName,
		RANK() OVER (PARTITION BY StartWithMatchName, entityid, VendorCCName ORDER BY id ) as rnk
	into #Results2
	from expense.ExpensePartialMatch

	delete from Expense.ExpensePartialMatch where id in (
	select id from #Results2 where rnk > 1)

END

GO

