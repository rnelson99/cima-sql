CREATE TABLE [WebLookup].[PageSettings] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Val]            VARCHAR (100) NULL,
    [pg]             INT           NULL,
    [sec]            INT           NULL,
    [itm]            INT           NULL,
    [sorter]         INT           NULL,
    [vis]            INT           NULL,
    [ReportTtl]      VARCHAR (50)  NULL,
    [QueryFieldName] VARCHAR (50)  NULL,
    CONSTRAINT [PK_PageSettings] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

