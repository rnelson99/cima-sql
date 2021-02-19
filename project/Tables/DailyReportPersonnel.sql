CREATE TABLE [project].[DailyReportPersonnel] (
    [PersonnelID]   INT            IDENTITY (1, 1) NOT NULL,
    [DailyReportID] INT            NULL,
    [Personnel]     INT            NULL,
    [ManHours]      FLOAT (53)     NULL,
    [Trade]         VARCHAR (1000) NULL,
    [Subcontractor] INT            NULL,
    [Descripition]  VARCHAR (1000) NULL,
    [AddID]         INT            NULL,
    [AddDate]       DATETIME       NULL,
    [ChangeID]      INT            NULL,
    [ChangeDate]    DATETIME       NULL,
    [Status]        INT            NULL,
    [isSecond]      INT            NULL,
    [isRevised]     INT            NULL,
    [hasHeir]       INT            NULL,
    [NonListedSub]  VARCHAR (1000) NULL,
    CONSTRAINT [PK_ProjectDailyPersonnel] PRIMARY KEY CLUSTERED ([PersonnelID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[DailyReportPersonnel]([DailyReportID] ASC)
    INCLUDE([PersonnelID], [Subcontractor]);


GO

