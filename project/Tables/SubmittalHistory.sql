CREATE TABLE [project].[SubmittalHistory] (
    [historyID]         INT      IDENTITY (1, 1) NOT NULL,
    [SubmittalID]       INT      NULL,
    [SubmittalStatus]   INT      NULL,
    [bicCompany]        INT      NULL,
    [bicContact]        INT      NULL,
    [StartDateTime]     DATETIME NULL,
    [EndDateTime]       DATETIME NULL,
    [status]            INT      NULL,
    [eta]               DATETIME NULL,
    [reminder]          DATETIME NULL,
    [addid]             INT      NULL,
    [changeid]          INT      NULL,
    [adddate]           DATETIME NULL,
    [changedate]        DATETIME NULL,
    [SubmittalReportID] INT      NULL,
    [SubmittedDate]     DATETIME NULL,
    [DueDate]           DATETIME NULL,
    [ReturnedDate]      DATETIME NULL,
    [NextAction]        DATETIME NULL,
    CONSTRAINT [PK_SubmittalHistory] PRIMARY KEY CLUSTERED ([historyID] ASC)
);


GO

