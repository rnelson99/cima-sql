CREATE TABLE [project].[SubmittalReport] (
    [SubmittalReportID]               INT            IDENTITY (1, 1) NOT NULL,
    [AddID]                           INT            NULL,
    [AddDate]                         DATETIME       NULL,
    [SubmittedDate]                   DATETIME       NULL,
    [ReturnedDate]                    DATETIME       NULL,
    [SubmittalStatus]                 INT            NULL,
    [Status]                          INT            NULL,
    [ProjectID]                       INT            NULL,
    [bicCompanyEntityID]              INT            NULL,
    [bicContactEntityID]              INT            NULL,
    [SubmittalNum]                    VARCHAR (100)  NULL,
    [DueDate]                         DATETIME       NULL,
    [NextAction]                      DATETIME       NULL,
    [Urgency]                         INT            NULL,
    [summary]                         VARCHAR (1000) NULL,
    [SubmittalCompanyEntityID]        INT            NULL,
    [SubmittalCompanyContactEntityID] INT            NULL,
    [ReportSubmitted]                 DATETIME       NULL,
    CONSTRAINT [PK_SubmittalReport] PRIMARY KEY CLUSTERED ([SubmittalReportID] ASC)
);


GO

