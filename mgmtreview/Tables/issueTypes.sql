CREATE TABLE [mgmtreview].[issueTypes] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [description] VARCHAR (256) NOT NULL,
    CONSTRAINT [PK_issueTypes] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

