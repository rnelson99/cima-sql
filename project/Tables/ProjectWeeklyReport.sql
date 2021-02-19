CREATE TABLE [project].[ProjectWeeklyReport] (
    [WeeklyReportID] INT      IDENTITY (1, 1) NOT NULL,
    [ProjectID]      INT      NULL,
    [AddID]          INT      NULL,
    [AddDate]        DATETIME NULL,
    [ChangeID]       INT      NULL,
    [ChangeDate]     DATETIME NULL,
    [dtWeek]         DATETIME NULL,
    [status]         INT      NULL,
    [weekNum]        INT      NULL,
    [sendDate]       DATETIME NULL,
    [DocumentID]     INT      NULL,
    CONSTRAINT [PK_ProjectWeeklyReport] PRIMARY KEY CLUSTERED ([WeeklyReportID] ASC)
);


GO

