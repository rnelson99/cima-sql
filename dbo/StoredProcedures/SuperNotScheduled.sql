
--exec dbo.SuperNotScheduled
CREATE PROCEDURE [dbo].[SuperNotScheduled]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#tmpTable') IS NOT NULL DROP TABLE #tmpTable
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	;with cte as (select p.projectid, ms.MilestoneDate as StartDate, me1.MilestoneDate EndDate1, me2.MilestoneDate as EndDate2, e.FirstName, e.LastName, p.CIMA_Status, e.EntityID
			from tblProject p
			join tblMilestone mS on p.projectid = ms.ProjectId  and mS.MilestoneId = 2
			join tblMilestone mE1 on p.projectid = me1.ProjectId  and me1.MilestoneId = 4
			join tblMilestone mE2 on p.projectid = me2.ProjectId  and me2.MilestoneId = 5
			left join project.projectentity pe on pe.projectid = p.ProjectID and pe.projectentitytype = 125 and pe.status = 1
			left join Contacts.Entity e on e.entityid = pe.entityid
		where 1=1
			and p.CIMA_Status not in ('Inactive','Complete', 'No Job')
			and p.projectid != 482
		)
		select ROW_NUMBER() OVER(ORDER BY projectid ASC) AS RowNum, EntityID, StartDate, enddate1 as EndDate1, enddate2 as EndDate2, isnull(FirstName,' No Super') as FirstName, LastName, CIMA_Status, 0 as Processeed
		into #tmpTable
		from cte


	select e.EntityID, e.FirstName, e.LastName, d.dt, 0 as scheduled
	into #Results
	from Contacts.Entity e, proviewTemp.dbo.dates d
	where e.status = 1 and e.EntityType = 1
		and LegacyID in (select UserSecurityID from tvalUserSecurity where UserRole like '%super%')
	

		while exists (select top 1 * from #tmpTable where Processeed = 0)
		begin
			declare @rownum int = (select top 1 rownum from #tmpTable where Processeed = 0)
			declare @entityid int = (select top 1 EntityID from #tmpTable where RowNum = @rownum)
			declare @start datetime = (select top 1 StartDate from #tmpTable where RowNum = @rownum)
			declare @end1 datetime = (select top 1 EndDate1 from #tmpTable where RowNum = @rownum)
			declare @end2 datetime = (select top 1 EndDate2 from #tmpTable where RowNum = @rownum)
			declare @end datetime = null
			declare @haveDate int = 1
			if ISDATE(@start) = 0
			begin
				set @havedate = 0 
			end
			if isdate(@end1) = 0 and isdate(@end2) = 0
			begin
				set @havedate = 0 
			end
			if isdate(@end2) = 1 
			begin
				set @end = @end2
			end
			else
			begin
				if isdate(@end1) = 1
				begin
					set @end = @end1
				end
			end
			Update #Results set scheduled = 1 where EntityID = @entityid and dt >= @start and dt <= @end

			Update #tmpTable set Processeed = 1 where RowNum = @rownum
		end


		select * from #Results where scheduled = 0 order by EntityID, dt
END

GO

