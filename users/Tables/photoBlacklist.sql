CREATE TABLE [users].[photoBlacklist] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [entityid] INT           NULL,
    [latlong]  VARCHAR (50)  NULL,
    [addid]    INT           NULL,
    [adddate]  DATETIME      NULL,
    [comment]  VARCHAR (100) NULL,
    CONSTRAINT [PK_photoBlacklist] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

