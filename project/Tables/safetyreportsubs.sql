CREATE TABLE [project].[safetyreportsubs] (
    [SafetyReportSubID] INT           IDENTITY (1, 1) NOT NULL,
    [SafetyReportID]    INT           NULL,
    [EntityID]          INT           NULL,
    [AddID]             INT           NULL,
    [AddDate]           DATETIME      CONSTRAINT [DF_safetyreportsubs_AddDate] DEFAULT (getdate()) NULL,
    [Comments]          VARCHAR (MAX) NULL,
    CONSTRAINT [PK_safetyreportsubs] PRIMARY KEY CLUSTERED ([SafetyReportSubID] ASC)
);


GO

