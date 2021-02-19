CREATE TABLE [RequestForInfo].[EmailLog] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [rfiid]    INT           NULL,
    [email]    VARCHAR (200) NULL,
    [guid]     VARCHAR (50)  NULL,
    [addid]    INT           NULL,
    [adddate]  DATETIME      NULL,
    [entityid] INT           NULL,
    CONSTRAINT [PK_EmailLog] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

