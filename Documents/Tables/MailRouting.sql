CREATE TABLE [Documents].[MailRouting] (
    [MailRoutingID]   INT           IDENTITY (1, 1) NOT NULL,
    [MailCallID]      INT           NULL,
    [DocumentID]      INT           NULL,
    [EntityID]        INT           NULL,
    [AddID]           INT           NULL,
    [AddDate]         DATETIME      NULL,
    [Status]          INT           NULL,
    [CorrectedAmount] MONEY         NULL,
    [Comments]        VARCHAR (MAX) NULL,
    [NotifyVendorPM]  INT           NULL,
    [BodyOfEmail]     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_MailRouting] PRIMARY KEY CLUSTERED ([MailRoutingID] ASC)
);


GO

