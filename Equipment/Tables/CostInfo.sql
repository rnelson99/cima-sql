CREATE TABLE [Equipment].[CostInfo] (
    [EquipmentCostInfoID] INT          IDENTITY (1, 1) NOT NULL,
    [EquipmentID]         INT          NOT NULL,
    [CostEvent]           VARCHAR (50) NULL,
    [UsedValue]           MONEY        NULL,
    [BookValue]           MONEY        NULL,
    [ReplacementCost]     MONEY        NULL,
    [CostDate]            DATETIME     NULL,
    [AddID]               INT          NULL,
    [AddDate]             DATETIME     DEFAULT (getdate()) NULL,
    [ChangeID]            INT          NULL,
    [ChangeDate]          DATETIME     NULL,
    [CostInfoShowApp]     BIT          DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EquipmentCostInfo] PRIMARY KEY CLUSTERED ([EquipmentCostInfoID] ASC)
);


GO

