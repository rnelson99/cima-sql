CREATE TABLE [dbo].[Deprecated.tblAccountRegisterBank] (
    [AccountRegisterBankID]  INT           IDENTITY (1, 1) NOT NULL,
    [AccountRegisterLocalID] INT           NULL,
    [ProViewAccountID]       INT           NULL,
    [TransactionTypeID]      INT           NOT NULL,
    [FITID]                  VARCHAR (50)  NULL,
    [TransactionAmount]      MONEY         NULL,
    [TransactionDate]        DATETIME      NULL,
    [CheckNumber]            VARCHAR (50)  NULL,
    [DatePosted]             DATETIME      NULL,
    [TransactionName]        VARCHAR (255) NULL,
    [TransactionMemo]        VARCHAR (255) NULL,
    [CreatedOn]              DATETIME      CONSTRAINT [DF_tblAccountRegisterBank_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]            VARCHAR (255) NULL,
    [ModifiedLast]           DATETIME      NULL,
    [UpdatedUser]            VARCHAR (255) NULL,
    CONSTRAINT [PK_tblAccountRegisterBank] PRIMARY KEY CLUSTERED ([AccountRegisterBankID] ASC)
);


GO

