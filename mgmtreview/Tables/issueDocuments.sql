CREATE TABLE [mgmtreview].[issueDocuments] (
    [id]         INT IDENTITY (1, 1) NOT NULL,
    [issueId]    INT NOT NULL,
    [documentId] INT NOT NULL,
    CONSTRAINT [PK_taskDocuments] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_issueDocuments_issueDocuments] FOREIGN KEY ([id]) REFERENCES [mgmtreview].[issueDocuments] ([id]),
    CONSTRAINT [FK_issueDocuments_issues] FOREIGN KEY ([issueId]) REFERENCES [mgmtreview].[issues] ([id])
);


GO

