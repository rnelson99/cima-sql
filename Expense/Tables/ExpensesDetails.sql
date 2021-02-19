CREATE TABLE [Expense].[ExpensesDetails] (
    [ExpenseDetailID] INT        IDENTITY (1, 1) NOT NULL,
    [ExpenseID]       INT        NULL,
    [ProjectID]       INT        NULL,
    [PWALogID]        INT        NULL,
    [SubPayAppID]     INT        NULL,
    [Amount]          FLOAT (53) NULL,
    [CodeID]          INT        NULL,
    [OverheadID]      INT        NULL,
    CONSTRAINT [PK_ExpensesDetails] PRIMARY KEY CLUSTERED ([ExpenseDetailID] ASC)
);


GO

