create PROCEDURE [dbo].[getTimeSheetStatus]
--exec dbo.gettimesheetstatus 26, '3/17/2017'
	-- Add the parameters for the stored procedure here
	@EntityID int, 
	@PayDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#tmpTable') IS NOT NULL DROP TABLE #tmpTable

	select t.TimeSheetID, t.EntityID, t.StartDate, t.AddDate, t.AddID, t.Status, t.approver1, t.approver2, t.approver1DateTime, t.Approver2DateTime,
	e.FirstName as TimeFirst, e.LastName as TimeLast, 
	p.PeriodStart, p.PeriodEnd, p.PayDate,
		(select isnull(sum(hours),0) as ttlHours
			from TimeSheet.TimeSheetDetails d
			where status = 1 and d.timesheetid = t.timesheetid
			and (Task in (select activityid from tlkpActivity where timegroup = 'Work') or isnull(task,0) = 0)) as WorkHours,
		(select isnull(sum(hours),0) as ttlHours
			from TimeSheet.TimeSheetDetails d
			where status = 1 and d.timesheetid = t.timesheetid
			and (Task in (select activityid from tlkpActivity where timegroup = 'PTO') or isnull(task,0) = -100)) as PTOHours,
		(select isnull(sum(hours),0) as ttlHours
			from TimeSheet.TimeSheetDetails d
			where status = 1 and d.timesheetid = t.timesheetid
			and (Task in (select activityid from tlkpActivity where timegroup = 'Unpaid') or isnull(task,0) = -100)) as UnpaidHours,
		0 as Status2
	into #tmpTable
	from TimeSheet.Timesheet t
	join TimeSheet.PayPeriods p on p.PeriodStart <= t.StartDate and p.PeriodEnd >= t.StartDate and p.PayDate = @PayDate
	join Contacts.Entity e on e.EntityID = t.EntityID and e.EntityID = @EntityID
	
	where 1=1

	
	declare @returnStatus varchar(100) = 'NotSet'

	declare @NotStarted int = 0
	declare @Open int = 0
	declare @Submitted int = 0
	declare @Approved int = 0

	if exists (select timesheetid from #tmpTable where WorkHours + PTOHours + UnpaidHours = 0)
		begin
			set @NotStarted = 1
		end
	if exists (select timesheetid from #tmpTable where status = 1 and  WorkHours + PTOHours + UnpaidHours > 0)
		begin
			set @Open = 1
		end
	if exists (select timesheetid from #tmpTable where status = 2)
		begin
			set @Submitted = 1
		end
	if exists (select timesheetid from #tmpTable where status = 3)
		begin
			set @Approved = 1
		end
	
	if @Approved = 1 and @Submitted = 0 and @Open = 0 and @NotStarted = 0
		begin
			set @returnStatus = 'Approved'
		end
	if @NotStarted = 1 and @Submitted + @Open + @NotStarted > 0
		begin
			set @returnStatus = 'Not Started - Partial'
		end
	if @NotStarted = 1 and @Submitted + @Open + @NotStarted = 0
		begin
			set @returnStatus = 'Not Started'
		end
	if @Open = 1 and @NotStarted = 0 and @Submitted + @Approved > 0
		begin
			set @returnStatus = 'Open-Partial'
		end
	if @Open = 1 and @NotStarted = 0 and @Submitted + @Approved = 0
		begin
			set @returnStatus = 'Open'
		end
	if @Submitted = 1 and @NotStarted = 0 and @Open = 0 and @Approved = 0
		begin
			set @returnStatus = 'Submitted'
		end
	if @Submitted = 1 and @NotStarted = 0 and @Open = 0 and @Approved = 1
		begin
			set @returnStatus = 'Submitted-Partial'
		end

	select @returnStatus as TimeSheetOverallStatus, @Open as Opened, @Submitted as Submitted, @NotStarted as NotStarted, @Approved as Approved

    
END

GO

