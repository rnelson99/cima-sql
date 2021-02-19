CREATE TABLE [Documents].[MailCallDocumentLink] (
    [MailDocumentID] INT      IDENTITY (1, 1) NOT NULL,
    [MailCallID]     INT      NULL,
    [DocumentID]     INT      NULL,
    [Status]         INT      NULL,
    [AddID]          INT      NULL,
    [AddDate]        DATETIME NULL,
    [ChangeID]       INT      NULL,
    [changeDate]     DATETIME NULL,
    CONSTRAINT [PK_MailCallDocumentLink] PRIMARY KEY CLUSTERED ([MailDocumentID] ASC)
);


GO

