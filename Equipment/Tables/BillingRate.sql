CREATE TABLE [Equipment].[BillingRate] (
    [EquipmentBillingRateID] INT      IDENTITY (1, 1) NOT NULL,
    [EquipmentID]            INT      NOT NULL,
    [BillingRate]            MONEY    NULL,
    [BillingRateType]        INT      NULL,
    [AddID]                  INT      NULL,
    [AddDate]                DATETIME DEFAULT (getdate()) NULL,
    [ChangeID]               INT      NULL,
    [ChangeDate]             DATETIME NULL,
    CONSTRAINT [PK_EquipmentBillingRate] PRIMARY KEY CLUSTERED ([EquipmentBillingRateID] ASC)
);


GO

