CREATE TABLE [dbo].[wifi] (
    [wifiID] INT          IDENTITY (1, 1) NOT NULL,
    [wifi]   VARCHAR (50) NULL,
    CONSTRAINT [PK_wifi] PRIMARY KEY CLUSTERED ([wifiID] ASC)
);


GO

