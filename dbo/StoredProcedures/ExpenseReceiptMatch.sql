--exec dbo.ExpenseReceiptMatch 26
create PROCEDURE dbo.ExpenseReceiptMatch
	@UserID int = 0
AS
BEGIN
	SET NOCOUNT ON;

		--select * from tblExpenseAutomatch

		IF OBJECT_ID('tempdb..#TempMatch') IS NOT NULL    DROP TABLE #TempMatch
		IF OBJECT_ID('tempdb..#CreditCardItems') IS NOT NULL    DROP TABLE #CreditCardItems
		IF OBJECT_ID('tempdb..#Expenses') IS NOT NULL    DROP TABLE #Expenses

		create table #TempMatch (CreditCardID int, ExpenseID int)

		select *, 0 as processed
		into #CreditCardItems
		from expense.CreditCardItems
		where ExpenseID is null

		select expenseid, CCAmount
		into #Expenses
		from tblExpense 
		where isnull(receiptmatch,0) = 0





		while exists (Select top 1 CreditCardID from #CreditCardItems where processed = 0)
		begin
			declare @creditCardID int = (Select top 1 CreditCardID from #CreditCardItems where processed = 0)

			declare @amount money = (Select ccamount from #CreditCardItems where CreditCardID = @creditCardID)
			declare @name varchar(1000) = (Select name from #CreditCardItems where CreditCardID = @creditCardID)
			declare @fitid varchar(1000) = (Select FITID from #CreditCardItems where CreditCardID = @creditCardID)
			declare @acctnumber varchar(1000) = (Select AccountNumber from #CreditCardItems where CreditCardID = @creditCardID)
	
			if @amount < 0 
			begin
				set @amount = @amount * -1
			end
	
			insert into #TempMatch (CreditCardID, ExpenseID)
			Select @creditCardID, ExpenseID 
			from #Expenses where CCAmount = @amount

			update #CreditCardItems set processed = 1 where CreditCardID = @creditCardID
		end

		select c.CreditCardID, c.dtPosted, c.CCAmount, c.Name, c.FITID, c.AccountNumber, c.AccountID, ee.ExpenseID, e.CCAmount as expamount, 
			e.CreatedOn, e.ExpReason, e.CodeID, e.ProjectID,
			z.AcctItem, p.ProjectName, p.ProjectNum, e.expenseuser,
			case when e.expenseuser = @UserID then 1 else 0 end as isUsers
		from #CreditCardItems c 
		join #TempMatch t on t.CreditCardID = c.CreditCardID
		join #Expenses ee on ee.ExpenseID = t.ExpenseID
		join tblExpense e on e.ExpenseID = ee.ExpenseID
		left join tblConstDivCodes z on z.CodeID = e.CodeID
		left join tblProject p on p.ProjectID = e.ProjectID

		

END

GO

