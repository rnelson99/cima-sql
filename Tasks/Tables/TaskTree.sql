CREATE TABLE [Tasks].[TaskTree] (
    [TaskOrderID]     INT           IDENTITY (1, 1) NOT NULL,
    [TaskID]          INT           NULL,
    [ParentID]        INT           NULL,
    [Summary]         VARCHAR (100) NULL,
    [TaskTreeOrder]   INT           NULL,
    [Status]          INT           NULL,
    [HasChild]        INT           NULL,
    [mainParentID]    INT           NULL,
    [longdescription] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_TaskTree] PRIMARY KEY CLUSTERED ([TaskOrderID] ASC)
);


GO

