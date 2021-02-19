CREATE TABLE [RequestForInfo].[RFIResponse] (
    [RFIResponseID]    INT           IDENTITY (1, 1) NOT NULL,
    [RFIIssueID]       INT           NULL,
    [RequestForInfoID] INT           NULL,
    [Response]         VARCHAR (MAX) NULL,
    [AddID]            INT           NULL,
    [AddDate]          DATETIME      CONSTRAINT [DF_RFIResponse_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]         INT           NULL,
    [ChangeDate]       DATETIME      NULL,
    CONSTRAINT [PK_RFIResponse] PRIMARY KEY CLUSTERED ([RFIResponseID] ASC)
);


GO

