CREATE TABLE [project].[dailyReportOptions] (
    [ID]         INT        IDENTITY (1, 1) NOT NULL,
    [projectID]  INT        NULL,
    [sendPDF]    INT        NULL,
    [addID]      INT        NULL,
    [addDate]    DATETIME   NULL,
    [changeID]   INT        NULL,
    [changeDate] DATETIME   NULL,
    [status]     NCHAR (10) NULL,
    CONSTRAINT [PK_dailyReportOptions] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

