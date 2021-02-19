CREATE TABLE [users].[SettingDefault] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [setting]      VARCHAR (50)   NULL,
    [defaultvalue] VARCHAR (1000) NULL,
    [status]       INT            CONSTRAINT [DF_SettingDefault_status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_SettingDefault] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

