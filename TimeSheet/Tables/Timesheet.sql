CREATE TABLE [TimeSheet].[Timesheet] (
    [TimeSheetID]       INT      IDENTITY (1, 1) NOT NULL,
    [EntityID]          INT      NULL,
    [StartDate]         DATETIME NULL,
    [AddDate]           DATETIME NULL,
    [AddID]             INT      NULL,
    [Status]            INT      NULL,
    [beenSubmitted]     INT      DEFAULT ((0)) NULL,
    [InQueue]           INT      NULL,
    [Approver1]         INT      NULL,
    [Approver1DateTime] DATETIME NULL,
    [Approver2]         INT      NULL,
    [Approver2DateTime] DATETIME NULL,
    [payrollProcessed]  DATETIME NULL,
    CONSTRAINT [PK_Timesheet] PRIMARY KEY CLUSTERED ([TimeSheetID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190604-173239]
    ON [TimeSheet].[Timesheet]([EntityID] ASC)
    INCLUDE([TimeSheetID]);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190620-084107]
    ON [TimeSheet].[Timesheet]([EntityID] ASC, [Status] ASC)
    INCLUDE([TimeSheetID]);


GO

