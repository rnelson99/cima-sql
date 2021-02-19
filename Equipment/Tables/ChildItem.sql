CREATE TABLE [Equipment].[ChildItem] (
    [EquipmentChildItemID] INT      IDENTITY (1, 1) NOT NULL,
    [ParentEquipmentID]    INT      NOT NULL,
    [ChildEquipmentID]     INT      NULL,
    [AddID]                INT      NULL,
    [AddDate]              DATETIME DEFAULT (getdate()) NULL,
    [EndID]                INT      NULL,
    [EndDate]              DATETIME NULL,
    CONSTRAINT [PK_EquipmentBillinge] PRIMARY KEY CLUSTERED ([EquipmentChildItemID] ASC)
);


GO

