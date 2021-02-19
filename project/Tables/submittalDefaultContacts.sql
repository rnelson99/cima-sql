CREATE TABLE [project].[submittalDefaultContacts] (
    [id]                INT      IDENTITY (1, 1) NOT NULL,
    [ProjectID]         INT      NULL,
    [SubmittalStatusID] INT      NULL,
    [AddID]             INT      NULL,
    [AddDate]           DATETIME NULL,
    [ChangeID]          INT      NULL,
    [ChangeDate]        DATETIME NULL,
    [status]            INT      NULL,
    CONSTRAINT [PK_submittalDefaultContacts] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

