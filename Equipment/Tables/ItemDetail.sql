CREATE TABLE [Equipment].[ItemDetail] (
    [EquipmentItemDetailID]       INT           IDENTITY (1, 1) NOT NULL,
    [EquipmentID]                 INT           NULL,
    [EquipmentItemDetailLookUpID] INT           NULL,
    [ItemDetailValue]             VARCHAR (100) NULL,
    [OtherItemDetailValue1]       VARCHAR (100) NULL,
    [OtherItemDetailValue2]       VARCHAR (100) NULL,
    [AddID]                       INT           NULL,
    [AddDate]                     DATETIME      DEFAULT (getdate()) NULL,
    [ChangeID]                    INT           NULL,
    [ChangeDate]                  DATETIME      NULL,
    [ItemDetailShowApp]           BIT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_EquipmentItemDetail] PRIMARY KEY CLUSTERED ([EquipmentItemDetailID] ASC)
);


GO

