CREATE TABLE [dbo].[tblProjectDocuments] (
    [ProjectDocumentID] INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]         INT            NULL,
    [AddID]             INT            NULL,
    [AddDate]           DATETIME       NULL,
    [filename]          VARCHAR (1000) NULL,
    [DocumentType]      INT            NULL,
    [internalOnly]      BIT            NULL,
    [DocumentStatus]    BIT            DEFAULT ((1)) NULL,
    [ReplacementID]     INT            DEFAULT ((0)) NULL,
    [documentURL]       VARCHAR (1000) NULL,
    CONSTRAINT [PK_tblProjectDocuments] PRIMARY KEY CLUSTERED ([ProjectDocumentID] ASC)
);


GO

