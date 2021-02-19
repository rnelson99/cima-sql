CREATE TABLE [project].[WeeklyReportProgress] (
    [ProgressID]     INT            IDENTITY (1, 1) NOT NULL,
    [Comments]       VARCHAR (1000) NULL,
    [WeeklyReportID] INT            NULL,
    [AddID]          INT            NULL,
    [AddDate]        DATETIME       NULL,
    [ChangeID]       INT            NULL,
    [ChangeDate]     DATETIME       NULL,
    [Rainhours]      INT            NULL,
    [status]         INT            NULL,
    [dDate]          DATETIME       NULL,
    CONSTRAINT [PK_WeeklyReportProgress] PRIMARY KEY CLUSTERED ([ProgressID] ASC)
);


GO

