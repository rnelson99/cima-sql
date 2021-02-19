CREATE TABLE [Contacts].[Alias] (
    [AliasID]    INT           IDENTITY (1, 1) NOT NULL,
    [EntityID]   INT           NULL,
    [Alias]      VARCHAR (100) NULL,
    [AddID]      INT           NULL,
    [AddDate]    DATETIME      NULL,
    [ChangeID]   INT           NULL,
    [ChangeDate] DATETIME      NULL,
    [Status]     INT           NULL,
    CONSTRAINT [PK_Alias] PRIMARY KEY CLUSTERED ([AliasID] ASC)
);


GO

