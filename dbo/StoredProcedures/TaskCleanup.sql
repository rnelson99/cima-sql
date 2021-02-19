-- =============================================
-- Author:		Chris Hubbard
-- Create date: 10/16/2017
-- Description:	Task Rel Cleanup Function
-- =============================================
CREATE PROCEDURE [dbo].[TaskCleanup]
	
AS
BEGIN
	SET NOCOUNT ON;

	Delete from tasks.topFive where taskid in (select taskid from tasks.tasklist where status = 0)
	delete from logDatabase.dbo.IssueNew where issueid in (select IssueId from Tasks.BugIssues where status = 6)
	Delete from logDatabase.dbo.IssueNew where taskid in (select taskid from Tasks.TaskList where BugStatus = 0 and tasktype in (24,25))
	
	update Tasks.BugIssues set status = 1 where status = 8 and isnull(doafter,0) < 3 

	Update Tasks.reminders 
		set EntityID = AddID 
	where entityid is null
	
	Update i
	set i.assignedto = t.addid
	from Tasks.BugIssues i
	join Tasks.TaskList t on i.taskid = t.TaskID
	where i.AssignedTo is null

	Update Tasks.BugIssues set status = 1 where status is null

	update Tasks.BugIssues set status = 2 where issueid in (
					Select i.IssueId
					from Tasks.TaskList t
					join Tasks.BugIssues i on i.taskid = t.TaskID and t.AddID = i.AssignedTo and i.status = 1)
	
	update Tasks.BugIssues set status = 1 where status = 8 and isnull(doafter,0) < 3 

END

GO

