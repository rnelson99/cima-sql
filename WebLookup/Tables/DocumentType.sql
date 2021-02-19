CREATE TABLE [WebLookup].[DocumentType] (
    [DocumentTypeID] INT           IDENTITY (1, 1) NOT NULL,
    [ReferenceType]  INT           NULL,
    [Description]    VARCHAR (50)  NULL,
    [GroupType]      INT           NULL,
    [lookupDesc]     VARCHAR (100) NULL,
    CONSTRAINT [PK_DocumentType] PRIMARY KEY CLUSTERED ([DocumentTypeID] ASC)
);


GO

