CREATE TABLE [project].[DailyReportDescripition] (
    [DescripitionID] INT           IDENTITY (1, 1) NOT NULL,
    [DailyReportID]  INT           NULL,
    [Subcontractor]  INT           NULL,
    [Descripition]   VARCHAR (MAX) NULL,
    [AddID]          INT           NULL,
    [AddDate]        DATETIME      NULL,
    [ChangeID]       INT           NULL,
    [ChangeDate]     DATETIME      NULL,
    [Status]         INT           NULL,
    [isRevised]      INT           NULL,
    [hasHeir]        INT           NULL,
    CONSTRAINT [PK_DailyReportDescripition] PRIMARY KEY CLUSTERED ([DescripitionID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportDescription_DailyReportID]
    ON [project].[DailyReportDescripition]([DailyReportID] ASC);


GO

