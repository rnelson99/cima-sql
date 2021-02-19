CREATE TABLE [dbo].[tblProjectBillingSchedule] (
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    [ProjectId]         INT             NOT NULL,
    [OwnerPayAppNumber] INT             NOT NULL,
    [ScheduledDate]     DATETIME        NULL,
    [MilestoneId]       INT             NOT NULL,
    [AdjustedDays]      INT             DEFAULT ((0)) NOT NULL,
    [ScheduledAmount]   MONEY           NULL,
    [ScheduledPercent]  DECIMAL (18, 2) NULL,
    [RetainageHold]     BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [ProjectBillingSchedule_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

