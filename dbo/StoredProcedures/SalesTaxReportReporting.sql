-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec dbo.SalesTaxReportReporting '2019-08-01', '2018-08-31', '36CFD723-E0F9-47D5-A641-B570C70ADEBC'
CREATE PROCEDURE [dbo].[SalesTaxReportReporting] 
	-- Add the parameters for the stored procedure here
	@sd varchar(100) = '2017-05-01', 
	@ed varchar(100) = '2018-04-30'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    -- select newid()
-- Cash



	IF OBJECT_ID('tempdb..#ztmpSalesTaxReportCash') IS NOT NULL DROP TABLE #ztmpSalesTaxReportCash
	IF OBJECT_ID('tempdb..#ztmpSalesTaxReportCashWriteOff') IS NOT NULL DROP TABLE #ztmpSalesTaxReportCashWriteOff


	--select * from viewSalesTaxReport

	--Insert into INTO #ztmpSalesTaxReportCash ( ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities ) 
	SELECT ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, 
		InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities, 0 as IsMiscIncome
	INTO #ztmpSalesTaxReportCash
	FROM viewSalesTaxReport 
	WHERE viewSalesTaxReport.ProjectState='TX' 
	AND convert(date, viewSalesTaxReport.DatePay) >= convert(date, @sd)
	AND convert(date, viewSalesTaxReport.DatePay) <= convert(date, @ed)
	AND viewSalesTaxReport.PaymentTypeDescription<>'Writeoff'


	INSERT INTO #ztmpSalesTaxReportCash ( ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities, 
		IsMiscIncome ) 
	SELECT 0 AS ProjectID, 0 AS ClientID, '' AS ClientName, '' AS CIMA_Status, '' AS ProjectNum, tblVendor.Vendor AS ProjectShortName, '' AS ProjectCity, '' AS ProjectState, '' AS TaxingEntity, 
		case when tblMiscIncome.IsSalesTaxPayable = 'Y' then -1 else 0 end AS CIMAChargingSalesTax, 
		case when tblMiscIncome.IsSalesTaxPayable = 'Y' then 0.0825 else 0 end AS ProjectSalesTax, tblMiscIncome.MiscIncomeDate AS DatePay, tblMiscIncome.MiscIncomeDate AS InvoiceDate, 
		'Misc-' + cast([MiscIncomeID] as varchar(100)) AS InvoiceNumber, tblMiscIncome.MiscIncomeAmount AS AmountApply, 
		case when tblMiscIncome.IsSalesTaxPayable='Y' then [MiscIncomeAmount]/1.0825 else 0 end AS Taxable, 
		tlkpPaymentType.PaymentTypeDescription, 
		case when tblMiscIncome.IsSalesTaxPayable = 'Y' then 'FM-City, FM-CRM, FF-Fire' else '' end AS ProjectTaxingEntities, -1 AS IsMiscIncome 

	FROM (tblMiscIncome 
	JOIN tblVendor ON tblMiscIncome.VendorID = tblVendor.VendorID) 
	JOIN tlkpPaymentType ON tblMiscIncome.PaymentTypeID = tlkpPaymentType.PaymentTypeID 
	WHERE tblMiscIncome.MiscIncomeDate >= convert(date, @sd)
	AND tblMiscIncome.MiscIncomeDate <= convert(date, @ed)
	AND tblMiscIncome.MiscIncomeAmount IS not NULL
	AND tlkpPaymentType.PaymentTypeDescription<>'Writeoff'
	AND tblMiscIncome.IsDeleted='N'

	--exec dbo.SalesTaxReport
	SELECT ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, 
		InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities 
	into #ztmpSalesTaxReportCashWriteOff
	FROM viewSalesTaxReport 
	WHERE viewSalesTaxReport.ProjectState='TX'
	AND viewSalesTaxReport.DatePay >= convert(date, @sd)
	AND viewSalesTaxReport.DatePay <= convert(date, @ed)
	AND viewSalesTaxReport.PaymentTypeDescription='Writeoff'


	INSERT INTO #ztmpSalesTaxReportCashWriteOff ( ProjectID, ClientID, ClientName, CIMA_Status, ProjectNum, ProjectShortName, ProjectCity, ProjectState, TaxingEntity, CIMAChargingSalesTax, ProjectSalesTax, DatePay, InvoiceDate, InvoiceNumber, AmountApply, Taxable, PaymentTypeDescription, ProjectTaxingEntities ) 
	SELECT 0 AS ProjectID, 0 AS ClientID, '' AS ClientName, '' AS CIMA_Status, '' AS ProjectNum, tblVendor.Vendor AS ProjectShortName, '' AS ProjectCity, '' AS ProjectState, '' AS TaxingEntity, 
	case when tblMiscIncome.IsSalesTaxPayable = 'Y' then -1 else 0 end AS CIMAChargingSalesTax, 
	case when tblMiscIncome.IsSalesTaxPayable='Y' then 0.0825 else 0 end AS ProjectSalesTax, tblMiscIncome.MiscIncomeDate AS DatePay, 
	tblMiscIncome.MiscIncomeDate AS InvoiceDate, 'Misc-' + cast([MiscIncomeID] as varchar(100)) AS InvoiceNumber, tblMiscIncome.MiscIncomeAmount AS AmountApply, 
	case when tblMiscIncome.IsSalesTaxPayable='Y' then [MiscIncomeAmount]/1.0825 else 0 end AS Taxable, tlkpPaymentType.PaymentTypeDescription, 
	case when tblMiscIncome.IsSalesTaxPayable='Y' then 'FM-City, FM-CRM, FF-Fire' else '' end AS ProjectTaxingEntities 
	FROM tblMiscIncome 
	JOIN tblVendor ON tblMiscIncome.VendorID = tblVendor.VendorID
	JOIN tlkpPaymentType ON tblMiscIncome.PaymentTypeID = tlkpPaymentType.PaymentTypeID 
	WHERE tblMiscIncome.MiscIncomeDate >= convert(date, @sd)
	AND tblMiscIncome.MiscIncomeDate <= convert(date, @ed)
	AND tblMiscIncome.MiscIncomeAmount IS NOT NULL
	AND tlkpPaymentType.PaymentTypeDescription='Writeoff' 
	AND tblMiscIncome.IsDeleted = 'N'

	Insert into ProviewTemp.dbo.SalesTaxReport_RS1 ([rs]
      ,[salesTaxError]
      ,[ProjectID]
      ,[ClientID]
      ,[ClientName]
      ,[CIMA_Status]
      ,[ProjectNum]
      ,[ProjectShortName]
      ,[ProjectCity]
      ,[ProjectState]
      ,[TaxingEntity]
      ,[CIMAChargingSalesTax]
      ,[ProjectSalesTax]
      ,[DatePay]
      ,[InvoiceDate]
      ,[InvoiceNumber]
      ,[AmountApply]
      ,[Taxable]
      ,[PaymentTypeDescription]
      ,[ProjectTaxingEntities]
      ,[IsMiscIncome])
	select 1 as rs, case when CIMAChargingSalesTax = 1 and isnull(projectsalestax,0) < .0625 then 1 
						when CIMAChargingSalesTax = 0 and isnull(projectsalestax,0) > 0 then 1 
						else 0 end as salesTaxError
		, *  from #ztmpSalesTaxReportCash order by DatePay 

	insert into ProviewTemp.dbo.SalesTaxReport_RS2  ([rs]
      ,[ProjectID]
      ,[ClientID]
      ,[ClientName]
      ,[CIMA_Status]
      ,[ProjectNum]
      ,[ProjectShortName]
      ,[ProjectCity]
      ,[ProjectState]
      ,[TaxingEntity]
      ,[CIMAChargingSalesTax]
      ,[ProjectSalesTax]
      ,[DatePay]
      ,[InvoiceDate]
      ,[InvoiceNumber]
      ,[AmountApply]
      ,[Taxable]
      ,[PaymentTypeDescription]
      ,[ProjectTaxingEntities])
	select 2 as rs, *  from #ztmpSalesTaxReportCashWriteOff

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

	insert into ProviewTemp.dbo.SalesTaxReport_RS3 ([rs]
      ,[localcode]
      ,[JurisdictionName]
      ,[SalesTaxRate]
      ,[AMOUNTAPPLY]
      ,[flip]
      ,[qtaxable]
      ,[ProjectSalesTax]
      ,[projectid]
	)
	Select rs, localcode, JurisdictionName, SalesTaxRate,  AmountApply as AMOUNTAPPLY,  flip, qtaxable, ProjectSalesTax, projectid
	from cte
	--group by localcode, JurisdictionName, SalesTaxRate, projectsalestax, flip
	order by case when LocalCode = 1 then 0 else 1 end, JurisdictionName
	
--	select * from tblSalesTaxEntity
	
	
	/*
	exec dbo.SalesTaxReport
	*/
	insert into ProviewTemp.dbo.SalesTaxReport_RS4 ([rs]
      ,[TransactionDate]
      ,[Vendor]
      ,[CCAmount]
      ,[FirstName]
      ,[LastName]
      ,[ExpenseReportStatus]
	)
	Select 4 as rs, e.TransactionDate, v.LastName as Vendor, e.CCAmount, u.FirstName, u.LastName, er.ExpenseReportStatus
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 3 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus = 'Approved' 
	order by e.TransactionDate

	Insert into ProviewTemp.dbo.SalesTaxReport_RS5 (
		[rs]
      ,[TransactionDate]
      ,[Vendor]
      ,[CCAmount]
      ,[FirstName]
      ,[LastName]
      ,[ExpenseReportStatus]
      ,[UserEntityID]
	)
	Select 5 as rs, e.TransactionDate, v.LastName as Vendor, e.CCAmount, u.FirstName, u.LastName, er.ExpenseReportStatus, er.UserEntityID
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 3 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus != 'Approved' 
	order by e.TransactionDate
	--exec dbo.SalesTaxReport

	Insert into ProviewTemp.dbo.SalesTaxReport_RS6 ([creditSalesTax]	)
	Select isnull(sum(e.SalesTax),0) as creditSalesTax
	from tblExpenseReport er 
	join tblExpense e on e.ExpenseReportID = er.ExpenseReportID and e.SalesTaxID = 2 and e.IsDeleted = 'N' and e.CCAmount != 0 and e.TransactionDate >= @sd and e.TransactionDate <= @ed
	left join Contacts.Entity v on v.EntityID = e.VendorEntityID
	left join Contacts.Entity u on u.EntityID = er.UserEntityID
	where er.ExpenseReportStatus = 'Approved' 
	
END

GO

