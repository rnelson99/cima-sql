CREATE TABLE [users].[onesignal] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [entityid]   INT           NULL,
    [playerid]   VARCHAR (100) NULL,
    [lastCheck]  DATETIME      NULL,
    [deviceType] VARCHAR (10)  NULL,
    CONSTRAINT [PK_onesignal] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

