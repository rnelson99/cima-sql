CREATE TABLE [dbo].[tblChangeOrderDetail] (
    [ScopeItem]                 NVARCHAR (MAX)  NULL,
    [Qty]                       DECIMAL (16, 2) NULL,
    [Unit]                      NVARCHAR (15)   NULL,
    [UnitPrice]                 MONEY           NULL,
    [TotalPrice_CALC]           MONEY           NULL,
    [CIMACost]                  MONEY           NULL,
    [ChangeOrderDetailID]       INT             IDENTITY (1, 1) NOT NULL,
    [ChangeOrderID]             INT             NULL,
    [MasterConstDivCodeID]      INT             NULL,
    [OverHeadAndProfitLineItem] BIT             DEFAULT ((0)) NOT NULL,
    [SortOrder]                 INT             NULL,
    [SalesTaxLineItem]          BIT             DEFAULT ((0)) NOT NULL,
    [SubcontractorId]           INT             NULL,
    [SCOId]                     INT             NULL,
    [SCO]                       BIT             DEFAULT ((0)) NOT NULL,
    [RV]                        ROWVERSION      NOT NULL,
    [addID]                     INT             NULL,
    [changeID]                  INT             NULL,
    [adddate]                   DATETIME        NULL,
    [changedate]                DATETIME        NULL,
    [vendorEntityID]            INT             NULL,
    [Status]                    INT             DEFAULT ((1)) NULL,
    [PWADetailCostId]           INT             NULL,
    CONSTRAINT [ProjectChangeOrderDetailsID] PRIMARY KEY CLUSTERED ([ChangeOrderDetailID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20191221-135656]
    ON [dbo].[tblChangeOrderDetail]([ChangeOrderID] ASC)
    INCLUDE([ChangeOrderDetailID]);


GO

