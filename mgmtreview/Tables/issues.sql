CREATE TABLE [mgmtreview].[issues] (
    [id]                      INT           IDENTITY (1, 1) NOT NULL,
    [ownerEntityId]           INT           NOT NULL,
    [softDeadlineDate]        DATETIME2 (7) NULL,
    [softDeadlineFormula]     VARCHAR (50)  NULL,
    [softReminderThemDate]    DATETIME2 (7) NULL,
    [softReminderThemFormula] VARCHAR (50)  NULL,
    [softReminderMeDate]      DATETIME2 (7) NULL,
    [softReminderMeFormula]   VARCHAR (50)  NULL,
    [hardDeadlineDate]        DATETIME2 (7) NULL,
    [hardDeadlineFormula]     VARCHAR (50)  NULL,
    [hardReminderThemDate]    DATETIME2 (7) NULL,
    [hardReminderThemFormula] VARCHAR (50)  NULL,
    [hardReminderMeDate]      DATETIME2 (7) NULL,
    [hardReminderMeFormula]   VARCHAR (50)  NULL,
    [addId]                   INT           NULL,
    [createDate]              DATETIME2 (7) CONSTRAINT [DF_task_createDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [description]             VARCHAR (MAX) NULL,
    [statusTypeId]            INT           CONSTRAINT [DF_Task_StatusTypeId] DEFAULT ((1)) NOT NULL,
    [issueTypeId]             INT           CONSTRAINT [DF_Task_TaskTypeId] DEFAULT ((1)) NOT NULL,
    [changeId]                INT           NULL,
    [changeDate]              DATETIME2 (7) NULL,
    [emailTo]                 VARCHAR (MAX) NULL,
    [emailCc]                 VARCHAR (MAX) NULL,
    [Importance]              INT           CONSTRAINT [DF_issues_Importance] DEFAULT ((0)) NOT NULL,
    [Urgency]                 INT           CONSTRAINT [DF_issues_Urgency] DEFAULT ((0)) NOT NULL,
    [metadata]                VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_tasks_statusTypes] FOREIGN KEY ([statusTypeId]) REFERENCES [mgmtreview].[statusTypes] ([id]),
    CONSTRAINT [FK_tasks_taskTypes] FOREIGN KEY ([issueTypeId]) REFERENCES [mgmtreview].[issueTypes] ([id])
);


GO

