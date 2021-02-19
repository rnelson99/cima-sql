CREATE TABLE [dbo].[tblPaymentApplied] (
    [PaymentAppliedID]         INT         IDENTITY (1, 1) NOT NULL,
    [PaymentID]                INT         NOT NULL,
    [InvoiceID]                INT         NULL,
    [ProjectID]                INT         NULL,
    [AmountApply]              MONEY       NULL,
    [IsDeleted]                VARCHAR (1) CONSTRAINT [DF_tblPaymentApplied_IsDeleted] DEFAULT ('N') NULL,
    [PaymentAppliedDate]       DATETIME    NULL,
    [OriginalPaymentAppliedID] INT         NULL,
    CONSTRAINT [PK_tblPaymentApplied] PRIMARY KEY CLUSTERED ([PaymentAppliedID] ASC)
);


GO

