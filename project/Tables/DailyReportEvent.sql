CREATE TABLE [project].[DailyReportEvent] (
    [EventID]       INT            IDENTITY (1, 1) NOT NULL,
    [DailyReportID] INT            NULL,
    [Company]       VARCHAR (1000) NULL,
    [Name]          VARCHAR (1000) NULL,
    [EventType]     VARCHAR (1000) NULL,
    [Details]       VARCHAR (1000) NULL,
    [AddID]         INT            NULL,
    [AddDate]       DATETIME       NULL,
    [ChangeID]      INT            NULL,
    [ChangeDate]    DATETIME       NULL,
    [Status]        INT            NULL,
    [isRevised]     INT            NULL,
    [hasHeir]       INT            NULL,
    CONSTRAINT [PK_ProjectDailyEvent] PRIMARY KEY CLUSTERED ([EventID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[DailyReportEvent]([DailyReportID] ASC);


GO

