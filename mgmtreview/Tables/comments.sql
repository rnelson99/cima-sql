CREATE TABLE [mgmtreview].[comments] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [issueId]      INT           NOT NULL,
    [addId]        INT           NOT NULL,
    [createDate]   DATETIME2 (7) CONSTRAINT [DF_comments_createDate] DEFAULT (sysutcdatetime()) NOT NULL,
    [description]  VARCHAR (MAX) NULL,
    [isViewed]     BIT           CONSTRAINT [DF_comments_isViewed] DEFAULT ((0)) NOT NULL,
    [fromEntityId] INT           NOT NULL,
    [toEntityId]   INT           NULL,
    [viewDate]     DATETIME2 (7) NULL,
    CONSTRAINT [PK_comments] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_comments_tasks] FOREIGN KEY ([issueId]) REFERENCES [mgmtreview].[issues] ([id])
);


GO

