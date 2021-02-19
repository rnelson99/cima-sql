CREATE TABLE [project].[ProjectLevel] (
    [ProjectPunchLevelID] INT         IDENTITY (1, 1) NOT NULL,
    [ProjectID]           INT         NULL,
    [ProjectType]         VARCHAR (1) NULL,
    [lvl]                 INT         NULL,
    [Status]              INT         NULL,
    [AddID]               INT         NULL,
    [AddDate]             DATETIME    CONSTRAINT [DF_ProjectLevel_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]            INT         NULL,
    [ChangeDate]          DATETIME    NULL,
    CONSTRAINT [PK_ProjectLevel] PRIMARY KEY CLUSTERED ([ProjectPunchLevelID] ASC)
);


GO

