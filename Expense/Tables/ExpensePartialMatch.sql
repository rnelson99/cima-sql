CREATE TABLE [Expense].[ExpensePartialMatch] (
    [id]                 INT           IDENTITY (1, 1) NOT NULL,
    [StartWithMatchName] VARCHAR (100) NULL,
    [EntityID]           INT           NULL,
    [VendorCCName]       VARCHAR (255) NULL,
    CONSTRAINT [PK_ExpensePartialMatch] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

