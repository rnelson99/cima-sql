CREATE TABLE [users].[UserSettings] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [entityid]     INT            NULL,
    [setting]      VARCHAR (50)   NULL,
    [settingvalue] VARCHAR (1000) NULL,
    CONSTRAINT [PK_UserSettings] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

