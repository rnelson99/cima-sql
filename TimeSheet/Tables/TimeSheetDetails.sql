CREATE TABLE [TimeSheet].[TimeSheetDetails] (
    [TimeSheetDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [TimesheetID]       INT           NULL,
    [ReferenceID]       INT           NULL,
    [ReferenceType]     INT           NULL,
    [dDate]             DATETIME      NULL,
    [Task]              INT           NULL,
    [Comments]          VARCHAR (200) NULL,
    [Hours]             FLOAT (53)    NULL,
    [AddID]             INT           NULL,
    [AddDate]           DATETIME      NULL,
    [ChangeID]          INT           NULL,
    [ChangeDate]        DATETIME      NULL,
    [Status]            INT           NULL,
    [RowLink]           INT           NULL,
    [WkDay]             INT           NULL,
    [StartDateTime]     DATETIME      NULL,
    [EndDateTime]       DATETIME      NULL,
    [StartGPS]          VARCHAR (100) NULL,
    [EndGPS]            VARCHAR (100) NULL,
    [BHours]            FLOAT (53)    NULL,
    [BillRate]          MONEY         NULL,
    [invoiceID]         INT           NULL,
    [JobClass]          VARCHAR (25)  NULL,
    [ProjectAccounting] INT           NULL,
    CONSTRAINT [PK_TimeSheetDetails] PRIMARY KEY CLUSTERED ([TimeSheetDetailID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190604-173210]
    ON [TimeSheet].[TimeSheetDetails]([TimesheetID] ASC)
    INCLUDE([TimeSheetDetailID]);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20191221-121834]
    ON [TimeSheet].[TimeSheetDetails]([ReferenceID] ASC, [Status] ASC);


GO

