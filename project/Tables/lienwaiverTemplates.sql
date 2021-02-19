CREATE TABLE [project].[lienwaiverTemplates] (
    [id]             INT IDENTITY (1, 1) NOT NULL,
    [lientemplateid] INT NULL,
    [projectid]      INT NULL,
    CONSTRAINT [PK_lienwaiverTemplates] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

