CREATE TABLE [Expense].[ExpenseMatch] (
    [MatchID]    INT           IDENTITY (1, 1) NOT NULL,
    [MatchName]  VARCHAR (200) NULL,
    [AddID]      INT           NULL,
    [AddDate]    DATETIME      NULL,
    [ChangeID]   INT           NULL,
    [ChangeDate] DATETIME      NULL,
    [EntityID]   INT           NULL,
    [MatchType]  INT           NULL,
    CONSTRAINT [PK_ExpenseMatch] PRIMARY KEY CLUSTERED ([MatchID] ASC)
);


GO

