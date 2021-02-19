CREATE TABLE [approval].[Approvals] (
    [Id]               INT           IDENTITY (1, 1) NOT NULL,
    [ApprovalTypeId]   INT           NOT NULL,
    [ParentId]         INT           NOT NULL,
    [ApprovalEntityId] INT           NULL,
    [CreateDate]       DATETIME2 (7) CONSTRAINT [DF_SubPayAppApproval_CreateDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [ApproveDate]      DATETIME2 (7) NULL,
    [RejectDate]       DATETIME2 (7) NULL,
    [Reason]           VARCHAR (512) NULL,
    [UserFunctionId]   INT           NULL,
    [ShowDate]         DATETIME2 (7) NULL,
    [Sequence]         INT           CONSTRAINT [DF_SubPayAppApproval_Sequence] DEFAULT ((0)) NOT NULL,
    [IsComplete]       BIT           CONSTRAINT [DF_SubPayAppApproval_IsComplete] DEFAULT ((0)) NOT NULL,
    [IsShown]          BIT           CONSTRAINT [DF_SubPayAppApproval_IsShown] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Approvals] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

