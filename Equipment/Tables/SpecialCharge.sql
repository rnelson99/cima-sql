CREATE TABLE [Equipment].[SpecialCharge] (
    [EquipmentSpecialChargeID] INT          IDENTITY (1, 1) NOT NULL,
    [EquipmentID]              INT          NOT NULL,
    [SpecialChargeName]        VARCHAR (50) NULL,
    [SpecialCharge]            MONEY        NULL,
    [AddID]                    INT          NULL,
    [AddDate]                  DATETIME     DEFAULT (getdate()) NULL,
    [ChangeID]                 INT          NULL,
    [ChangeDate]               DATETIME     NULL,
    CONSTRAINT [PK_EquipmentSpecialCharge] PRIMARY KEY CLUSTERED ([EquipmentSpecialChargeID] ASC)
);


GO

