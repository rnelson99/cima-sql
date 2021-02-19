CREATE TABLE [Contacts].[Deprecated.Statements] (
    [StatementID]   INT           IDENTITY (1, 1) NOT NULL,
    [EntityID]      INT           NULL,
    [StatementDate] DATETIME      NULL,
    [AmountDue]     MONEY         NULL,
    [CurrentDue]    MONEY         NULL,
    [ThirtyPlus]    MONEY         NULL,
    [SixtyPlus]     MONEY         NULL,
    [NinetyPlus]    MONEY         NULL,
    [OneTwentyPlus] MONEY         NULL,
    [Comments]      VARCHAR (MAX) NULL,
    [tGUID]         VARCHAR (50)  NULL,
    [AddID]         INT           NULL,
    [ChangeID]      INT           NULL,
    [AddDate]       DATETIME      NULL,
    [ChangeDate]    DATETIME      NULL,
    CONSTRAINT [PK_Statements] PRIMARY KEY CLUSTERED ([StatementID] ASC)
);


GO

