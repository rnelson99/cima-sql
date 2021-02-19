CREATE TABLE [Expense].[CreditCardItems] (
    [CreditCardID]   INT           IDENTITY (1, 1) NOT NULL,
    [dtPosted]       DATETIME      NULL,
    [CCAmount]       MONEY         NULL,
    [Name]           VARCHAR (200) NULL,
    [FITID]          VARCHAR (100) NULL,
    [ExpenseID]      INT           NULL,
    [AccountID]      INT           NULL,
    [AccountNumber]  VARCHAR (200) NULL,
    [RefNum]         VARCHAR (100) NULL,
    [Memo]           VARCHAR (200) NULL,
    [VendorEntityID] INT           NULL,
    [importSource]   VARCHAR (10)  NULL,
    [importEmployee] INT           NULL,
    [importGUID]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_CreditCardItems] PRIMARY KEY CLUSTERED ([CreditCardID] ASC)
);


GO

