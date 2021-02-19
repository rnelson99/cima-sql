CREATE TABLE [users].[LoginHistory] (
    [id]        INT           IDENTITY (1, 1) NOT NULL,
    [entityid]  INT           NULL,
    [status]    INT           NULL,
    [adddate]   DATETIME      NULL,
    [IPAddress] VARCHAR (100) NULL,
    [AlertSent] INT           NULL,
    [loginused] VARCHAR (100) NULL,
    CONSTRAINT [PK_LoginHistory] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

