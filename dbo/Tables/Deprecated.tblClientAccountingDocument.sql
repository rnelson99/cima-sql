CREATE TABLE [dbo].[Deprecated.tblClientAccountingDocument] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]      INT           NOT NULL,
    [DocumentTitle] VARCHAR (255) NULL,
    [DocumentPath]  VARCHAR (255) NULL,
    CONSTRAINT [tblClientAccountingDocument_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

