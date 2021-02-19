CREATE TABLE [project].[ProjectDailyReport] (
    [DailyReportID]         INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]             INT            NULL,
    [AddID]                 INT            NULL,
    [AddDate]               DATETIME       NULL,
    [ChangeID]              INT            NULL,
    [ChangeDate]            DATETIME       NULL,
    [dDate]                 DATETIME       NULL,
    [Status]                INT            NULL,
    [sendDate]              DATETIME       NULL,
    [DumpsterOnSite]        INT            NULL,
    [DumpsterOnSiteService] VARCHAR (1000) NULL,
    [PortAjonsOnSite]       INT            NULL,
    [PortAjonsServices]     INT            NULL,
    [PortAJohnPulled]       INT            NULL,
    [FullDelay]             INT            NULL,
    [PartialDelay]          INT            NULL,
    CONSTRAINT [PK_ProjectDailyReport] PRIMARY KEY CLUSTERED ([DailyReportID] ASC)
);


GO

