CREATE TABLE [dbo].[tblProjectSalesTax] (
    [Id]               INT             IDENTITY (1, 1) NOT NULL,
    [ProjectID]        INT             NOT NULL,
    [JurisdictionName] VARCHAR (50)    NOT NULL,
    [LocalCode]        VARCHAR (50)    NULL,
    [SalesTaxRate]     DECIMAL (18, 6) NOT NULL,
    [LastModified]     DATETIME        NOT NULL,
    [addid]            INT             NULL,
    [adddate]          DATETIME        CONSTRAINT [DF_tblProjectSalesTax_adddate] DEFAULT (getdate()) NULL,
    CONSTRAINT [tblProjectSalesTax_PK] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO

--
--  Add UPDATE trigger to tblProjectSalesTax to update LastModified
CREATE TRIGGER salesTaxLastModified
ON dbo.tblProjectSalesTax
AFTER  UPDATE
AS 
BEGIN
	UPDATE dbo.tblProjectSalesTax SET LastModified = getdate()
END;

GO

