-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec dbo.CostToCompleteProc 1135
/*
	Total Contact Amount / 100
	* .045
	* # mths 
*/


-- exec [dbo].[CostToCompleteProc] 1196, 1
CREATE PROCEDURE [dbo].[CostToCompleteProc]
	@projectid int = 1196,
	@insTbl int = 0
AS
BEGIN
	
	SET NOCOUNT ON;

		declare @pwalogid int = 0
		declare @entityid int = 0

IF OBJECT_ID('tempdb..#tmpResults') IS NOT NULL DROP TABLE #tmpResults
IF OBJECT_ID('tempdb..#tmpMiscItems') IS NOT NULL DROP TABLE #tmpMiscItems
IF OBJECT_ID('tempdb..#tmpChangeOrders') IS NOT NULL DROP TABLE #tmpChangeOrders
IF OBJECT_ID('tempdb..#tmpExpense') IS NOT NULL DROP TABLE #tmpExpense

if not exists(select budgetid from tblBudget where MasterConstDivCodeID in (82,190) and projectid = @projectid)
begin
	Insert into tblBudget (ProjectID, MasterConstDivCodeID, BaseBudgetAmount)
	Select @projectid, 82, 0
end

declare @glrate float = (Select top 1 GL_RATE from WebLookup.miscsettings order by id desc)
declare @superrate float = (Select top 1 Super_RATE from WebLookup.miscsettings order by id desc)
declare @pmrate float = (Select top 1 PM_RATE from WebLookup.miscsettings order by id desc)
declare @buildersRisk float = (Select top 1 builders_risk from WebLookup.miscsettings order by id desc)

declare @startDate datetime = (select MilestoneDate from tblMilestone where projectid = @projectid and MilestoneId = 2)
declare @endDate1 datetime = (select MilestoneDate from tblMilestone where projectid = @projectid and MilestoneId = 5)
declare @endDate2 datetime = (Select MilestoneDate from tblMilestone where MilestoneId = 4 and ProjectId = @ProjectID)
declare @endDate datetime = coalesce(@enddate1, @enddate2, getdate())


select (select sum(invoicegross) * @glrate from tblInvoice where projectid = @projectid and status != 'Void') as GLInsurance,
	(select sum(hours) * @superrate from TimeSheet.TimeSheetDetails where ReferenceID = @projectid and status = 1 and TimesheetID in (Select timesheetid from TimeSheet.Timesheet where entityid in      ((select entityid from project.ProjectEntity s where isnull(complete,0) = 0 and projectid = @projectid and CompanyEntityID in (25,464) and (onsite = 1 or ProjectEntityType = 125) )) )) as SupSalary,
	(select sum(hours) * @pmrate  from TimeSheet.TimeSheetDetails where ReferenceID = @projectid and status = 1 and TimesheetID in (Select timesheetid from TimeSheet.Timesheet where entityid in ((select top 1 entityid from project.ProjectEntity s where isnull(complete,0) = 0 and  projectid = @projectid and CompanyEntityID in (25,464) and (PM = 1 or ProjectEntityType = 124)  )) )) as PMSalary,
	DATEDIFF(MONTH, @startDate, @endDate) as NumMonths,
	cast(0.01 as float) as builders_risk
into #tmpMiscItems


select case when isnull(d.MasterConstDivCodeID,0) = 0 then 142 else d.MasterConstDivCodeID end as MasterConstDivCodeID, cast(sum(d.Qty * d.UnitPrice) as float) as chgamt
into #tmpChangeOrders
from tblChangeOrder c
join tblChangeOrderDetail d on d.ChangeOrderID = c.ChangeOrderID 
where c.projectid = @projectid
and c.BillingStatus like '%Approved%'
and isnull(d.Qty,0) != 0
and isnull(d.unitprice,0) != 0
group by case when isnull(d.MasterConstDivCodeID,0) = 0 then 142 else d.MasterConstDivCodeID end

declare @totalContractAmt float = isnull((Select cima_bid from tblProject where projectid = @projectid),0) + isnull((select sum(chgamt) from #tmpChangeOrders),0)

update #tmpMiscItems set builders_risk = (((@totalContractAmt / 100) * 0.045) * NumMonths)

select CodeID, sum(CCAmount) as ttlAmount
into #tmpExpense
from tblExpense e
where ProjectID = @projectid
group by codeid

select b.projectid, c.acctitemdescription, d.divisioncode, d.divisiondescription, c.constructiondivcode, sum(b.basebudgetamount) as basebudgetamount, cost.itemtotalprice,
			isnull(haveCost,0) as havecost,
			isnull(c.acctitemdescription,'') + ' ' + isnull( d.divisiondescription,'') as searchfield,
			c.codeid,
			sum(isnull(b.costtocomplete,0)) as costtocomplete,
			isnull(c.allowbudgetremove,1) as allowbudgetremove,
			budgetid
		into #tmpResults
		from tblBudget b
		join tblConstDivCodes c on c.CodeID = b.MasterConstDivCodeID
		join tblConstDiv d on d.DivisionID = c.DivisionID
		left join (select sum(dc.itemunitprice * dc.itemquantity) as itemtotalprice, dc.codeid
					from tblPWALog p
					join tblPWADetailCost dc on dc.PWALogID = p.PWALogID and isnull(dc.status,1) = 1
					where p.projectid = @projectid and p.isDeleted = 'N'
					group by dc.codeid) cost on isnull(cost.codeid,0) = c.CodeID
		left join (select distinct case when p.pwalogid is not null then 1 else 0 end as haveCost, c.codeid, dc.codeid as codeid2
					from tblPWALog p
					join tblPWADetailCost dc on dc.PWALogID = p.PWALogID  and dc.status = 1
					left join tblConstDivCodes c on c.CodeID = dc.codeid
					where p.projectid = @projectid and p.isdeleted = 'N'
					and p.pwalogid = @pwalogid
					and p.entityid = @entityid) inCost on isnull(inCost.codeid2,0) = c.codeid
		where b.ProjectID = @projectid
		group by b.projectid, c.acctitemdescription, d.divisioncode, d.divisiondescription, c.constructiondivcode, cost.itemtotalprice, isnull(haveCost,0), c.codeid,
			isnull(c.allowbudgetremove,1), budgetid
		
		/* This will update line items based on what was pulled from the Misc Items */
		-- 67	Project Management Salary Gen. Cond.
		-- 68	Superintendent Salary Gen. Cond.
		-- 156	General Liability Insurance Procurement

		
		
		
		declare @PMSal money = 0
		if @startDate is not null 
		begin
			set @PMSal = (select isnull(DATEDIFF(D, @startDate, @endDate),0) * 115	)
		end

		update #tmpResults set itemtotalprice = isnull(itemtotalprice,0) + isnull(@PMSal,0) where CodeID = 67
		update #tmpResults set itemtotalprice = isnull(itemtotalprice,0) + isnull((select supsalary from #tmpMiscItems),0) where CodeID = 68
		update #tmpResults set itemtotalprice = isnull(itemtotalprice,0) + isnull((select GLInsurance from #tmpMiscItems),0) where CodeID = 156
		update #tmpResults set itemtotalprice = isnull(itemtotalprice,0) + isnull((select builders_risk from #tmpMiscItems),0) where CodeID in (73, 158)

		

--		exec dbo.CostToCompleteProc 1215
		update z
		set z.basebudgetamount = isnull(z.basebudgetamount,0) + isnull(c.chgamt,0)
		from #tmpResults z
		join #tmpChangeOrders c on c.MasterConstDivCodeID = z.CodeID

		update z
		set z.basebudgetamount = isnull(z.itemtotalprice,0) + isnull(e.ttlAmount,0)
		from #tmpResults z
		join #tmpExpense e on e.CodeID = z.CodeID

		if @insTbl = 0
		begin
			select t.projectid, t.acctitemdescription,t.divisioncode,t.divisiondescription,t.constructiondivcode,t.basebudgetamount,t.itemtotalprice,t.havecost,t.searchfield,t.codeid,t.costtocomplete,t.allowbudgetremove,t.budgetid,
				case when zzc.CodeID is not null then 0 else isnull(basebudgetamount,0) - isnull(itemtotalprice,0) end as availableamount,
				case when t.allowbudgetremove = 0 then 0
					when isnull(basebudgetamount,0) - isnull(itemtotalprice,0) > 0 then 1 
					when t.codeid = 142 then 1 
					else 0 
					end as availableMoney,
					0 as moveAmount
			from #tmpResults t
				left join tblConstDivCodes zzc on zzc.CodeID = t.CodeID and zzc.CTCAvailableZero = 1
			order by 
			case when t.codeid = 142 then 0 else 1 end, t.constructiondivcode
		end
		else
		begin
			Insert into ProviewTemp.dbo.tblBudgetTemp ([projectid],[acctitemdescription],[divisioncode],[divisiondescription],[constructiondivcode]
														,[basebudgetamount]      ,[itemtotalprice]      ,[havecost]      ,[searchfield]      ,[codeid]
														,[costtocomplete]      ,[allowbudgetremove]      ,[budgetid]      ,[availableamount]      ,[availableMoney]      ,[moveAmount])
			select t.projectid, t.acctitemdescription,t.divisioncode,t.divisiondescription,t.constructiondivcode,t.basebudgetamount,t.itemtotalprice,t.havecost,t.searchfield,t.codeid,t.costtocomplete,t.allowbudgetremove,t.budgetid,
				case when zzc.CodeID is not null then 0 else isnull(basebudgetamount,0) - isnull(itemtotalprice,0) end as availableamount,
				case when t.allowbudgetremove = 0 then 0
					when isnull(basebudgetamount,0) - isnull(itemtotalprice,0) > 0 then 1 
					when t.codeid = 142 then 1 
					else 0 
					end as availableMoney,
					0 as moveAmount
			from #tmpResults t
			left join tblConstDivCodes zzc on zzc.CodeID = t.CodeID and zzc.CTCAvailableZero = 1
			order by 
			case when t.codeid = 142 then 0 else 1 end, t.constructiondivcode
		end
		

		
		-- alter table proviewtemp.dbo.tblBudgetTemp add itemtotalprice
		
END

GO

