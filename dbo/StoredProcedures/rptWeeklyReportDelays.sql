/*
	Chris Hubbard
	Jan 2020
	Added this query to pull in the delays for the weekly report print version.  
	THis might get included in the Weekly REport Detail screen to show what will print. 
*/
-- exec dbo.rptWeeklyReportDelays 1257, 84

CREATE PROCEDURE [dbo].[rptWeeklyReportDelays]
	@projectid int,
	@weeklyreportid int
	
AS
BEGIN
	SET NOCOUNT ON;
	-- declare @projectid int = 1247
	-- declare @weeklyreportid int = 87

	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

	select 
	r.WeeklyReportId, 
	c.Comment,
	r.dtWeek as startDate,
	r.dtWeek as endDate,
	1 as CommentID, ROW_NUMBER() over (order by r.weeklyreportid) as rowNum, 1 as grp,
	0 as delaytype, c.comment as delaycomment

	into #Results
	from project.ProjectWeeklyReport r
	join project.WeeklyReportComment c  
	on c.WeeklyReportID = r.WeeklyReportID and c.status = 1
	where r.WeeklyReportID = @weeklyreportid
	and r.ProjectID = @projectid

	union 
	select r.WeeklyReportID,
	case when isnull(d.delaytype,1) = 1 then 'Full Delay: ' + d.Summary when d.delaytype = 2 then 'Partial Delay: ' + d.Summary else 'Full Delay: ' + d.summary end as comment2,
	d.startDate, d.endDate,
	1 as CommentID, ROW_NUMBER() over (order by r.weeklyreportid) as rowNum, 2,
	isnull(d.delayType,1), d.Summary
	from project.ProjectWeeklyReport r
	join project.Delays d on d.projectid = r.ProjectID and d.ownerVisible = 1 and d.status = 1 and (
		(d.startDate >= r.dtWeek 
		and 
		d.startDate <= r.dtWeek + 6
		)
		or
		(
			d.endDate is null
		)
		or
		(
			d.endDate >= r.dtWeek
		
		)
	)
	where r.projectid = @projectid
	and r.WeeklyReportID = @weeklyreportid


	union 
	select @weeklyreportid, case when w.BadWeather = 2 then 'Partial Delay: ' + cast(cast(r.dDate as date) as varchar(100)) + ' Bad Weather Day ' + isnull(w.badweatherreason,'') else 'Partial Delay: ' + cast(cast(r.dDate as date) as varchar(100)) + ' Bad Weather Day ' + isnull(w.badweatherreason,'') end as comment3,
	r.dDate, r.dDate,
	1 as CommentID, ROW_NUMBER() over (order by r.ddate) as rowNum, 3,
	w.BadWeather, case when trim(isnull(w.badweatherreason,'')) = '' then 'Bad Weather Day' else isnull(w.badweatherreason,'') end  
	from project.DailyReportWeather w
	join project.ProjectDailyReport r on r.DailyReportID = w.DailyReportID and r.Status > 0 and r.ProjectID = @projectid
	where 1=1
	and w.Status > 0
	and r.dDate >= (select dtWeek from project.ProjectWeeklyReport where WeeklyReportID = @weeklyreportid)
	and r.dDate <= (select dtWeek + 6 from project.ProjectWeeklyReport where WeeklyReportID = @weeklyreportid)
	and w.BadWeather > 0


	declare @dtDate date = (select cast(dtWeek as date) from project.ProjectWeeklyReport where WeeklyReportID = @weeklyreportid)
	declare @dtDate2 date = dateadd("D",6,@dtDate)

	-- select @dtDate, @dtDate2

	-- exec dbo.rptWeeklyReportDelays 1257, 84
	-- select * from #Results
	
	alter table #Results add Processed int 
	update #Results set Processed = 0

	while exists (Select top 1 commentid from #Results where Processed = 0)
	begin
		declare @grp int = (Select top 1 grp from #Results where Processed = 0)
		declare @row int = (Select top 1 rownum from #Results where Processed = 0 and grp = @grp)
		declare @startDate date = (Select top 1 cast(startDate as date) from #Results where grp = @grp and rowNum = @row)
		declare @endDate date = (Select top 1 cast(endDate as date) from #Results where grp = @grp and rowNum = @row)
		declare @delaycomment varchar(1000) = (Select top 1 delaycomment from #Results where grp = @grp and rowNum = @row)
		declare @delayType int = (Select top 1 delaytype from #Results where grp = @grp and rowNum = @row)
		if @startDate < @dtDate set @startDate = @dtDate
		if @endDate > @dtDate2 set @endDate = @dtDate2
		declare @comment varchar(1000) = '';

		declare @delayString varchar(1000) = 'Full Delay ('
		if @delayType = 2 set @delayString = 'Partial Delay ('

		if @delayType in (1,2)
		begin
			if @startDate != @endDate
			begin
				if @endDate is null
				begin
					set @comment = @delayString + ' ongoing)'
				end
				else
				begin
					set @comment = @delayString + cast(format(@startDate, 'MMM-dd') as varchar(100)) + '-' + cast(format(@endDate, 'MMM-dd') as varchar(100)) + ')'
				end
			end
			else 
			begin
				if @endDate is null
				begin
					set @comment = @delayString + ' ongoing)'
				end
				else
				begin
					set @comment = @delayString + cast(format(@startDate, 'MMM-dd') as varchar(100)) + ')'
				end
			end
		end
		if @comment != ''
		begin
		set @comment = @comment + ': ' + @delaycomment
		end
		else 
		begin
			set @comment = @delaycomment
		end
		update #Results set Processed = 1, comment = @comment where grp = @grp and rowNum = @row
	end
	
	-- exec dbo.rptWeeklyReportDelays 1247, 87

	delete from #Results 
	where startDate > @dtDate2

	select CommentID, cast(comment as varchar(1000)) as Comment, startDate, endDate, @dtDate as weeklyDateStart, @dtDate2 as weeklyDateEnd
	from #Results 
	order by startDate, endDate
	-- where startDate > @dtDate2



END

GO

