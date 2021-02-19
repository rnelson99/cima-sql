CREATE TABLE [Equipment].[Billing] (
    [EquipmentBillingID] INT      IDENTITY (1, 1) NOT NULL,
    [EquipmentID]        INT      NOT NULL,
    [ProjectID]          INT      NULL,
    [DateFrom]           DATETIME NULL,
    [DateTo]             DATETIME NULL,
    [BillingRate]        MONEY    NULL,
    [BillingRateType]    INT      NULL,
    [AddID]              INT      NULL,
    [AddDate]            DATETIME DEFAULT (getdate()) NULL,
    [ChangeID]           INT      NULL,
    [ChangeDate]         DATETIME NULL,
    CONSTRAINT [PK_EquipmentBilling] PRIMARY KEY CLUSTERED ([EquipmentBillingID] ASC)
);


GO

