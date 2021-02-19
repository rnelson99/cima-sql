CREATE TABLE [accounting].[Deprecated.receipt] (
    [ExpenseID]       INT           IDENTITY (1, 1) NOT NULL,
    [ExpenseGUID]     VARCHAR (50)  NULL,
    [ExpenseTotal]    MONEY         NULL,
    [Purpose]         VARCHAR (100) NULL,
    [ProjectID]       INT           NULL,
    [DivCode]         INT           NULL,
    [PhotoID]         VARCHAR (100) NULL,
    [AddDate]         DATETIME      NULL,
    [AddID]           INT           NULL,
    [ChangeDate]      DATETIME      NULL,
    [ChangeID]        INT           NULL,
    [LongDescription] VARCHAR (MAX) NULL,
    [ChangeDateUTC]   DATETIME      NULL,
    CONSTRAINT [PK_accountings] PRIMARY KEY CLUSTERED ([ExpenseID] ASC)
);


GO

