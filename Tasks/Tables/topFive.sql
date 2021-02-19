CREATE TABLE [Tasks].[topFive] (
    [id]       INT IDENTITY (1, 1) NOT NULL,
    [taskid]   INT NULL,
    [entityid] INT NULL,
    [sorter]   INT NULL,
    CONSTRAINT [PK_topFive] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

