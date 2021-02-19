CREATE TABLE [mgmtreview].[statusTypes] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [description] VARCHAR (256) NOT NULL,
    CONSTRAINT [PK_status] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

