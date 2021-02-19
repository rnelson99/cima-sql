CREATE TABLE [accounting].[SubPayAppJointBalances] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [ProjectId]          INT           NOT NULL,
    [VendorEntityId]     INT           NOT NULL,
    [SupplierEntityId]   INT           NOT NULL,
    [SubPayAppId]        INT           NOT NULL,
    [Balance]            MONEY         NOT NULL,
    [CreateDate]         DATETIME2 (7) CONSTRAINT [DF_SubPayAppJointBalances_CreateDate] DEFAULT (sysdatetime()) NOT NULL,
    [IsCurrent]          BIT           CONSTRAINT [DF_SubPayAppJointBalances_IsCurrent] DEFAULT ((1)) NOT NULL,
    [ApproveDate]        DATETIME2 (7) NULL,
    [ApprovedByEntityId] INT           NULL,
    CONSTRAINT [PK_SubPayAppJointBalances] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

