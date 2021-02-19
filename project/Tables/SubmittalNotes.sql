CREATE TABLE [project].[SubmittalNotes] (
    [id]                INT           IDENTITY (1, 1) NOT NULL,
    [Notes]             VARCHAR (MAX) NULL,
    [AddID]             INT           NULL,
    [AddDate]           DATETIME      NULL,
    [ReminderDate]      DATETIME      NULL,
    [ReminderSent]      DATETIME      NULL,
    [Status]            INT           NULL,
    [SubmittalReportID] INT           NULL,
    CONSTRAINT [PK_SubmittalNotes] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

