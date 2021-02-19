CREATE TABLE [WebLookup].[LienWaiverReports] (
    [id]              INT            IDENTITY (1, 1) NOT NULL,
    [CrystalReport]   VARCHAR (100)  NULL,
    [status]          INT            NULL,
    [addDate]         DATETIME       NULL,
    [Description]     VARCHAR (1000) NULL,
    [WaiverType]      VARCHAR (20)   NULL,
    [WaiverType2]     VARCHAR (20)   NULL,
    [cimaDefault]     INT            NULL,
    [clientSpecific]  INT            NULL,
    [projectSpecific] INT            NULL,
    [FileFound]       INT            NULL
);


GO

