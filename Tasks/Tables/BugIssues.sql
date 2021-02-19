CREATE TABLE [Tasks].[BugIssues] (
    [IssueId]     INT            IDENTITY (1, 1) NOT NULL,
    [taskid]      INT            NULL,
    [issue]       VARCHAR (2000) NULL,
    [addid]       INT            NULL,
    [adddate]     DATETIME       NULL,
    [changeid]    INT            NULL,
    [changedate]  DATETIME       NULL,
    [status]      INT            NULL,
    [AssignedTo]  INT            DEFAULT ((0)) NULL,
    [issueGUID]   VARCHAR (50)   NULL,
    [DoAfter]     INT            NULL,
    [IssueNum]    INT            NULL,
    [dueDate]     DATETIME       NULL,
    [newPushover] BIT            DEFAULT ((0)) NULL,
    [functionid]  INT            NULL,
    [contactID]   INT            NULL,
    CONSTRAINT [PK_BugIssues] PRIMARY KEY CLUSTERED ([IssueId] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190530-171045]
    ON [Tasks].[BugIssues]([taskid] ASC)
    INCLUDE([IssueId]);


GO

-- =============================================
-- Author:		Chris Hubbard
-- Description:	This trigger is to make sure the database table is up to date.  See comments below.....
-- =============================================
CREATE TRIGGER [Tasks].[bugissuetrigger]
   ON  [Tasks].[BugIssues]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		--Do After is getting set to -1 which is causing issues.... Need to research more
		update Tasks.BugIssues set doAfter = null where doafter = -1

		--This call will update issues where the DOAfter is set.  
		Update i
		set i.status = 8
		from Tasks.BugIssues i
		join tasks.BugIssues zi on zi.issueid = i.doafter and zi.status !=6 
		where i.status != 8

		--This call will update issues where the DOAfter is set.  
		Update i
		set i.status = 1
		from Tasks.BugIssues i
		join tasks.BugIssues zi on zi.issueid = i.doafter and zi.status =6 
		where i.status = 8

		--Making sure the chagne date has been properly updated.  
		Update tasks.BugIssues set ChangeDate = getdate() where IssueID in (Select IssueID from inserted)

		
		while exists (select * from Tasks.BugIssues where ltrim(rtrim(isnull(issueguid,''))) = '')
		begin
			declare @issueid int = (select top 1 issueid from Tasks.BugIssues where ltrim(rtrim(isnull(issueguid,''))) = '')
			declare @u varchar(100) = newid()
			update Tasks.BugIssues set issueGUID = @u where IssueId = @issueid
		end


		update Tasks.BugIssues set status = 1 where status = 8 and isnull(doafter,0) < 3 

END

GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Tasks].[TaskBugIssuesInsertUpdate]
   ON  [Tasks].[BugIssues]
   AFTER Insert, Update
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	Insert into tasks.TaskChange (TaskID,modifieddate)
	Select i.TaskID, getdate()
	from inserted i
	left join tasks.TaskList t on t.TaskID = i.TaskID
	where t.TaskID is null

	Update c
		set c.modifieddate = getdate()
	from tasks.taskchange c
	join Tasks.tasklist t on t.TaskID = c.taskid
	join inserted i on i.TaskID = t.taskid
	
END

GO

