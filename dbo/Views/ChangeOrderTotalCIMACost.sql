


/*
    Author    : lolt
    Date      : 4/8/2014
    Purpose   : Get the Total of ChangeOrders
    by ProjectId and MasterConstDivCodeId.
    When summing Change Orders, only include Billing Status = Approved
    7-Aug-2014, add sales tax
*/
CREATE VIEW [dbo].[ChangeOrderTotalCIMACost]
AS
SELECT b.projectId,d.ProjectNum,b.changenum, c.ConstructionDivCode, a.MasterConstDivCodeID,b.GCOHPPercent,
Sum(ISNULL(Qty,0) * ISNULL(UnitPrice,0)) as Price,ISNULL(dbo.ProjectSalesTax(b.ProjectId),0) as TaxRate,
Sum(a.CIMACost) as CIMACost,Sum(TotalPrice_CALC) as TotalPrice_CALC,
SUM(
 CASE WHEN SalesTaxLineItem=0 AND ISNULL(Unit,'') <>'%' THEN
      (ISNULL(dbo.ProjectSalesTax(b.ProjectId),0) *  (1+GCOHPPercent/100 )* (ISNULL(Qty,0) * ISNULL(UnitPrice,0))) + CIMACost
 ELSE
      0 
 END )AS CostInclTax
FROM tblChangeOrderDetail a JOIN tblChangeOrder b ON a.ChangeOrderId = b.ChangeOrderId
JOIN dbo.tblConstDivCodes c ON a.MasterConstDivCodeID=c.codeid
JOIN dbo.tblProject d ON b.projectid=d.projectid
WHERE  b.BillingStatus IN ('Approved','Verbally Approved') AND b.ProjectId > 0
   AND CIMACost <> 0
   GROUP BY b.projectId,d.ProjectNum,b.changenum,c.ConstructionDivCode,  a.MasterConstDivCodeID,
   b.GCOHPPercent,ISNULL(dbo.ProjectSalesTax(b.ProjectId),0)

GO

