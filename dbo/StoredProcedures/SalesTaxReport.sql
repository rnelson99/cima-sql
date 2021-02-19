
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec dbo.SalesTaxReport
CREATE   PROCEDURE [dbo].[SalesTaxReport]
	-- Add the parameters for the stored procedure here
	@sd varchar(100) = '2020-07-01', 
	@ed varchar(100) = '2020-07-31',
	@company varchar(100) = 'cima'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    
-- Cash
	
	declare @tblProjectID table (projectidFLD int)

	if @company = 'cima' 
	begin
		Insert into @tblProjectID (projectidFLD)
		Select projectid from tblProject where OurCompany = 'cima'
		union select 0
		union select 1
		union select -1
	end
	else if @company = 'nj'
	begin
		Insert into @tblProjectID (projectidFLD)
		Select projectid from tblProject where OurCompany = 'nj'
	end
	else
	begin
		Insert into @tblProjectID (projectidFLD)
		Select projectid from tblProject 
		union select 0
		union select 1
		union select -1
	end

	IF OBJECT_ID('tempdb..#ztmpSalesTaxReportCash') IS NOT NULL DROP TABLE #ztmpSalesTaxReportCash
	IF OBJECT_ID('tempdb..#ztmpSalesTaxReportCashWriteOff') IS NOT NULL DROP TABLE #ztmpSalesTaxReportCashWriteOff

	
	--select * from viewSalesTaxReport

	--Insert into INTO #ztmpSalesTaxReportCash ( ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities ) 
	SELECT ProjectID, ClientID, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, 
		InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities, 0 as IsMiscIncome
	INTO #ztmpSalesTaxReportCash
	FROM viewSalesTaxReport t
	join @tblProjectID z on z.projectidFLD = t.ProjectID
	WHERE t.ProjectState='TX' 
	AND convert(date, t.DatePay) >= convert(date, @sd)
	AND convert(date, t.DatePay) <= convert(date, @ed)
	AND t.PaymentTypeDescription<>'Writeoff'
	

	--exec dbo.SalesTaxReport
	SELECT ProjectID, ClientID, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, 
		InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities 
	into #ztmpSalesTaxReportCashWriteOff
	FROM viewSalesTaxReport t
	join @tblProjectID z on z.projectidFLD = t.ProjectID
	WHERE t.ProjectState='TX'
	AND t.DatePay >= convert(date, @sd)
	AND t.DatePay <= convert(date, @ed)
	AND t.PaymentTypeDescription='Writeoff'
	
	


	select 1 as rs, case when CIMAChargingSalesTax = 1 and isnull(projectsalestax,0) < .0625 then 1 
						when CIMAChargingSalesTax = 0 and isnull(projectsalestax,0) > 0 then 1 
						else 0 end as salesTaxError
		, * from #ztmpSalesTaxReportCash order by DatePay 

	select 2 as rs, * from #ztmpSalesTaxReportCashWriteOff

	declare @ccamount money = (select sum(e.CCAmount) as totalAmount
								from tblExpenseReport er 
								join tblExpense e on e.ExpenseReportID = er.ExpenseReportID 
									and e.TransactionDate >= @sd and e.TransactionDate <= @ed and e.SalesTaxID = 3
								where er.ExpenseReportStatus = 'Approved' )
	set @ccamount = isnull(@ccamount,0)
	
	;with cte as (
		select 3 as rs, p.LocalCode, p.JurisdictionName, p.SalesTaxRate, t.AmountApply, 
			 1 as flip, t.Taxable as qtaxable, t.ProjectSalesTax, t.ProjectID
		from #ztmpSalesTaxReportCash t
		left join tblProjectSalesTax p on p.ProjectID = t.ProjectID --and p.LocalCode <> '1'
		where 1=1 and p.SalesTaxRate > 0

		union select 3, LocalCode, Jurisdiction, TaxRate, @ccamount, 0 as flip, @ccamount as qtaxable, TaxRate, 0 as projectid
		from tblSalesTaxEntity
		where LocalCode in ('1','2061177','5061578','5061587') 
	)

	Select rs, localcode, JurisdictionName, SalesTaxRate,  AmountApply as AMOUNTAPPLY,  flip, qtaxable, ProjectSalesTax, projectid
	from cte
	--group by localcode, JurisdictionName, SalesTaxRate, projectsalestax, flip
	order by case when LocalCode = 1 then 0 else 1 end, JurisdictionName
	
--	select * from tblSalesTaxEntity
	
	
	/*
	exec dbo.SalesTaxReport
	*/
	
	Select 4 as rs, e.TransactionDate, v.LastName as Vendor, e.CCAmount, u.FirstName, u.LastName, er.ExpenseReportStatus
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 3 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	join @tblProjectID z on z.projectidFLD = isnull(e.ProjectID,0)
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus = 'Approved' 
	order by e.TransactionDate

	Select 5 as rs, e.TransactionDate, v.LastName as Vendor, e.CCAmount, u.FirstName, u.LastName, er.ExpenseReportStatus, er.UserEntityID
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 3 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	join @tblProjectID z on z.projectidFLD = isnull(e.ProjectID,0)
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus != 'Approved' 
	order by e.TransactionDate
	--exec dbo.SalesTaxReport

	Select isnull(sum(e.SalesTax),0) as creditSalesTax
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 2 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	join @tblProjectID z on z.projectidFLD = isnull(e.ProjectID,0)
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus = 'Approved' 
	
END

GO

