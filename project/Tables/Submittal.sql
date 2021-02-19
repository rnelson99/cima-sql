CREATE TABLE [project].[Submittal] (
    [SubmittalID]         INT           IDENTITY (1, 1) NOT NULL,
    [SubmittalNum]        VARCHAR (20)  NULL,
    [CodeID]              INT           NULL,
    [Description]         VARCHAR (255) NULL,
    [AddID]               INT           NULL,
    [AddDate]             DATETIME      CONSTRAINT [DF_Submittal_AddDate] DEFAULT (getdate()) NULL,
    [DetailedDescription] VARCHAR (MAX) NULL,
    [isDelete]            INT           CONSTRAINT [DF_Submittal_isDelete] DEFAULT ((0)) NULL,
    [ChangeID]            INT           NULL,
    [ChangeDate]          DATETIME      CONSTRAINT [DF_Submittal_ChangeDate] DEFAULT (getdate()) NULL,
    [submittalType]       INT           NULL,
    [specsection]         VARCHAR (100) NULL,
    [SubmittalReportID]   INT           NULL,
    [CodeIDType]          INT           NULL,
    [Sorter]              INT           NULL,
    CONSTRAINT [PK_Submittal] PRIMARY KEY CLUSTERED ([SubmittalID] ASC)
);


GO

