CREATE TABLE [project].[safetyreportdetail] (
    [safereportdetailid] INT           IDENTITY (1, 1) NOT NULL,
    [SafetyReportID]     INT           NULL,
    [question]           INT           NULL,
    [answer]             INT           NULL,
    [datecorrected]      DATETIME      NULL,
    [comments]           VARCHAR (MAX) NULL,
    [addid]              INT           NULL,
    [adddate]            DATETIME      NULL,
    CONSTRAINT [PK_safetyreportdetail] PRIMARY KEY CLUSTERED ([safereportdetailid] ASC)
);


GO

