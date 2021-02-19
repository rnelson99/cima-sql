CREATE TABLE [Equipment].[Condition] (
    [EquipmentConditionID] INT      IDENTITY (1, 1) NOT NULL,
    [EquipmentID]          INT      NULL,
    [Condition]            INT      NULL,
    [AddID]                INT      NULL,
    [AddDate]              DATETIME NULL,
    [Active]               INT      NULL,
    CONSTRAINT [PK_Condition] PRIMARY KEY CLUSTERED ([EquipmentConditionID] ASC)
);


GO

