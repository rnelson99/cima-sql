CREATE TABLE [dbo].[tblInvoiceItems] (
    [InvoiceItem]   NVARCHAR (20) NULL,
    [InvoiceItemID] INT           IDENTITY (1, 1) NOT NULL,
    [InvoiceDesc]   NVARCHAR (50) NULL,
    [DDDesc]        NVARCHAR (50) NULL,
    CONSTRAINT [InvoiceItemID] PRIMARY KEY CLUSTERED ([InvoiceItemID] ASC)
);


GO

