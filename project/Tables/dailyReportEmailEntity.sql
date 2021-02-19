CREATE TABLE [project].[dailyReportEmailEntity] (
    [id]         INT      IDENTITY (1, 1) NOT NULL,
    [entityID]   INT      NULL,
    [projectID]  INT      NULL,
    [addID]      INT      NULL,
    [addDate]    DATETIME NULL,
    [changeDate] DATETIME NULL,
    [changeID]   INT      NULL,
    [status]     INT      NULL,
    CONSTRAINT [PK_dailyReportEmailEntity] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

