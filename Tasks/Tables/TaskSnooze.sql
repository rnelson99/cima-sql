CREATE TABLE [Tasks].[TaskSnooze] (
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    [entityid]   INT      NULL,
    [taskid]     INT      NULL,
    [snoozeTill] DATETIME NULL,
    CONSTRAINT [PK_TaskSnooze] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Tasks].[TaskSnoozeInsertUpdate]
   ON  [Tasks].[TaskSnooze]
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

