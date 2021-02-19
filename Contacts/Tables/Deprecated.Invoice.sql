CREATE TABLE [Contacts].[Deprecated.Invoice] (
    [InvoiceID]     INT          IDENTITY (1, 1) NOT NULL,
    [EntityID]      INT          NULL,
    [ProjectID]     INT          NULL,
    [ParentInvoice] INT          NULL,
    [DueDate]       DATETIME     NULL,
    [AmountDue]     MONEY        NULL,
    [InvoiceNo]     VARCHAR (50) NULL,
    [Status]        INT          NULL,
    [PWALogID]      INT          NULL,
    [InvoiceDate]   DATETIME     NULL,
    [AddID]         INT          NULL,
    [ChangeID]      INT          NULL,
    [AddDate]       DATETIME     NULL,
    [ChangeDate]    DATETIME     NULL,
    CONSTRAINT [PK_Invoice] PRIMARY KEY CLUSTERED ([InvoiceID] ASC)
);


GO

