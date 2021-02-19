CREATE TABLE [dbo].[tblPWADetailCost] (
    [PWADetailCostID]           INT           IDENTITY (1, 1) NOT NULL,
    [PWALogID]                  INT           NOT NULL,
    [ProjectID]                 INT           NOT NULL,
    [VendorID]                  INT           NOT NULL,
    [ItemName]                  VARCHAR (255) NULL,
    [ItemQuantity]              INT           DEFAULT ((1)) NOT NULL,
    [ItemUnitDescription]       VARCHAR (255) NULL,
    [ItemUnitPrice]             MONEY         NULL,
    [ItemTotalPrice_CALC]       MONEY         NULL,
    [ItemPricingType]           VARCHAR (255) NULL,
    [PWADetailCostLastModified] DATETIME      NULL,
    [RV]                        ROWVERSION    NOT NULL,
    [codeID]                    INT           NULL,
    [status]                    INT           CONSTRAINT [DF_tblPWADetailCost_status] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblPWADetailCost] PRIMARY KEY CLUSTERED ([PWADetailCostID] ASC)
);


GO

