

CREATE VIEW viewApprovedChangeOrderValues
AS
SELECT a.ProjectId, a.ChangeOrderId, a.ChangeOrderSequence,
Sum(isnull(qty,0) * isnull(unitprice,0)) as Price
FROM  viewOrderedApprovedChangeOrders a JOIN tblChangeOrderDetail b
ON a.ChangeOrderId =b.ChangeOrderId
GROUP BY a.ProjectId, a.ChangeOrderId, a.ChangeOrderSequence

GO

