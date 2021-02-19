CREATE TABLE [mgmtreview].[issueEntities] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [issueId]      INT            NOT NULL,
    [entityTypeId] INT            NULL,
    [entityId]     INT            NULL,
    [displayText]  VARCHAR (2048) CONSTRAINT [DF_taskEntities_displayValue] DEFAULT ('') NULL,
    [metaData]     VARCHAR (2048) NULL,
    CONSTRAINT [PK_TaskEntity] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_taskEntities_entityTypes] FOREIGN KEY ([entityTypeId]) REFERENCES [mgmtreview].[entityTypes] ([id]),
    CONSTRAINT [FK_taskEntities_tasks] FOREIGN KEY ([issueId]) REFERENCES [mgmtreview].[issues] ([id])
);


GO

