CREATE TABLE [RequestForInfo].[RFIIssue] (
    [RFIIssueID]       INT           IDENTITY (1, 1) NOT NULL,
    [RequestForInfoID] INT           NULL,
    [Issue]            VARCHAR (MAX) NULL,
    [AddID]            INT           NULL,
    [AddDate]          DATETIME      CONSTRAINT [DF_RFIIssue_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]         INT           NULL,
    [ChangeDate]       DATETIME      NULL,
    [IssueTitle]       VARCHAR (255) NULL,
    CONSTRAINT [PK_RFIIssue] PRIMARY KEY CLUSTERED ([RFIIssueID] ASC)
);


GO

