CREATE TABLE [Expense].[ReceiptMatch] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [Amount]          MONEY          NULL,
    [ExpenseGUID]     VARCHAR (50)   NULL,
    [PhotoGUID]       VARCHAR (50)   NULL,
    [CodeID]          INT            NULL,
    [Purpose]         VARCHAR (1000) NULL,
    [ProjectID]       INT            NULL,
    [adddate]         DATETIME       NULL,
    [addid]           INT            NULL,
    [transactiondate] DATETIME       NULL,
    [ExpenseID]       INT            NULL,
    [uploadSource]    INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_ReceiptMatch] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

