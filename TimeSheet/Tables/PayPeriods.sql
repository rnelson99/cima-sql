CREATE TABLE [TimeSheet].[PayPeriods] (
    [PayPeriodID] INT      IDENTITY (1, 1) NOT NULL,
    [PeriodStart] DATETIME NULL,
    [PeriodEnd]   DATETIME NULL,
    [PayDate]     DATETIME NULL,
    CONSTRAINT [PK_PayPeriods] PRIMARY KEY CLUSTERED ([PayPeriodID] ASC)
);


GO

