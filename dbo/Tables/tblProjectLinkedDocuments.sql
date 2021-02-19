CREATE TABLE [dbo].[tblProjectLinkedDocuments] (
    [ProjectLinkDocumentsID] INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]              INT            NULL,
    [VendorID]               INT            NULL,
    [Type]                   TINYINT        NULL,
    [Name]                   VARCHAR (100)  NULL,
    [dtDate]                 DATE           NULL,
    [Link]                   VARCHAR (1000) NULL,
    CONSTRAINT [PK_tblProjectLinkedDocuments] PRIMARY KEY CLUSTERED ([ProjectLinkDocumentsID] ASC)
);


GO

