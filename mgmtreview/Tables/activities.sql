CREATE TABLE [mgmtreview].[activities] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [issueId]        INT            NOT NULL,
    [changeDate]     DATETIME2 (7)  CONSTRAINT [DF_activities_changeDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [changeId]       INT            NOT NULL,
    [description]    VARCHAR (2048) CONSTRAINT [DF_activities_description] DEFAULT ('') NOT NULL,
    [activityTypeId] INT            NOT NULL,
    CONSTRAINT [PK_activities] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_activities_activityTypes] FOREIGN KEY ([activityTypeId]) REFERENCES [mgmtreview].[activityTypes] ([id]),
    CONSTRAINT [FK_activities_tasks] FOREIGN KEY ([issueId]) REFERENCES [mgmtreview].[issues] ([id])
);


GO

