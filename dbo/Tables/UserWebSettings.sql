CREATE TABLE [dbo].[UserWebSettings] (
    [id]            INT IDENTITY (1, 1) NOT NULL,
    [entityid]      INT NULL,
    [sorter]        INT NULL,
    [vis]           BIT NULL,
    [PageSettingID] INT NULL,
    CONSTRAINT [PK_UserWebSettings] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

