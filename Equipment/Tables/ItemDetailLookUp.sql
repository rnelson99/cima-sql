CREATE TABLE [Equipment].[ItemDetailLookUp] (
    [EquipmentItemDetailLookUpID] INT           IDENTITY (1, 1) NOT NULL,
    [LookUpName]                  VARCHAR (100) NULL,
    [DataType]                    VARCHAR (1)   DEFAULT ('T') NOT NULL,
    [ShowOption]                  VARCHAR (1)   DEFAULT ('A') NOT NULL,
    [EquipmentID]                 INT           NULL,
    [AllowDuplicates]             BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EquipmentItemDetailLookUp] PRIMARY KEY CLUSTERED ([EquipmentItemDetailLookUpID] ASC)
);


GO

