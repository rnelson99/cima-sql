CREATE TABLE [dbo].[Deprecated.tblClientOwnerAppSchedule] (
    [Id]                INT             IDENTITY (1, 1) NOT NULL,
    [ClientId]          INT             NOT NULL,
    [ownerPayAppNumber] INT             NOT NULL,
    [milestoneId]       INT             NOT NULL,
    [adjustedDays]      INT             DEFAULT ((0)) NOT NULL,
    [scheduledAmount]   MONEY           NULL,
    [scheduledPercent]  DECIMAL (18, 2) NULL,
    [retainageHold]     BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [tblClientOwnerAppSchedule_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

