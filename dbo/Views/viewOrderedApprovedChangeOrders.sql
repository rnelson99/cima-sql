
CREATE View
viewOrderedApprovedChangeOrders
AS
SELECT ProjectId, ChangeOrderId, BillingStatus,
ROW_NUMBER() OVER (PARTITION BY ProjectId ORDER BY ChangeNum) AS ChangeOrderSequence
FROM tblChangeOrder 
WHERE BillingStatus='Approved'

GO

