CREATE TABLE [dbo].[tblProjectBidIncExc] (
    [BidAdditionalId]    INT            NULL,
    [ProjectID]          INT            NULL,
    [VendorID]           INT            NULL,
    [Item]               VARCHAR (100)  NULL,
    [Comments]           VARCHAR (1000) NULL,
    [AddID]              INT            NULL,
    [AddDate]            DATETIME       NULL,
    [ChangeID]           INT            NULL,
    [ChangeDate]         DATETIME       NULL,
    [Type]               TINYINT        NULL,
    [Cost]               MONEY          NULL,
    [SalesTaxInc]        BIT            NULL,
    [LaborMaterial]      TINYINT        NULL,
    [IncInBidComparison] BIT            NULL
);


GO

