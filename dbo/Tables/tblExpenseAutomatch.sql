CREATE TABLE [dbo].[tblExpenseAutomatch] (
    [ExpenseAutomatchID]   INT           IDENTITY (1, 1) NOT NULL,
    [SourceFieldName]      VARCHAR (255) NULL,
    [SourceFieldValue]     VARCHAR (255) NULL,
    [MatchFieldName]       VARCHAR (255) NULL,
    [MatchFieldValue]      VARCHAR (255) NULL,
    [ExpenseAutomatchType] VARCHAR (2)   NULL,
    CONSTRAINT [PK_tblExpenseAutomatch] PRIMARY KEY CLUSTERED ([ExpenseAutomatchID] ASC)
);


GO

