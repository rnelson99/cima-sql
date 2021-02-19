CREATE TABLE [dbo].[tlkpPaymentType] (
    [PaymentTypeID]          INT           IDENTITY (1, 1) NOT NULL,
    [PaymentTypeDescription] VARCHAR (255) NOT NULL,
    [WriteOff]               INT           DEFAULT ((0)) NULL,
    [excludeInvoice]         INT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tlkpPaymentType] PRIMARY KEY CLUSTERED ([PaymentTypeID] ASC)
);


GO

