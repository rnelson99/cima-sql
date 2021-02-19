CREATE TABLE [Tasks].[assigned] (
    [AssignedID]         INT          IDENTITY (1, 1) NOT NULL,
    [TaskID]             INT          NULL,
    [EntityID]           INT          NULL,
    [Accepted]           INT          CONSTRAINT [DF_assigned_Accepted] DEFAULT ((0)) NULL,
    [Reqd]               INT          CONSTRAINT [DF_assigned_Reqd] DEFAULT ((0)) NULL,
    [Shared]             INT          CONSTRAINT [DF_assigned_Shared] DEFAULT ((0)) NULL,
    [AddID]              INT          NULL,
    [AddDate]            DATETIME     CONSTRAINT [DF_assigned_AddDate] DEFAULT (getdate()) NULL,
    [status]             INT          CONSTRAINT [DF__assigned__status__6BCEF5F8] DEFAULT ((1)) NULL,
    [Delegated]          BIT          CONSTRAINT [DF__assigned__Delega__0D2FE9C3] DEFAULT ((0)) NULL,
    [DelegatedID]        INT          CONSTRAINT [DF__assigned__Delega__0E240DFC] DEFAULT ((0)) NULL,
    [AcceptedDate]       DATETIME     NULL,
    [CompleteDate]       DATETIME     NULL,
    [AcceptReminderDate] DATETIME     NULL,
    [AssignmentEmail]    INT          CONSTRAINT [DF__assigned__Assign__55AAAAAF] DEFAULT ((0)) NULL,
    [tempGUID]           VARCHAR (50) NULL,
    [functionID]         INT          NULL,
    CONSTRAINT [PK_assigned] PRIMARY KEY CLUSTERED ([AssignedID] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Tasks].[TaskAssignedInsertUpdate]
   ON  [Tasks].[assigned]
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

