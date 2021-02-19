CREATE TABLE [project].[WeeklyRptLookAhead] (
    [LookAheadID]    INT            IDENTITY (1, 1) NOT NULL,
    [WeeklyReportID] INT            NULL,
    [Comments]       VARCHAR (1000) NULL,
    [AddID]          INT            NULL,
    [AddDate]        DATETIME       NULL,
    [ChangeID]       INT            NULL,
    [ChangeDate]     DATETIME       NULL,
    [status]         INT            NULL,
    CONSTRAINT [PK_WeeklyRptLookAhead] PRIMARY KEY CLUSTERED ([LookAheadID] ASC)
);


GO

