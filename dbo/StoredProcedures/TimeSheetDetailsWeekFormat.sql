-- exec TimeSheetDetailsWeekFormat 1472
CREATE PROCEDURE [dbo].[TimeSheetDetailsWeekFormat]
	@TimeSheetID int
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @weekday int = (	select DATEPART (dw,getdate()))

    IF OBJECT_ID('tempdb..#tmpTimeSheet') IS NOT NULL DROP TABLE #tmpTimeSheet
	IF OBJECT_ID('tempdb..#tmpTimeSheetDetails') IS NOT NULL DROP TABLE #tmpTimeSheetDetails

	if not exists (Select timesheetid from TimeSheet.TimeSheetDetails where TimesheetID = @TimeSheetID)
	begin
		Insert into TimeSheet.TimeSheetDetails (TimesheetID, ReferenceID, ReferenceType, Task, Comments, Hours, AddID, AddDate, status, RowLink, WkDay)
		Select @TimeSheetID, -1, 2, 10, 'General Office', 0, 0, getdate(), 1, 1, 1
	end

	declare @timesheetstatus int = (Select Status from TimeSheet.Timesheet where TimeSheetID = @TimeSheetID)
	declare @timesheetstatusdesc varchar(100) = ''

	if  @timesheetstatus = 0 set @timesheetstatusdesc = 'Deleted'
	if  @timesheetstatus = 1 set @timesheetstatusdesc = 'Open'
	if  @timesheetstatus = 2 set @timesheetstatusdesc = 'Submitted - No Changes'
	if  @timesheetstatus = 3 set @timesheetstatusdesc = 'Approved - No Changes'
	if  @timesheetstatus = 4 set @timesheetstatusdesc = 'Payroll Processed - No Changes'



	create table #tmpTimeSheet (ReferenceID int, ReferenceType int, ReferenceName1 varchar(1000), ReferenceName2 varchar(1000),
					Sun float, Mon float, Tues float, Wed float, Thurs float, Fri float, Sat float, weekTotal float,
					TaskID int, TaskComments varchar(1000), RowLink int, StartDate datetime, taskdesc varchar(100)
					)
					
	Insert into #tmpTimeSheet (ReferenceID, ReferenceType, TaskID, TaskComments, Sun, Mon, Tues, Wed, Thurs, Fri, Sat, RowLink, StartDate
								)
	select distinct ReferenceID, ReferenceType, isnull(Task,0), Comments, 0, 0, 0, 0, 0, 0, 0, RowLink, (Select StartDate from TimeSheet.TimeSheet where TimesheetID = @TimeSheetID)
	from TimeSheet.TimeSheetDetails 
	where TimesheetID = @TimeSheetID and Status = 1

	--select * from #tmpTimeSheet

	Select t.TimeSheetID, t.EntityID, t.AddDate, t.AddID, t.Status, d.ReferenceID,
			d.ReferenceType, d.dDate, isnull(d.Task,0) as Task, ltrim(rtrim(d.Comments)) as Comments, sum(d.Hours) as Hours, t.StartDate,
			datename(dw, ddate) as DayOfWeekNum, d.RowLink, ROW_NUMBER() OVER(ORDER BY t.timesheetid ASC) AS rownum
		into #tmpTimeSheetDetails
		from timesheet.TimeSheet t
		left join timesheet.TimeSheetDetails d on d.TimesheetID = t.TimeSheetID and d.Status = 1
		where t.TimeSheetID = @TimeSheetID
		group by t.TimeSheetID, t.EntityID, t.AddDate, t.AddID, t.Status, d.ReferenceID,
			d.ReferenceType, d.dDate, d.Task, ltrim(rtrim(d.Comments)), d.Hours, t.StartDate, datename(dw, d.dDate), d.RowLink
	--select * from #tmpTimeSheetDetails
	
	
	alter table #tmpTimeSheetDetails add Processed int 

	Update #tmpTimeSheetDetails set Processed = 0

	--select * from #tmpTimeSheetDetails

	while exists (select top 1 * from #tmpTimeSheetDetails where processed = 0)
	begin
		declare @row int = (select top 1 rownum from #tmpTimeSheetDetails where processed = 0)
		declare @rowlink int = (select top 1 RowLink from #tmpTimeSheetDetails where rownum = @row)
		declare @dw varchar(100) = (select top 1 DayOfWeekNum from #tmpTimeSheetDetails where rownum = @row)
		declare @task int = (select top 1 Task from #tmpTimeSheetDetails where rownum = @row)
		declare @comments varchar(1000) = (select top 1 Comments from #tmpTimeSheetDetails where rownum = @row)
		declare @hours float = (select top 1 Hours from #tmpTimeSheetDetails where rownum = @row)
		declare @referenceid int = (select top 1 ReferenceID from #tmpTimeSheetDetails where rownum = @row)
		declare @referencetype int = (select top 1 ReferenceType from #tmpTimeSheetDetails where rownum = @row)
		print @dw
		if @dw = 'Sunday'
			begin
				Update #tmpTimeSheet set Sun = Sun + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Monday'
			begin
				Update #tmpTimeSheet set Mon = Mon + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Tuesday'
			begin
				Update #tmpTimeSheet set Tues = Tues + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Wednesday'
			begin
				Update #tmpTimeSheet set Wed = Wed + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Thursday'
			begin
				Update #tmpTimeSheet set Thurs = Thurs + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Friday'
			begin
				Update #tmpTimeSheet set Fri = Fri + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end
		if @dw = 'Saturday'
			begin
				Update #tmpTimeSheet set Sat = Sat + @hours 
				where TaskID = @task
				and TaskComments = @comments
				and ReferenceID = @referenceid
				and ReferenceType = @referencetype
				and RowLink = @rowlink
			end



		update #tmpTimeSheetDetails set Processed = 1 where rownum = @row
	end

	update #tmpTimeSheet set weekTotal = sun + mon + tues + wed + thurs + fri + sat

	

	update t
		set t.taskdesc = l.ActivityCode
	from #tmpTimeSheet t
	join tlkpActivity l on l.ActivityID = t.TaskID

	update #tmpTimeSheet set ReferenceName1 = 'Overhead', ReferenceName2 = '' where ReferenceID = -1

	update z set 
		z.ReferenceName1 = p.projectname,
		z.ReferenceName2 = p.ProjectNum
	from #tmpTimeSheet z 
	join tblproject p on p.ProjectID = z.ReferenceID

	select t.*, p.ProjectNum + ' ' + p.ProjectName as projectdesc, 0 as totalHours, DATEADD(DAY,6,StartDate) as EndDate,
		@timesheetstatus as timesheetstatusid, @timesheetstatusdesc as timesheetstatusdesc,
		case when t.ReferenceID = -1 then 'Overhead' else p.OurCompany end as OurCompany
	from #tmpTimeSheet t 
	left join tblProject p on p.projectid = t.ReferenceID
	order by RowLink
END


--select * from TimeSheet.TimeSheetDetailsStartStop

GO

