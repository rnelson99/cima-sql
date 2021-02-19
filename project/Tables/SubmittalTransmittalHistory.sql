CREATE TABLE [project].[SubmittalTransmittalHistory] (
    [SubmittalTransmitID] INT          IDENTITY (1, 1) NOT NULL,
    [AddDate]             DATETIME     CONSTRAINT [DF_SubmittalTransmittalHistory_AddDate] DEFAULT (getdate()) NULL,
    [Status]              INT          NULL,
    [AddID]               INT          NULL,
    [SubmittalReportID]   INT          NULL,
    [StatusDesc]          VARCHAR (50) NULL,
    [documentid]          INT          NULL,
    [smashed]             INT          NULL,
    CONSTRAINT [PK_SubmittalTransmittalHistory] PRIMARY KEY CLUSTERED ([SubmittalTransmitID] ASC)
);


GO

