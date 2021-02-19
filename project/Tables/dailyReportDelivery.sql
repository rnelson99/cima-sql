CREATE TABLE [project].[dailyReportDelivery] (
    [DeliveryID]    INT           IDENTITY (1, 1) NOT NULL,
    [DailyReportID] INT           NULL,
    [DeliveryType]  VARCHAR (500) NULL,
    [Company]       VARCHAR (500) NULL,
    [Carrier]       VARCHAR (500) NULL,
    [Condition]     VARCHAR (500) NULL,
    [AddID]         INT           NULL,
    [AddDate]       DATETIME      NULL,
    [ChangeID]      INT           NULL,
    [ChangeDate]    DATETIME      NULL,
    [Status]        INT           NULL,
    [Label]         INT           NULL,
    [isRevised]     INT           NULL,
    [hasHeir]       INT           NULL,
    CONSTRAINT [PK_dailyReportDelivery] PRIMARY KEY CLUSTERED ([DeliveryID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[dailyReportDelivery]([DailyReportID] ASC)
    INCLUDE([DeliveryID]);


GO

