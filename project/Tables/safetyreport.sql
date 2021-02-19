CREATE TABLE [project].[safetyreport] (
    [SafetyReportID] INT           IDENTITY (1, 1) NOT NULL,
    [projectid]      INT           NULL,
    [addid]          INT           NULL,
    [adddate]        DATETIME      CONSTRAINT [DF_safetyreport_adddate] DEFAULT (getdate()) NULL,
    [comments]       VARCHAR (MAX) NULL,
    [weekEnding]     DATETIME      NULL,
    [submitted]      INT           DEFAULT ((0)) NULL,
    [sumitteddate]   DATETIME      NULL,
    CONSTRAINT [PK_safetyreport] PRIMARY KEY CLUSTERED ([SafetyReportID] ASC)
);


GO

