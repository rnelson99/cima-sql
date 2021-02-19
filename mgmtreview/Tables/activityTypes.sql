CREATE TABLE [mgmtreview].[activityTypes] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [description] VARCHAR (2048) NULL,
    CONSTRAINT [PK_activityTypes] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

