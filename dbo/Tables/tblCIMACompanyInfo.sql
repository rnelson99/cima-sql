CREATE TABLE [dbo].[tblCIMACompanyInfo] (
    [CIMARecordID]          INT           NOT NULL,
    [CIMABusinessName]      VARCHAR (255) NULL,
    [CIMAAddress1]          VARCHAR (255) NULL,
    [CIMAAddress2]          VARCHAR (255) NULL,
    [CIMACity]              VARCHAR (255) NULL,
    [CIMAState]             VARCHAR (255) NULL,
    [CIMAZip]               VARCHAR (255) NULL,
    [CIMAPhone]             VARCHAR (255) NULL,
    [CIMAFax]               VARCHAR (255) NULL,
    [CIMAContact]           VARCHAR (255) NULL,
    [CIMAFederalTaxID]      VARCHAR (255) NULL,
    [CIMAExportPath]        VARCHAR (255) NULL,
    [CIMAContactTitle]      VARCHAR (255) NULL,
    [CIMARecordDescription] VARCHAR (255) NULL,
    CONSTRAINT [PK_tblCIMACompanyInfo] PRIMARY KEY CLUSTERED ([CIMARecordID] ASC)
);


GO

