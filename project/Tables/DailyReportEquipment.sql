CREATE TABLE [project].[DailyReportEquipment] (
    [EquipmentID]   INT           IDENTITY (1, 1) NOT NULL,
    [DailyReportID] INT           NULL,
    [Equipment]     VARCHAR (500) NULL,
    [Quantity]      INT           NULL,
    [AddID]         INT           NULL,
    [AddDate]       DATETIME      NULL,
    [ChangeID]      INT           NULL,
    [ChangeDate]    DATETIME      NULL,
    [Status]        INT           NULL,
    [isRevised]     INT           NULL,
    [hasHeir]       INT           NULL,
    [companyid]     INT           NULL,
    [company]       VARCHAR (200) NULL,
    [hours]         INT           NULL,
    CONSTRAINT [PK_ProjectDailyEquipment] PRIMARY KEY CLUSTERED ([EquipmentID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IND_DailyReportID]
    ON [project].[DailyReportEquipment]([DailyReportID] ASC)
    INCLUDE([EquipmentID]);


GO

