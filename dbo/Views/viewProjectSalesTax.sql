CREATE VIEW dbo.viewProjectSalesTax AS

SELECT tblProjectSalesTax.ProjectID, Sum(tblProjectSalesTax.SalesTaxRate) AS SumOfSalesTaxRate
FROM tblProjectSalesTax
GROUP BY tblProjectSalesTax.ProjectID

GO

