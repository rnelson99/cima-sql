CREATE VIEW dbo.viewChangeOrderDetail AS
	--
	-- Created: 2016-02-01 - Butz
	-- FB 191 - Update SCO and Sub Pay Apps 
	SELECT	tblChangeOrder.ChangeOrderID, tblChangeOrderDetail.ChangeOrderDetailID
			, tblChangeOrder.ProjectID, tblChangeOrder.BillingStatus
			, tblChangeOrder.ChangeNum, tblChangeOrder.ChangeNumRev, tblChangeOrder.ChangeOrderNumRevision
			, tblChangeOrderDetail.Qty, tblChangeOrderDetail.UnitPrice, tblChangeOrderDetail.CIMACost
			, ISNULL(tblChangeOrderDetail.Qty, 0) * ISNULL(tblChangeOrderDetail.UnitPrice, 0) AS TotalPrice_CALC
			, tblChangeOrderDetail.MasterConstDivCodeID, tblChangeOrderDetail.SubcontractorId
			, tblChangeOrderDetail.SCOId
	FROM	tblChangeOrder
			INNER JOIN tblChangeOrderDetail ON tblChangeOrder.ChangeOrderID=tblChangeOrderDetail.ChangeOrderID
	WHERE	(tblChangeOrder.IsDeleted='N')

GO

