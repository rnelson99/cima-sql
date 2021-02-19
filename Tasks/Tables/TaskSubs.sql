CREATE TABLE [Tasks].[TaskSubs] (
    [TaskID]   INT      NULL,
    [EntityID] INT      NULL,
    [AddDate]  DATETIME CONSTRAINT [DF_TaskSubs_AddDate] DEFAULT (getdate()) NULL,
    [id]       INT      IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_TaskSubs] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

