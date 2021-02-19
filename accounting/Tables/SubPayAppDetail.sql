CREATE TABLE [accounting].[SubPayAppDetail] (
    [SubPayAppDetailID]  INT            IDENTITY (1, 1) NOT NULL,
    [ID]                 INT            NULL,
    [SubPayAppID]        INT            NULL,
    [Amount]             MONEY          NULL,
    [JointCheck]         INT            NULL,
    [SupplierEntityID]   INT            NULL,
    [PaidBy]             INT            NULL,
    [PaymentStatus]      INT            NULL,
    [AddID]              INT            NULL,
    [AddDate]            DATETIME       NULL,
    [ChangeID]           INT            NULL,
    [ChangeDate]         DATETIME       NULL,
    [CheckStatus]        INT            NULL,
    [Memo]               VARCHAR (MAX)  NULL,
    [IssueDate]          DATETIME       NULL,
    [PaidDate]           DATETIME       NULL,
    [PaymentTypeID]      INT            NULL,
    [checknumber]        VARCHAR (100)  NULL,
    [ProviewAccount]     INT            NULL,
    [checkguid]          VARCHAR (100)  NULL,
    [checkMemo]          VARCHAR (150)  NULL,
    [qrCodeImg]          INT            DEFAULT ((0)) NULL,
    [JointPayeeBalance]  MONEY          NULL,
    [ApprovedByEntityId] INT            NULL,
    [Reason]             VARCHAR (2048) NULL,
    CONSTRAINT [PK_SubPayAppDetail] PRIMARY KEY CLUSTERED ([SubPayAppDetailID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [SubPayAppID]
    ON [accounting].[SubPayAppDetail]([SubPayAppID] ASC)
    INCLUDE([SubPayAppDetailID], [ID]);


GO

