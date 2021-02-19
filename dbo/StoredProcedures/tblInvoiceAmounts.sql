

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec [dbo].[tblInvoiceAmounts] 1215, 0
CREATE     PROCEDURE [dbo].[tblInvoiceAmounts]
	@projectidIn int = 0,
	@invoiceidIn int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2
	declare @ProjectID int = 0
	declare @OurCompany varchar(100) = ''
	declare @ServiceTax int = 0
	declare @ExpenseTax int = 0
	declare @taxRate float = 0
	declare @defaultTaxRate float = 0.0825
	declare @totalInvoiceGross  money = 0.00
	Select InvoiceID, ServicesInvoice, Retainage, RetainagePercentage, InvoiceGross, totalExpenseAmount, totalExpenseTax, totalServiceAmount, totalServiceTax, Status, InvoiceStatus, 0 as processed,
		ProjectID
	into #Results
	from tblInvoice i
	where status != 'void'
	-- and InvoiceDate > '2018-01-01'
	order by InvoiceID desc
	if @projectidIn > 0
	begin
		Delete from #Results where projectid != @projectidIn
	end
	if @invoiceidIn > 0
	begin
		Delete from #Results where InvoiceID != @invoiceidIn
	end
	select c.ChangeOrderID, d.ChangeTotal, c.GCOHP, c.GCOHPPercent, COTotal, GCOHPAmount, SalesTax, ProjectID, 0 as Processed
	into #Results2
	from tblChangeOrder c
	left join (
		Select ChangeOrderID, sum(isnull(Qty,0) * isnull(UnitPrice,0)) as ChangeTotal
		from tblChangeOrderDetail 
		where Status = 1
		group by ChangeOrderID
	) d on d.ChangeOrderID = c.ChangeOrderID
	where c.ProjectID in (select projectid from tblInvoice i
	where status != 'void'
	--and InvoiceDate > '2018-01-01'
	)
	if @projectidIn > 0
	begin
		Delete from #Results2 where projectid != @projectidIn
	end
	if @invoiceidIn > 0
	begin
		Delete from #Results2
	end
	while exists (Select top 1 ChangeOrderID from #Results2 where processed = 0)
	begin
		declare @ChangeOrderID int = (Select top 1 ChangeOrderID from #Results2 where Processed = 0)
		declare @GCOHP int = (Select top 1 GCOHP from #Results2 where ChangeOrderID = @ChangeOrderID)
		declare @GCOHPPercent float = (Select top 1 GCOHPPercent from #Results2 where ChangeOrderID = @ChangeOrderID)
		set @GCOHPPercent = isnull(@GCOHPPercent,0)
		if @GCOHPPercent >= 1 
		begin
			set @GCOHPPercent = @GCOHPPercent / 100
		end
		declare @ChangeTotal money = (Select top 1 ChangeTotal from #Results2 where  ChangeOrderID = @ChangeOrderID)
		set @ProjectID  = (Select projectid from #Results2 where ChangeOrderID = @ChangeOrderID)
		set @OurCompany = (Select ourcompany from tblProject where projectid = @ProjectID)
		set @ServiceTax  = (	select taxAnswer as ServiceTax from project.salesTaxQuestions
			where taxQuestion in (11)
			and taxAnswer in (1,3)
			and projectid = @ProjectID
			)
		set @ExpenseTax  = (
			select taxAnswer as ExpenseTax from project.salesTaxQuestions
			where taxQuestion in (12)
			and taxAnswer in (1,3)
			and projectid = @ProjectID
			)
		set @ExpenseTax = isnull(@expenseTax,0)
		set @ServiceTax = isnull(@ServiceTax,0)
		set @taxRate  = (
			select isnull(sum(SalesTaxRate),0) as SumSalesTaxRate 
			from tblProjectSalesTax
			where projectid = @ProjectID
			)
		-- Plus Tax
		-- Tax Included
		/* 
			CIMATODO:  
			3/7/2020 : The if statement below *if @OurCompany = 'NJ'* needs to also look at CIMA;
			If the company is 'CIMA' but a expert witenss then need to do the same sales tax as NJ model
		*/
		if @OurCompany = 'NJ'
		begin
			if @ServiceTax = 0 and @ExpenseTax = 0
			begin
				set @taxRate = 0
			end
			else
			begin
				if @taxRate = 0 set @taxRate = @defaultTaxRate
			end
		end
		else if @OurCompany = 'CIMA'
		begin 
			if (select count(*) as ct from project.salesTaxDetermination where projectid = @ProjectID and saleTax = 1 and status = 1) > 0
			begin
				-- we have sales tax to apply
				/*
					CIMATODO:
					3/7/2020 - Need to get the sales tax for what is entered in the table
				*/
				if @taxRate = 0 set @taxRate = @defaultTaxRate
			end
		end
		declare @GCOHPAmount float = round(@ChangeTotal * isnull(@GCOHPPercent,0),2)
		declare @ChangeTotalGCOHP float = round(@ChangeTotal + @GCOHPAmount,2)
		declare @ChangeOrderTax float = round(@ChangeTotalGCOHP * @taxRate,2)
		set @ChangeOrderTax = isnull(@ChangeOrderTax,0)
		update tblChangeOrder set
			COTotal = @ChangeTotalGCOHP + @ChangeOrderTax,
			GCOHPAmount = @GCOHPAmount,
			SalesTax = @ChangeOrderTax
		where ChangeOrderID = @ChangeOrderID
		update #Results2 set Processed = 1 where ChangeOrderID = @ChangeOrderID
	end
	while exists (Select top 1 InvoiceID from #Results where processed = 0)
	begin
		declare @InvoiceID int = (Select top 1 invoiceid from #Results where processed = 0)
		set @ProjectID = (Select projectid from #Results where InvoiceID = @InvoiceID)
		declare @SalesTaxApply varchar(100) = (Select attribute from project.attributes where Status = 1 and attributetype = 'SalesTaxApply' and projectid = @ProjectID)
		set @OurCompany = (Select ourcompany from tblProject where projectid = @ProjectID)
		declare @ServicesInvoice int = (Select ServicesInvoice from #Results where InvoiceID = @InvoiceID)
		declare @InvoiceGross money = (Select InvoiceGross from #Results where InvoiceID = @InvoiceID)
		declare @Retainage money = (Select Retainage from #Results where InvoiceID = @InvoiceID)
		set @InvoiceGross = ISNULL(@InvoiceGross,0)
		set @Retainage = ISNULL(@Retainage,0)
		declare @InvoiceNet money = @InvoiceGross - @Retainage
		set @ServiceTax  = (	select taxAnswer as ServiceTax from project.salesTaxQuestions
			where taxQuestion in (10)
			and taxAnswer in (1,3)
			and projectid = @ProjectID
			)
		set @ExpenseTax  = (
			select taxAnswer as ExpenseTax from project.salesTaxQuestions
			where taxQuestion in (11)
			and taxAnswer in (1,3)
			and projectid = @ProjectID
			)
		set @ExpenseTax = isnull(@expenseTax,0)
		set @ServiceTax = isnull(@ServiceTax,0)
		set @taxRate  = (
			select isnull(sum(SalesTaxRate),0) as SumSalesTaxRate 
			from tblProjectSalesTax
			where projectid = @ProjectID
			)
		-- Plus Tax
		-- Tax Included
		if @OurCompany = 'NJ' or @ServicesInvoice = 1
		begin
			if @ServiceTax = 0 and @ExpenseTax = 0
			begin
				set @taxRate = 0
			end
			else
			begin
				if @taxRate = 0 set @taxRate = @defaultTaxRate
			end
		end
		else if @OurCompany = 'CIMA'
		begin 
			if (select count(*) as ct from project.salesTaxDetermination where projectid = @ProjectID and saleTax = 1 and status = 1) > 0
			begin
				-- we have sales tax to apply
				/*
					CIMATODO:
					3/7/2020 - Need to get the sales tax for what is entered in the table
				*/
				if @taxRate = 0 set @taxRate = @defaultTaxRate
			end
		end
		declare @TaxRate2 float = 1 + @taxRate
		declare @TotalExpenseAmount money = 0.00
		declare @TotalExpenseAmountMarkup money = 0.00
		declare @TotalServiceAmount money = 0.00
		declare @TotalExpenseTax money = 0.00
		declare @TotalServiceTax money = 0.00
		if @ServicesInvoice = 1
		begin
			-- Need to get TimeStuff and Expense for this invoice
			set @TotalServiceAmount = (select sum(coalesce(BHours,hours,0) * BillRate) as TotalService
				from TimeSheet.TimeSheetDetails 
				where ReferenceID = @ProjectID
				and invoiceID = @invoiceidIn
				and Status = 1
				)
			set @TotalExpenseAmount =
				isnull((select sum(coalesce(billamount,ccamount,0)) as expenseAmount
				from tblExpense
				where ProjectID = @ProjectID
				and invoiceID = @invoiceidIn
				),0)
				+
				isnull((select sum(isnull(PWALogAmount,0)) as pwaLogAmount
				from tblPWALog
				where ProjectID = @ProjectID
				and invoiceID = @invoiceidIn
				),0)
			set @TotalExpenseAmountMarkup = (
				select sum(coalesce(billamount,ccamount,0)) - sum(isnull(ccamount,0)) as expenseMarkupAmount
				from tblExpense
				where ProjectID = @ProjectID
				and invoiceID = @invoiceidIn
				)
			if @ExpenseTax = 1
			begin
				set @TotalExpenseTax = @TotalExpenseAmount * @taxRate
			end
			else if @ExpenseTax = 3
			begin
				set @TotalExpenseTax = @TotalExpenseAmountMarkup * @taxRate
			end
			if @ServiceTax = 1
			begin
				set @TotalServiceTax = @TotalServiceAmount * @taxRate
			end
			set @totalInvoiceGross = isnull(@TotalServiceAmount,0) + isnull(@TotalServiceTax,0) + isnull(@TotalExpenseAmount,0) + isnull(@TotalExpenseTax,0)
		end
		else
		begin
			-- Need to go off what was entered.
			-- @InvoiceNet
			set @totalInvoiceGross = isnull(@InvoiceGross,0)
			if @SalesTaxApply = 'Tax Included'
			begin
				set @TotalServiceTax = (@InvoiceNet / @TaxRate2) * @taxRate
				set @TotalServiceTax = round(isnull(@TotalServiceTax,0),2)
				set @TotalServiceAmount = @InvoiceNet - @TotalServiceTax
			end 
			else
			begin
				set @TotalServiceTax = @InvoiceNet * @taxRate
				set @TotalServiceTax = round(isnull(@TotalServiceTax,0),2)
				set @TotalServiceAmount = @InvoiceNet - @TotalServiceTax
			end
			set @totalInvoiceGross = isnull(@InvoiceGross,0) --+ isnull(@TotalServiceAmount,0) + isnull(@TotalServiceTax,0) + isnull(@TotalExpenseAmount,0) + isnull(@TotalExpenseTax,0)
		end
		update tblInvoice 
				set totalServiceAmount = @TotalServiceAmount, 
					totalServiceTax = @TotalServiceTax, 
					totalExpenseAmount = @TotalExpenseAmount, 
					totalExpenseTax = @TotalExpenseTax,
					totalInvoiceGross = @totalInvoiceGross 
			where InvoiceID = @InvoiceID 
		update #Results set processed = 1 where InvoiceID = @InvoiceID
	end
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2
END

GO

