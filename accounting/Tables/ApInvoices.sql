CREATE TABLE [accounting].[ApInvoices] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [ProjectId]            INT             NOT NULL,
    [VendorEntityId]       INT             NULL,
    [AddUserEntityId]      INT             NOT NULL,
    [ApInvoiceTypeCode]    INT             NOT NULL,
    [IsApprovalSequential] BIT             CONSTRAINT [DF_ApInvoices_IsApprovalSequential] DEFAULT ((1)) NOT NULL,
    [CreateDate]           DATETIME2 (7)   CONSTRAINT [DF_ApInvoices_CreateDate] DEFAULT (sysdatetime()) NOT NULL,
    [Amount]               DECIMAL (18, 2) NULL,
    [ApNumber]             VARCHAR (50)    NULL,
    [ApDate]               DATETIME2 (7)   NULL,
    [PaymentRequestDate]   DATETIME2 (7)   NULL,
    [MetaData]             VARCHAR (2048)  NULL,
    [ProviewParentId]      INT             NULL,
    CONSTRAINT [PK_ApInvoices] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

