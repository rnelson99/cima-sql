CREATE TABLE [project].[ProjectSettings] (
    [ProjectSettingID]   INT      IDENTITY (1, 1) NOT NULL,
    [MaxFileSize]        INT      CONSTRAINT [DF_ProjectSettings_MaxFileSize] DEFAULT ((6144)) NULL,
    [LookAhead]          INT      CONSTRAINT [DF_ProjectSettings_LookAhead] DEFAULT ((1)) NULL,
    [StartOfReport]      INT      CONSTRAINT [DF_ProjectSettings_StartOfReport] DEFAULT ((2)) NULL,
    [ReportDueDate]      INT      CONSTRAINT [DF_ProjectSettings_ReportDueDate] DEFAULT ((3)) NULL,
    [ProjectID]          INT      NULL,
    [AddID]              INT      NULL,
    [AddDate]            DATETIME CONSTRAINT [DF_ProjectSettings_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]           INT      NULL,
    [ChangeDate]         DATETIME NULL,
    [Status]             INT      NULL,
    [WkRptSubmittalLog]  INT      NULL,
    [WkRptRFILog]        INT      NULL,
    [WkRptShowDelays]    INT      NULL,
    [hideCompletionDate] INT      NULL,
    [cimaPM]             INT      NULL,
    [cimaPX]             INT      NULL,
    [cimaSuper]          INT      NULL,
    [clientPM]           INT      NULL,
    CONSTRAINT [PK_ProjectSettings] PRIMARY KEY CLUSTERED ([ProjectSettingID] ASC)
);


GO

