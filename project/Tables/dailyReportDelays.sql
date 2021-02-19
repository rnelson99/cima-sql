CREATE TABLE [project].[dailyReportDelays] (
    [DelayID]       INT           IDENTITY (1, 1) NOT NULL,
    [DailyReportID] INT           NULL,
    [startDate]     DATETIME      NULL,
    [endDate]       DATETIME      NULL,
    [Summary]       VARCHAR (250) NULL,
    [AddID]         INT           NULL,
    [AddDate]       DATETIME      NULL,
    [ChangeID]      INT           NULL,
    [ChangeDate]    DATETIME      NULL,
    [Status]        INT           NULL,
    [AffectedSubs]  VARCHAR (100) NULL,
    [AllSchedule]   INT           NULL,
    [isRevised]     INT           NULL,
    [hasHeir]       INT           NULL,
    [ProjectID]     INT           NULL,
    CONSTRAINT [PK_dailyReportDelays] PRIMARY KEY CLUSTERED ([DelayID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[dailyReportDelays]([DailyReportID] ASC)
    INCLUDE([DelayID]);


GO

