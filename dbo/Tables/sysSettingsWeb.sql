CREATE TABLE [dbo].[sysSettingsWeb] (
    [ID]            INT          IDENTITY (1, 1) NOT NULL,
    [TwilloFrom]    VARCHAR (11) NULL,
    [TwilloUser]    VARCHAR (50) NULL,
    [TwilloPass]    VARCHAR (50) NULL,
    [PhotoDistance] FLOAT (53)   NULL,
    CONSTRAINT [PK_sysSettingsWeb] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

