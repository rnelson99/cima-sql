CREATE TABLE [RequestForInfo].[RFIList] (
    [RequestForInfoID]   INT           IDENTITY (1, 1) NOT NULL,
    [Summary]            VARCHAR (255) NULL,
    [ProjectID]          INT           NULL,
    [Status]             INT           NULL,
    [Urgency]            INT           NULL,
    [RespondByDate]      DATETIME      NULL,
    [ProposedResolution] VARCHAR (MAX) NULL,
    [IsDraft]            BIT           CONSTRAINT [DF_RFIList_IsDraft] DEFAULT ((0)) NOT NULL,
    [AddID]              INT           NULL,
    [AddDate]            DATETIME      CONSTRAINT [DF_RFIList_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]           INT           NULL,
    [ChangeDate]         DATETIME      NULL,
    [CurrentOwner]       INT           NULL,
    CONSTRAINT [PK_RFIList] PRIMARY KEY CLUSTERED ([RequestForInfoID] ASC)
);


GO

