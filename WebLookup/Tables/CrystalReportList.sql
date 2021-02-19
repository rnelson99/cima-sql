CREATE TABLE [WebLookup].[CrystalReportList] (
    [id]        INT            IDENTITY (1, 1) NOT NULL,
    [filename]  VARCHAR (100)  NULL,
    [paramList] VARCHAR (1000) NULL,
    [status]    INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_CrystalReportList] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

