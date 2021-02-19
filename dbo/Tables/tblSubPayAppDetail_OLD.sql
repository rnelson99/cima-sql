CREATE TABLE [dbo].[tblSubPayAppDetail_OLD] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [SubPayAppId]       INT           NULL,
    [AmountDue]         MONEY         NULL,
    [SupplierType]      NCHAR (15)    NULL,
    [JointCheck]        BIT           DEFAULT ((0)) NULL,
    [SupplierPaidByID]  INT           NULL,
    [CheckNumber]       VARCHAR (50)  NULL,
    [BankIDNumber]      VARCHAR (50)  NULL,
    [SupplierID]        INT           NULL,
    [PaymentStatus]     INT           NULL,
    [AddID]             INT           NULL,
    [ChangeID]          INT           NULL,
    [AddDate]           DATETIME      NULL,
    [ChangeDate]        DATETIME      NULL,
    [SupplierEntityID]  INT           NULL,
    [Approver1]         INT           NULL,
    [Approver1DateTime] DATETIME      NULL,
    [onHold]            INT           NULL,
    [onHoldTill]        DATETIME      NULL,
    [ApproveStatus]     INT           NULL,
    [ApprovalComments]  VARCHAR (MAX) NULL,
    [checkStatus]       VARCHAR (100) NULL,
    [comments]          VARCHAR (MAX) NULL,
    [transdate]         DATETIME      NULL,
    CONSTRAINT [PK_tblSubPayAppDetail] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

