-- =============================================
-- Author:		Chris Hubbard
-- Create date: 10/18/2017
-- Description:	Clone Task
-- =============================================
-- exec dbo.CloneTask 5728, 1, 1, 1, 1
CREATE PROCEDURE [dbo].[CloneTask]
	@taskid int, 
	@numofClones int, --Amount of clones the user wants to create
	@freq int, --1 = Day,		2 = Week,		3 = Month,		4 = Year
	@freqNum int, --number of days, weeks, months or years for freq
	@addID int --the user who is requesting the clone.  Will add the new ones as them.
AS
BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#Task') IS NOT NULL DROP TABLE #Task
	IF OBJECT_ID('tempdb..#Issue') IS NOT NULL DROP TABLE #Issue
	IF OBJECT_ID('tempdb..#Reminders') IS NOT NULL DROP TABLE #Reminders
	IF OBJECT_ID('tempdb..#Assigned') IS NOT NULL DROP TABLE #Assigned

	
	select TaskID, projectid, Importance, Urgency, HiddenTill, SoftDue, HardDue, 
			AddID, Summary, Visibility, status, TaskType, CoreTask, PrivateTask, PersonalTask, HiddenTask, CloneFromID, TaskCloned
	into #task
	from Tasks.TaskList
	where taskid = @taskid

	declare @numOfClonesLoop int = 1;
	declare @softDue datetime = (Select SoftDue from #task)
	declare @hardDue datetime = (Select HardDue from #task)
	declare @HiddenTill datetime = (Select HiddenTill from #task)
	declare @setHiddenTill datetime = null
	

	--select @HiddenTill
	
	select IssueId, taskid, issue, addid, AssignedTo, DoAfter, IssueNum, dueDate, 
		DATEDIFF(D,@softDue,dueDate) as SoftDueDaysFromDue,
		DATEDIFF(D,@hardDue,dueDate) as HardDueDaysFromDue
	into #Issue
	from Tasks.BugIssues
	where taskid = @taskid

	Select AssignedID, TaskID, EntityID
	into #Assigned
	from Tasks.assigned
	where taskid = @taskid

	Select id, TaskID, ShortDesc, reminddate, remindertime,
		DATEDIFF(D,@softDue,reminddate) as SoftDueDaysFromDue,
		DATEDIFF(D,@hardDue,reminddate) as HardDueDaysFromDue, addid
	into #Reminders
	from Tasks.reminders
	where taskid = @taskid

	

	if @softDue is null and @hardDue is null 
	begin
		Select 0 as Processed, 'No Due Dates' as Msg, 0 as NumberOfClones
		return
	end

	--need to make the task hidden till the current due date of the task being cloned
	
	

	while @numOfClonesLoop <= @numofClones
	begin
		--Going to set the due dates relative to the current due date based on freq.
		if @freq = 1 
		begin
			if @softdue is not null set @softDue = DATEADD(D,@freqNum,@softdue)
			if @harddue is not null set @hardDue = DATEADD(D,@freqNum,@hardDue)
			
			if @HiddenTill is not null 
			begin
				set @setHiddenTill = DATEADD(D,@freqNum,@HiddenTill)
				set @HiddenTill = @setHiddenTill
			end
			else
			begin
				if @softDue is not null set @setHiddenTill = @softDue
				if @hardDue is not null set @setHiddenTill = @hardDue
			end
		end
		if @freq = 2
		begin
			if @softdue is not null set @softDue = DATEADD(WEEK,@freqNum,@softdue)
			if @harddue is not null set @hardDue = DATEADD(WEEK,@freqNum,@hardDue)

			if @HiddenTill is not null 
			begin
				set @setHiddenTill = DATEADD(WEEK,@freqNum,@HiddenTill)
				set @HiddenTill = @setHiddenTill
			end
			else
			begin
				if @softDue is not null set @setHiddenTill = @softDue
				if @hardDue is not null set @setHiddenTill = @hardDue
			end
		end
		if @freq = 3
		begin
			if @softdue is not null set @softDue = DATEADD(MONTH,@freqNum,@softdue)
			if @harddue is not null set @hardDue = DATEADD(MONTH,@freqNum,@hardDue)

			if @HiddenTill is not null 
			begin
				set @setHiddenTill = DATEADD(MONTH,@freqNum,@HiddenTill)
				set @HiddenTill = @setHiddenTill
			end
			else
			begin
				if @softDue is not null set @setHiddenTill = @softDue
				if @hardDue is not null set @setHiddenTill = @hardDue
			end
		end
		if @freq = 4 
		begin
			if @softdue is not null set @softDue = DATEADD(YEAR,@freqNum,@softdue)
			if @harddue is not null set @hardDue = DATEADD(YEAR,@freqNum,@hardDue)

			if @HiddenTill is not null 
			begin
				set @setHiddenTill = DATEADD(YEAR,@freqNum,@HiddenTill)
				set @HiddenTill = @setHiddenTill
			end
			else
			begin
				if @softDue is not null set @setHiddenTill = @softDue
				if @hardDue is not null set @setHiddenTill = @hardDue
			end
		end
		
		set @numOfClonesLoop = @numOfClonesLoop + 1
		
		Insert into Tasks.TaskList (projectid, Importance, Urgency, HiddenTill, SoftDue, HardDue, 
			AddID, Summary, Visibility, status, TaskType, CoreTask, PrivateTask, PersonalTask, HiddenTask, CloneFromID, TaskCloned, dbGUID)
		Select projectid, Importance, Urgency, @setHiddenTill, @softDue, @hardDue, 
			AddID, Summary, Visibility, status, TaskType, CoreTask, PrivateTask, PersonalTask, 1, @taskid, 0, newid()
		from #task
		
		declare @newTaskID int = (Select top 1 taskid from tasks.TaskList where CloneFromID = @taskid order by taskid desc)

		insert into Tasks.BugIssues (taskid, issue, addid, AssignedTo, DoAfter, IssueNum, dueDate)
		Select @newTaskID, issue, addid, AssignedTo, DoAfter, IssueNum, 
			case when dueDate is not null then 
				case when HardDueDaysFromDue is not null then DATEADD(D,HardDueDaysFromDue,@hardDue)
				when SoftDueDaysFromDue is not null then DATEADD(D,SoftDueDaysFromDue,@softDue)
				else null end
			else null end 
		from #Issue
				
		Insert into Tasks.assigned (TaskID, EntityID)
		Select @newTaskID, EntityID
		from #Assigned

		--need to update reminddate 
		Insert into Tasks.reminders (TaskID, ShortDesc, remindertime, reminddate, addid)
		Select @newTaskID, ShortDesc, remindertime, 
			case when reminddate is not null then 
				case when HardDueDaysFromDue is not null then DATEADD(D,HardDueDaysFromDue,@hardDue)
				when SoftDueDaysFromDue is not null then DATEADD(D,SoftDueDaysFromDue,@softDue)
				else null end
			else null end, addid
		from #Reminders

		/* End of Loop... Running Statements to get next set of days correct. */
		--need to push the hidden till on the next task to after this one that we just created
		if @softDue is not null set @setHiddenTill = @softDue
		if @hardDue is not null set @setHiddenTill = @hardDue
	end

	update Tasks.TaskList set TaskCloned = 1 where TaskID = @taskid

	Select 1 as Processed, 'Task Clone Complete' as Msg, @numofClones as NumberOfClones

END

GO

