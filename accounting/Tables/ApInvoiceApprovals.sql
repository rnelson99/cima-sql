CREATE TABLE [accounting].[ApInvoiceApprovals] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [ApInvoiceId]      INT           NOT NULL,
    [ApprovalEntityId] INT           NULL,
    [CreateDate]       DATETIME2 (7) CONSTRAINT [DF_ApInvoiceApprovals_CreateDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [ApproveDate]      DATETIME2 (7) NULL,
    [RejectDate]       DATETIME2 (7) NULL,
    [Reason]           VARCHAR (512) NULL,
    [UserFunctionId]   INT           NULL,
    [ShowDate]         DATETIME2 (7) NULL,
    [Sequence]         INT           CONSTRAINT [DF_ApInvoiceApprovals_Sequence] DEFAULT ((0)) NOT NULL,
    [IsComplete]       BIT           CONSTRAINT [DF_ApInvoiceApprovals_IsComplete] DEFAULT ((0)) NOT NULL,
    [IsShown]          BIT           CONSTRAINT [DF_ApInvoiceApprovals_IsShown] DEFAULT ((0)) NOT NULL,
    [DueDate]          DATETIME2 (7) NULL,
    [DueFormula]       INT           NULL,
    CONSTRAINT [PK_ApInvoiceApprovals] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ApInvoices_ApInvoiceApprovals] FOREIGN KEY ([ApInvoiceId]) REFERENCES [accounting].[ApInvoices] ([Id])
);


GO

