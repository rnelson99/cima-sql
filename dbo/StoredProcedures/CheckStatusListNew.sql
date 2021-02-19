-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CheckStatusListNew]
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


		select *
		into #results
		from dbo.viewPWALogProjectEntity

		/*
			
			--Approved
			declare @pwaCurrent float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (5,7) and entityid = @EntityID and projectid = @ProjectID)
			--Pending
			declare @pwaPending float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (1,2,3,4) and entityid = @EntityID and projectid = @ProjectID)
			--Rejected
			declare @pwaRejected float = (select isnull(sum(pwalogamount),0) from #results where pwastatusid in (6) and entityid = @EntityID and projectid = @ProjectID)
		*/
		Select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, 
					wp.workPerformed as workperformed, s.SubPayAppId, s.AppType, s.AppStatus, s.SubPayAppSequence, s.VendorInvoiceNo, 
					isnull(s.Approver1,0) as Approver1, isnull(s.Approver2,0) as Approver2, s.Approver1DateTime, s.Approver2DateTime, isnull(s.OnHold,0) as OnHold, 
					s.onHoldTill, isnull(s.approveStatus,99) as approveStatus,
					case when isnull(s.approveStatus,99) = 99 then 'TBD' when isnull(s.approveStatus,99) = 1 then 'Approved' when isnull(s.approveStatus,99) = 2 then 'Hold'
						when isnull(s.approveStatus,99) = 3 then 'Void' else 'Unknown Status' end as approveStatusDesc,
						p.projectname, p.projectnum, p.projectshortname,
						isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
						s.approvalComments,
						0 as JointCheck, 
							0 as additionalamount, '' as additionalchecknumber,
							0 as addtApprover1, 0 as addtOnHold, null as addOnHoldTill,
							'' as addtApprovalComments, 
							isnull(s.SubPayAmount,0) as checkAmount, s.CheckNumber, '' as supplier, 0 as supplierentityid,
							s.checkStatus, 0 as processed, ROW_NUMBER() OVER(ORDER BY l.pwalogid ASC) AS RowNum,
							0 as detailid,
			isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
			isnull(ttl.PWALogAmount,0) as PWALogAmountTotal,
			isnull(approved.PWALogAmount,0) as PWALogAmountTotalApproved,
			isnull(pending.PWALogAmount,0) as PWALogAmountTotalPending,
			isnull(rejected.PWALogAmount,0) as PWALogAmountTotalRejected,
			isnull(subPayApp.SubPayAmount,0) SubPayAmount,
			isnull(ttl.pwalogamount,0) - isnull(subPayApp.SubPayAmount,0) as remaining,
			isnull(isnull(ttl.pwalogamount,0) - isnull(subPayApp.SubPayAmount,0),0) / ttl.pwalogamount as remainper,
			isnull(inprocess.inProcessSubPay,0) as inProcessSubPay
		from tblSubPayApp s
		join tblPWALog l on l.PWALogID = s.PWALogID
		join tblProject p on p.projectid = l.ProjectID
		join Contacts.Entity e on e.EntityID = l.EntityID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID not in (6) group by EntityID, projectid) ttl on ttl.EntityID = e.EntityID and ttl.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (5,7) group by EntityID, projectid) approved on approved.EntityID = e.EntityID and approved.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (1,2,3,4) group by EntityID, projectid) pending on pending.EntityID = e.EntityID and pending.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (6) group by EntityID, projectid) rejected on rejected.EntityID = e.EntityID and rejected.ProjectID = l.ProjectID
		LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = l.ProjectID
		left join (select l.ProjectID, l.EntityID, sum(isnull(s.SubPayAmount,0) + isnull(addtl.amtTtl,0)) as SubPayAmount
					from tblSubPayApp s
					join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' --and l.ProjectID = @projectID
					join Contacts.Entity e on e.EntityID = l.EntityID
					join tvalPWAStatus ss on ss.PWAStatusID = l.PWAStatusID
					left join (select sum(amountdue) as amtTtl, subpayappid from tblSubPayAppDetail where AmountDue is not null group by subpayappid) as addtl on addtl.subpayappid = s.subpayappid
					where s.IsDeleted = 'N' group by l.projectid, l.entityid) subPayApp on subPayApp.EntityID = e.EntityID and subPayApp.ProjectID = l.ProjectID
		left join (select sum(isnull(s.SubPayAmount,0)) as inProcessSubPay, l.ProjectID, l.EntityID
			from tblSubPayApp s
			join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' --and l.ProjectID = @projectID and l.EntityID = @EntityID
			where s.IsDeleted = 'N'
			and (
					s.AppStatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
						or
					s.checkstatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
				)
			group by l.ProjectID, l.EntityID
			) as inProcess on inProcess.ProjectID = p.ProjectID and inProcess.EntityID = e.EntityID
		where s.CheckStatus in ('Check Printed', 'Check Picked Up', 'Sent to Sub')
		and s.IsDeleted = 'N'
		
		union  

		Select l.PWALogID, l.ProjectID, e.EntityID, e.LastName, e.FirstName, 
					wp.workPerformed as workperformed, s.SubPayAppId, s.AppType, s.AppStatus, s.SubPayAppSequence, s.VendorInvoiceNo, 
					isnull(s.Approver1,0) as Approver1, isnull(s.Approver2,0) as Approver2, s.Approver1DateTime, s.Approver2DateTime, isnull(s.OnHold,0) as OnHold, 
					s.onHoldTill, isnull(s.approveStatus,99) as approveStatus,
					case when isnull(s.approveStatus,99) = 99 then 'TBD' when isnull(s.approveStatus,99) = 1 then 'Approved' when isnull(s.approveStatus,99) = 2 then 'Hold'
						when isnull(s.approveStatus,99) = 3 then 'Void' else 'Unknown Status' end as approveStatusDesc,
						p.projectname, p.projectnum, p.projectshortname,
						isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
						s.approvalComments,
						d.JointCheck as JointCheck, 
							d.AmountDue as additionalamount, d.CheckNumber as additionalchecknumber,
							0 as addtApprover1, 0 as addtOnHold, null as addOnHoldTill,
							'' as addtApprovalComments, 
							isnull(d.AmountDue,0) as checkAmount, d.CheckNumber, sup.LastName as supplier, sup.EntityID as supplierentityid,
									d.checkStatus, 0 as processed, ROW_NUMBER() OVER(ORDER BY l.pwalogid ASC) + 100000 AS RowNum,
									d.id as detailid,
			isnull((select attributeid from Contacts.Attributes where attributetype = 'VendorStopPay' and status = 1 and attribute = '1' and entityid = e.EntityID),0) as VendorStopPay,
			isnull(ttl.PWALogAmount,0) as PWALogAmountTotal,
			isnull(approved.PWALogAmount,0) as PWALogAmountTotalApproved,
			isnull(pending.PWALogAmount,0) as PWALogAmountTotalPending,
			isnull(rejected.PWALogAmount,0) as PWALogAmountTotalRejected,
			isnull(subPayApp.SubPayAmount,0) SubPayAmount,
			isnull(ttl.pwalogamount,0) - isnull(subPayApp.SubPayAmount,0) as remaining,
			isnull(isnull(ttl.pwalogamount,0) - isnull(subPayApp.SubPayAmount,0),0) / ttl.pwalogamount as remainper,
			isnull(inprocess.inProcessSubPay,0) as inProcessSubPay
		from tblSubPayAppDetail d
		left join Contacts.Entity sup on sup.EntityID = d.SupplierEntityID
		join tblSubPayApp s on s.SubPayAppId = d.SubPayAppId and s.IsDeleted = 'N'
		join tblPWALog l on l.PWALogID = s.PWALogID
		join tblProject p on p.projectid = l.ProjectID
		join Contacts.Entity e on e.EntityID = l.EntityID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID not in (6) group by EntityID, projectid) ttl on ttl.EntityID = e.EntityID and ttl.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (5,7) group by EntityID, projectid) approved on approved.EntityID = e.EntityID and approved.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (1,2,3,4) group by EntityID, projectid) pending on pending.EntityID = e.EntityID and pending.ProjectID = l.ProjectID
		left join (Select sum(pwalogamount) as pwalogamount, EntityID, projectid from dbo.viewPWALogProjectEntity where PWAStatusID in (6) group by EntityID, projectid) rejected on rejected.EntityID = e.EntityID and rejected.ProjectID = l.ProjectID
		LEFT JOIN project.CompanyWorkPerformed wp on wp.entityid = e.entityid and wp.projectid = l.ProjectID
		left join (select l.ProjectID, l.EntityID, sum(isnull(s.SubPayAmount,0) + isnull(addtl.amtTtl,0)) as SubPayAmount
					from tblSubPayApp s
					join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' --and l.ProjectID = @projectID
					join Contacts.Entity e on e.EntityID = l.EntityID
					join tvalPWAStatus ss on ss.PWAStatusID = l.PWAStatusID
					left join (select sum(amountdue) as amtTtl, subpayappid from tblSubPayAppDetail where AmountDue is not null group by subpayappid) as addtl on addtl.subpayappid = s.subpayappid
					where s.IsDeleted = 'N' group by l.projectid, l.entityid) subPayApp on subPayApp.EntityID = e.EntityID and subPayApp.ProjectID = l.ProjectID
		left join (select sum(isnull(s.SubPayAmount,0)) as inProcessSubPay, l.ProjectID, l.EntityID
			from tblSubPayApp s
			join tblPWALog l on l.PWALogID = s.PWALogID and l.IsDeleted = 'N' --and l.ProjectID = @projectID and l.EntityID = @EntityID
			where s.IsDeleted = 'N'
			and (
					s.AppStatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
						or
					s.checkstatus in ('Ready to Pay','Sent to Sub','Pay When Paid','Approved by PM','Complete-Acct')
				)
			group by l.ProjectID, l.EntityID
			) as inProcess on inProcess.ProjectID = p.ProjectID and inProcess.EntityID = e.EntityID
		where d.CheckStatus in ('Check Printed', 'Check Picked Up', 'Sent to Sub')
		

		--select * from #TempTable

		
--		Select * from tblSubPayApp
		
END

/*
exec  dbo.CheckStatusListNew
*/

GO

