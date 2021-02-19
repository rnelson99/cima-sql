-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckStatusList]
	--	exec dbo.CheckStatusList
AS
BEGIN
	SET NOCOUNT ON;

		
		update tblSubPayApp 
		set checkstatus = appstatus 
		
		Update d
			set d.SupplierEntityID = e.EntityID
		from tblSubPayAppDetail d
		join Contacts.Entity e on e.LegacyID = d.SupplierID and e.LegacyTable = 'tblVendor' 
		where d.SupplierEntityID is null

		update d
		set d.checkstatus = s.checkstatus
		from tblSubPayAppDetail d
		join tblSubPayApp s on s.SubPayAppId = d.SubPayAppId
		where d.checkstatus is null 

		update d
		set d.checkstatus = s.checkstatus
		from tblSubPayAppDetail d
		join tblSubPayApp s on s.SubPayAppId = d.SubPayAppId
		where d.checkStatus not in ('Check Printed', 'Check Picked Up', 'Sent to Sub', 'Paid')

		Select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, 
					wp.workPerformed as workperformed, s.SubPayAppId, s.AppType, s.AppStatus, s.SubPayAppSequence, s.VendorInvoiceNo, 
					isnull(s.Approver1,0) as Approver1, isnull(s.Approver2,0) as Approver2, s.Approver1DateTime, s.Approver2DateTime, isnull(s.OnHold,0) as OnHold, 
					s.onHoldTill, isnull(s.approveStatus,99) as approveStatus,
					case when isnull(s.approveStatus,99) = 99 then 'TBD' when isnull(s.approveStatus,99) = 1 then 'Approved' when isnull(s.approveStatus,99) = 2 then 'Hold'
						when isnull(s.approveStatus,99) = 3 then 'Void' else 'Unknown Status' end as approveStatusDesc,
						pp.projectname, pp.projectnum, pp.projectshortname,
						isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
						s.approvalComments,
						0 as JointCheck, 
							0 as additionalamount, '' as additionalchecknumber,
							0 as addtApprover1, 0 as addtOnHold, null as addOnHoldTill,
							'' as addtApprovalComments, 
							isnull(s.SubPayAmount,0) as checkAmount, s.CheckNumber, '' as supplier, 0 as supplierentityid,
							s.checkStatus, 0 as processed, ROW_NUMBER() OVER(ORDER BY l.pwalogid ASC) AS RowNum,
							0 as detailid
				Into #TempTable
				from tblSubPayApp s
				join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N'
				join tblProject pp on pp.projectid = l.projectid
				join Contacts.Entity e on e.EntityID = l.EntityID
				join tvalPWAStatus ss on ss.PWAStatusID = l.PWAStatusID
				LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = pp.ProjectID
				where s.checkStatus in ('Check Printed', 'Check Picked Up', 'Sent to Sub') and s.IsDeleted = 'N'

				union 
				select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, 
							wp.workPerformed as workperformed, s.SubPayAppId, s.AppType, s.AppStatus, s.SubPayAppSequence, s.VendorInvoiceNo, 
							isnull(s.Approver1,0) as Approver1, isnull(s.Approver2,0) as Approver2, s.Approver1DateTime, s.Approver2DateTime, isnull(s.OnHold,0) as OnHold, 
							s.onHoldTill, isnull(s.approveStatus,99) as approveStatus,
							case when isnull(s.approveStatus,99) = 99 then 'TBD' when isnull(s.approveStatus,99) = 1 then 'Approved' when isnull(s.approveStatus,99) = 2 then 'Hold'
								when isnull(s.approveStatus,99) = 3 then 'Void' else 'Unknown Status' end as approveStatusDesc,
								pp.projectname, pp.projectnum, pp.projectshortname,
								isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
								s.approvalComments,
								0 as JointCheck, 
									0 as additionalamount, '' as additionalchecknumber,
									0 as addtApprover1, 0 as addtOnHold, null as addOnHoldTill,
									'' as addtApprovalComments, 
									isnull(d.AmountDue,0) as checkAmount, d.CheckNumber, sup.LastName as supplier, sup.EntityID as supplierentityid,
									d.checkStatus, 0 as processed, ROW_NUMBER() OVER(ORDER BY l.pwalogid ASC) + 100000 AS RowNum,
									d.id as detailid
				from tblSubPayAppDetail d
				join tblSubPayApp s on s.SubPayAppId = d.SubPayAppId and s.IsDeleted = 'N'
				join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N'
				join tblProject pp on pp.projectid = l.projectid
				join Contacts.Entity e on e.EntityID = l.EntityID
				left join Contacts.Entity sup on sup.EntityID = d.SupplierEntityID
				join tvalPWAStatus ss on ss.PWAStatusID = l.PWAStatusID
				LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = pp.ProjectID
				where d.checkStatus in ('Check Printed', 'Check Picked Up', 'Sent to Sub') and d.SupplierPaidByID = 3
				order by e.LastName, e.FirstName
		
		alter table #TempTable add curr float
		alter table #TempTable add pend float
		alter table #TempTable add inproc float
		alter table #TempTable add remain float
		alter table #TempTable add remainper float

		alter table #TempTable add keepRecord int

		---select * from #TempTable order by rownum
		--select * from tblSubPayAppDetail
		
		delete from #TempTable where ltrim(rtrim(isnull(CheckNumber,''))) = '' 
		
		delete from #TempTable where isnumeric(checknumber) = 0
		
		delete from #TempTable where checknumber < 19640

		select *
		into #results
		from dbo.viewPWALogProjectEntity

		while exists (select top 1 pwalogid from #TempTable where processed = 0)
		begin
			declare @rownum int = (Select top 1 rownum from #TempTable where processed = 0)
			declare @ProjectID int = (Select ProjectID from #TempTable where RowNum = @rownum)
			declare @EntityID int = (Select EntityID from #TempTable where RowNum = @rownum)
			
			declare @paid float = (select sum(s.SubPayAmount)
			from tblSubPayApp s
			join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' and l.ProjectID = @projectID and l.EntityID = @EntityID
			where s.IsDeleted = 'N'
			and (
					s.AppStatus in ('Paid')
						or
					s.checkstatus in ('Paid')
				)
			)
			--Approved
			declare @pwaCurrent float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (5,7) and entityid = @EntityID and projectid = @ProjectID)
			--Pending
			declare @pwaPending float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (1,2,3,4) and entityid = @EntityID and projectid = @ProjectID)
			--Rejected
			declare @pwaRejected float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (6) and entityid = @EntityID and projectid = @ProjectID)
			--InProcess
			declare @InProcess float = (select sum(isnull(s.SubPayAmount,0))
			from tblSubPayApp s
			join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' and l.ProjectID = @projectID and l.EntityID = @EntityID
			where s.IsDeleted = 'N'
			and (
					s.AppStatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
						or
					s.checkstatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
				)
			)

			declare @remain float = @pwaCurrent - @InProcess - @paid
			declare @remainper float = @remain / @pwacurrent
			
			set @pwaCurrent = isnull(@pwaCurrent,0)
			set @pwaPending = isnull(@pwaPending,0)
			set @pwaRejected = isnull(@pwaRejected,0)
			set @InProcess = isnull(@InProcess,0)
			set @remain = isnull(@remain,0)
			set @remainper = isnull(@remainper,0)

			

			update #TempTable set curr = @pwaCurrent, pend = @pwaPending, inproc = @InProcess, remain = @remain, remainper = @remainper, processed = 1
			where RowNum = @rownum	

			
		end
		
		select * from #TempTable

		
		
		
END

/*
exec  dbo.CheckStatusList
*/

GO

