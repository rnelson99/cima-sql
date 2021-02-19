CREATE TABLE [Documents].[MailCall] (
    [MailCallID]       INT           IDENTITY (1, 1) NOT NULL,
    [DocumentType]     INT           NULL,
    [SecDocumentType]  INT           NULL,
    [FromEntityID]     INT           NULL,
    [VendorEntityID]   INT           NULL,
    [ClientEntityID]   INT           NULL,
    [AttnEntityID]     INT           NULL,
    [EmployeeEntityID] INT           NULL,
    [ProjectID]        INT           NULL,
    [Amount]           MONEY         NULL,
    [NoticeDate]       DATETIME      NULL,
    [DueDate]          DATETIME      NULL,
    [DeliveryMethod]   INT           NULL,
    [Comments]         VARCHAR (MAX) NULL,
    [addid]            INT           NULL,
    [adddate]          DATETIME      NULL,
    [changeid]         INT           NULL,
    [changedate]       DATETIME      NULL,
    [status]           INT           NULL,
    [Confidential]     INT           NULL,
    [intakeGUID]       VARCHAR (50)  NULL,
    [invoicenum]       VARCHAR (100) NULL,
    CONSTRAINT [PK_MailCall] PRIMARY KEY CLUSTERED ([MailCallID] ASC)
);


GO

