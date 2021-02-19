CREATE TABLE [Documents].[Contracts] (
    [contractID] INT      IDENTITY (1, 1) NOT NULL,
    [projectid]  INT      NULL,
    [addid]      INT      NULL,
    [adddate]    DATETIME NULL,
    CONSTRAINT [PK_Contracts] PRIMARY KEY CLUSTERED ([contractID] ASC)
);


GO

