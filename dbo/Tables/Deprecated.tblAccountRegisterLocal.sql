CREATE TABLE [dbo].[Deprecated.tblAccountRegisterLocal] (
    [AccountRegisterLocalID]       INT           IDENTITY (1, 1) NOT NULL,
    [ParentAccountRegisterLocalID] INT           NULL,
    [ProViewAccountID]             INT           NULL,
    [TransactionTypeID]            INT           NOT NULL,
    [TransactionAmount]            MONEY         NULL,
    [TransactionIssueDate]         DATETIME      NULL,
    [TransactionPostedDate]        DATETIME      NULL,
    [CheckNumberAP]                VARCHAR (50)  NULL,
    [VendorID]                     INT           NULL,
    [JointPayeeVendorID]           INT           NULL,
    [MiscIncomeID]                 INT           NULL,
    [TransactionName]              VARCHAR (255) NULL,
    [TransactionMemo]              VARCHAR (255) NULL,
    [IsVoid]                       VARCHAR (1)   CONSTRAINT [DF_tblAccountRegisterLocal_IsVoid] DEFAULT ('N') NOT NULL,
    [IsAutoEntry]                  VARCHAR (1)   CONSTRAINT [DF_tblAccountRegisterLocal_IsAutoEntry] DEFAULT ('N') NOT NULL,
    [CreatedOn]                    DATETIME      CONSTRAINT [DF_tblAccountRegisterLocal_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]                  VARCHAR (255) NULL,
    [ModifiedLast]                 DATETIME      NULL,
    [UpdatedUser]                  VARCHAR (255) NULL,
    [AddID]                        INT           NULL,
    [ChangeID]                     INT           NULL,
    [AddDate]                      DATETIME      NULL,
    [ChangeDate]                   DATETIME      NULL,
    [EntityID]                     INT           NULL,
    [CheckGUID]                    VARCHAR (100) NULL,
    [SubPayAppID]                  INT           NULL,
    [CheckStatus]                  INT           NULL,
    [PreviousStatus]               INT           NULL,
    CONSTRAINT [PK_tblAccountRegisterLocal] PRIMARY KEY CLUSTERED ([AccountRegisterLocalID] ASC)
);


GO

