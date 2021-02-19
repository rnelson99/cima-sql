CREATE TABLE [mgmtreview].[reminders] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [issueId]      INT           NOT NULL,
    [addId]        INT           NULL,
    [createDate]   DATETIME2 (7) CONSTRAINT [DF_reminders_createDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [reminderDate] DATETIME2 (7) NOT NULL,
    [isSoft]       BIT           CONSTRAINT [DF_reminders_isSoft] DEFAULT ((0)) NOT NULL,
    [emailDate]    DATETIME2 (7) NULL,
    [emailTo]      VARCHAR (MAX) NULL,
    [emailCc]      VARCHAR (MAX) NULL,
    [viewDate]     DATETIME2 (7) NULL,
    [isComplete]   BIT           NULL,
    [isThem]       BIT           CONSTRAINT [DF_reminders_isThem] DEFAULT ((0)) NOT NULL,
    [isRepeating]  BIT           CONSTRAINT [DF_reminders_isRepeating] DEFAULT ((0)) NOT NULL,
    [RepeatDays]   INT           CONSTRAINT [DF_reminders_RepeatDays] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_reminders_1] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_reminders_tasks] FOREIGN KEY ([issueId]) REFERENCES [mgmtreview].[issues] ([id])
);


GO

