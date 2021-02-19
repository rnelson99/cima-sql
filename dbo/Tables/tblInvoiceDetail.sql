CREATE TABLE [dbo].[tblInvoiceDetail] (
    [InvoiceDetailID]              INT            IDENTITY (1, 1) NOT NULL,
    [InvoiceID]                    INT            NULL,
    [ItemName]                     VARCHAR (1000) NULL,
    [ItemDescription]              VARCHAR (1000) NULL,
    [InvoiceDetailAmount]          MONEY          NULL,
    [InvoiceDetailCreatedBySystem] BIT            DEFAULT ((0)) NOT NULL,
    [OCOId]                        INT            NULL,
    [addID]                        INT            NULL,
    [addDate]                      DATETIME       NULL,
    [status]                       INT            NULL,
    CONSTRAINT [InvoiceDetailID] PRIMARY KEY CLUSTERED ([InvoiceDetailID] ASC)
);


GO

