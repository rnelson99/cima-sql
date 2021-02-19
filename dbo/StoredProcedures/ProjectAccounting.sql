-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProjectAccounting]
--exec dbo.ProjectAccounting
	@projectActive int = 1,
	@projectCloseout int = 1,
	@projectInactive int = 0,
	@projectBidding int = 0,
	@projectSmall int = 1,
	@projectStatusAll int = 0
	
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#qProjects') IS NOT NULL
    DROP TABLE #qProjects
    
	select ProjectID as pid, ProjectNum, ProjectName, ProjectShortName, ProjectCity, 0 as CreditCard,
		0 as Contract, 0 as Payments, 0 as Backlog, 0 as AR,
		0 as Subcontracts, 0 as SubPayments, 0 as SubBacklog, 0 as AP,
		0 as NetBacklog, 0 as NetAR, 0 as Processed, 0 as MiscCC, 0 as InProcess, CIMA_Status, smallProject, 
		0 as PendingCO,
		0 as PendingSubCO
	into #qProjects
	from tblProject 
	
	if @projectStatusAll = 0
	begin
		if @projectActive = 0
		begin
			Delete from #qProjects where CIMA_Status in ('Active', 'Potential', 'Awarded')
		end
		if @projectCloseout = 0
		begin
			Delete from #qProjects where CIMA_Status in ('Closeout')
		end
		if @projectInactive = 0
		begin
			Delete from #qProjects where CIMA_Status in ('Inactive', 'No Job', 'On Hold', 'Complete')
		end
		if @projectBidding = 0
		begin
			Delete from #qProjects where CIMA_Status in ('Bidding', 'Bid Submitted')
		end
		if @projectSmall = 0
		begin
			Delete from #qProjects where isnull(smallProject,0) = 1
		end
	end
	
	

	while exists (select top 1 pid from #qProjects where Processed = 0 order by pid)
	begin
		IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
		DROP TABLE #tmp
		
		declare @projectid int = (select top 1 pid from #qProjects where Processed = 0 order by pid)
		--This is all of my AR Code
		declare @contract money = 0
		declare @base money = 0
		declare @backlog money = 0
		declare @ar money = 0
		declare @co money = 0
		declare @invoice money = 0
		declare @invoiceFinal money = 0
		declare @payments money = 0
		declare @FinalAmount money = 0
		declare @CC money = (select sum(CCAmount) from tblExpense where projectid = @projectid and PWALogID is null)
		set @payments = (select sum(AmountApply) as PaymentsTotal from tblPaymentApplied where projectid = @ProjectID and IsDeleted = 'N')
		select @invoice = (select sum(isnull(invoicegross,0) - isnull(Retainage,0)) as InvoiceAmount from tblInvoice where projectid = @ProjectID and status != 'Void' and InvoiceStatus != 'Final')
		select @invoiceFinal = (select sum(RemainingUnbilled) as InvoiceAmount from tblInvoice where projectid = @ProjectID and status != 'Void' and InvoiceStatus = 'Final')
		set @co = (select sum(isnull(totalprice_calc,0)) as TotalChangeOrder from rptChangeOrderUnion where projectid = @ProjectID and billingstatus in ('Approved', 'Verbally Approved'))
		set @base = (select CIMA_Bid from tblProject where projectid = @ProjectID)
		set @invoice = isnull(@invoice,0) + isnull(@invoicefinal,0)
		set @contract = isnull(@base,0) + isnull(@co,0)
		set @backlog = @contract - @invoice
		set @ar = @invoice - isnull(@payments,0)

		
		select distinct p.projectid, p.ProjectName, p.ProjectNum, p.ProjectCity, p.ProjectState, p.CIMA_Status as ProjectStatus, p.ProjectStreet, p.ProjectZip,
		isnull(l1.Contract,0) as ApprovedContract,
		isnull(temp.PayAmount,0) as SubPayments,
		isnull(l2.PayAmount,0) as Incomplete,
		0 as PendingSCO,
		0 as Late,
		isnull(temp.PayAmount,0) as TempAmount,
		isnull(p.ProjectStartDate,getdate()) as ProjectStartDate,
		--isnull(l1.Contract,0) - isnull(temp.PayAmount,0) - isnull(otherCC.CCAmount,0) + isnull(CCpaid.PayAmount,0)  as Backlog,
		0 as Backlog,
		isnull(ap.PayAmount,0) as AP,
		isnull(crdcard.CCAmount,0) cc1, isnull(CCpaid.PayAmount,0) cc2,
		otherCC.CCAmount as MiscCC,
		isnull(inProcess.PayAmount,0) as InProcess,
		pendingCO.changeTotal as pendingCO,
		pendingSubCO.totalPendingCost
		into #tmp
		-- 'Complete-Acct'
		from tblProject p
		left join (
					select ProjectID, sum(price) as changeTotal
					from viewChangeOrders
					where status = 'Pending'
					group by ProjectID
				) pendingCO on pendingCO.ProjectID = p.ProjectID
		left join (
					select l.ProjectID, sum(isnull(c.ItemQuantity,1) * isnull(ItemUnitPrice,0)) as totalPendingCost
					from tblPWALog l
					join tblPWADetailCost c on c.PWALogID = l.PWALogID and isnull(c.status,1) = 1
					where PWAStatusID in (1,4) and l.IsDeleted = 'N'
						and l.PWALogTypeID in (2,4)
					group by l.ProjectID
				) pendingSubCO on pendingSubCO.ProjectID = p.ProjectID
		left join (
				Select e.ProjectID, sum(CCAmount) as CCAmount
				from tblExpense e
				left join tblPWALog l on l.VendorID = e.VendorID and l.ProjectID = e.ProjectID 
				where l.vendorid is null-- and e.ProjectID = 656
				group by e.ProjectID
				) otherCC on otherCC.ProjectID = p.Projectid
		left join
		(select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
			from tblPWALog l
			join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N'
			where l.IsDeleted = 'N' and AppStatus = 'Approved by PM'
			group by l.ProjectID) inProcess on inProcess.ProjectID = p.ProjectID 
		left join
			(select sum(pwalogamount) as Contract, Projectid
				from tblPWALog l
				where PWAStatusID in (1,4,5,7)
				and IsDeleted = 'N'
				group by Projectid) l1 on l1.ProjectID = p.ProjectID
		left join
			(select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
				from tblPWALog l
				join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N' and s.paymenttypeid != 3
				where l.IsDeleted = 'N' and s.AppStatus in ('Incomplete')
				group by l.ProjectID) l2 on  l2.ProjectID = p.ProjectID
		left join
			(select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
				from tblPWALog l
				join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N'  
				where l.IsDeleted = 'N' and s.AppStatus in ('Paid', 'Check Printed','Check Picked Up', 'Sent to Sub')
				group by l.ProjectID) temp on  temp.ProjectID = p.ProjectID
		left join
			(select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
				from tblPWALog l
				join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N'
				where l.IsDeleted = 'N' and AppStatus not in ('Temp')
				group by l.ProjectID) backlog on backlog.ProjectID = p.ProjectID 
		left join
			(select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
				from tblPWALog l
				join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N'
				where l.IsDeleted = 'N' and AppStatus in ('Ready to Pay', 'Complete-Acct', 'Pay When Paid')
				group by l.ProjectID) ap on  ap.ProjectID = p.ProjectID 
		left join (select sum(workcompleted) as TtlPay, sum(workcompleted)-sum(isnull(Retainage,0)) as PayAmount, l.ProjectID
			from tblPWALog l
			join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N' and s.PaymentTypeID = 3
			where l.IsDeleted = 'N' and AppStatus = 'Paid'
			group by l.ProjectID) CCpaid on CCpaid.ProjectID = p.ProjectID 
		left join (select sum(CCAmount) as CCAmount,  ProjectID
			from tblExpense
			where isnull(pwalogid,0) = 0
			group by ProjectID) crdcard on crdcard.projectid = p.projectid 
		where p.ProjectID = @ProjectID 

		

		declare @sc float = 0 --subcontracts
		declare @sp float = 0 --subpayments
		declare @sb float = 0 -- subbacklog
		declare @ap float = 0 -- AP
		declare @psco float = 0 -- Pending SCO
		declare @ap1 float = 0
		declare @ap2 float = 0
		declare @ap3 float = 0

		update q 
			set q.Contract = isnull(@contract,0), 
				q.Payments = isnull(@payments,0), 
				q.Backlog = isnull(@backlog,0), 
				q.ar = isnull(@ar,0),
				q.CreditCard = isnull(@CC,0),
				q.MiscCC = isnull((Select MiscCC from #tmp),0),
				q.InProcess = isnull((Select InProcess from #tmp),0),
				q.PendingCO = isnull((Select pendingCO from #tmp),0),
				q.Subcontracts = isnull(v.approvedcontract,0),-- @sc,
				q.SubPayments = isnull(v.payamount,0), --@sp,
				q.SubBacklog = isnull(v.backlog,0) , -- @sb,
				q.AP = isnull(v.ap,0) + isnull(v.incomplete,0) + isnull(v.inprocess,0) + isnull(v.pwp,0), --@ap,
				q.PendingSubCO = isnull(v.pendingsco,0) + isnull(v.incPWALogs,0)
		from #qProjects  q
		left join ( Select projectid, isnull(sum(approvedcontract),0) as approvedcontract, 
							isnull(sum(payamount),0) as payamount,
							isnull(sum(backlog),0) as backlog,
							isnull(sum(ap),0) as ap,
							isnull(sum(Incomplete),0) as incomplete,
							isnull(sum(InProcess),0) as inprocess,
							isnull(sum(incPWALogs),0) as incPWALogs,
							isnull(sum(PendingSCO),0) as pendingsco,
							isnull(sum(PWP),0) as PWP
			from viewVendorListFiguresByProject where ProjectID = @projectid group by projectid) v on v.ProjectID = q.pid
		where pid = @projectid

		

		update #qProjects set Processed = 1 where pid = @projectid
	end
	
	select * from #qProjects
	--where pid = 893
END
--exec dbo.ProjectAccounting


select * from tblSubPayApp where   PWALogID = 5901

select * from tblPWALog where projectid = 1102

select * from tblProject where projectnum = 'c18-0043'

GO

