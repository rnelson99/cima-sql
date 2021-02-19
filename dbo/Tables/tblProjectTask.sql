CREATE TABLE [dbo].[tblProjectTask] (
    [ProjectTaskID]    INT           NULL,
    [ProjectID]        INT           NULL,
    [Task]             VARCHAR (100) NULL,
    [DueDate]          DATE          NULL,
    [Status]           INT           CONSTRAINT [DF_tblProjectTask_Status] DEFAULT ((1)) NULL,
    [TaskFrom]         INT           NULL,
    [ShortDescription] VARCHAR (100) NULL,
    [LongDescription]  VARCHAR (MAX) NULL,
    [TaskPriority]     INT           NULL,
    [TaskUrgency]      INT           NULL,
    [TaskVisibility]   INT           NULL
);


GO

