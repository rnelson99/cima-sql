CREATE TABLE [accounting].[SubPayAppDetailApproval] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [SubPayAppDetailId] INT            NOT NULL,
    [EntityId]          INT            NOT NULL,
    [ApprovalDate]      DATETIME2 (7)  NULL,
    [RejectDate]        DATETIME2 (7)  NULL,
    [Reason]            VARCHAR (1028) NULL,
    CONSTRAINT [PK_SubPayAppDetailApproval] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

