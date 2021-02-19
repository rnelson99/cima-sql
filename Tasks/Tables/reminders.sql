CREATE TABLE [Tasks].[reminders] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [TaskID]       INT           NULL,
    [ShortDesc]    VARCHAR (200) NULL,
    [reminddate]   DATETIME      NULL,
    [status]       INT           NULL,
    [addid]        INT           NULL,
    [adddate]      DATETIME      CONSTRAINT [DF_reminders_adddate] DEFAULT (getdate()) NULL,
    [remindertime] VARCHAR (25)  NULL,
    [mobile]       BIT           NULL,
    [EntityID]     INT           NULL,
    CONSTRAINT [PK_reminders] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Tasks].[TasRemindersInsertUpdate]
   ON  [Tasks].[reminders]
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

