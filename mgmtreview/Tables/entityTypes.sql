CREATE TABLE [mgmtreview].[entityTypes] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [description] VARCHAR (256)  NOT NULL,
    [route]       VARCHAR (2048) CONSTRAINT [DF_entityTypes_route] DEFAULT ('') NOT NULL,
    [parameter]   VARCHAR (256)  CONSTRAINT [DF_entityTypes_parameterName] DEFAULT ('') NOT NULL,
    CONSTRAINT [PK_entityTypes] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

