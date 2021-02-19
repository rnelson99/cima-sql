CREATE TABLE [dbo].[tblMiscSettings] (
    [sSetting]  NVARCHAR (50) NULL,
    [sValue]    NVARCHAR (50) NULL,
    [SettingID] INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [SettingID] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);


GO

