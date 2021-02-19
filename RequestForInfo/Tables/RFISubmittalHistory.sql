CREATE TABLE [RequestForInfo].[RFISubmittalHistory] (
    [RFISubmittalHistoryID] INT      IDENTITY (1, 1) NOT NULL,
    [RequestForInfoID]      INT      NULL,
    [RFIStatus]             INT      NULL,
    [EntityID]              INT      NULL,
    [AddID]                 INT      NULL,
    [AddDate]               DATETIME CONSTRAINT [DF_RFISubmittalHistory_AddDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_RFISubmittalHistory] PRIMARY KEY CLUSTERED ([RFISubmittalHistoryID] ASC)
);


GO

