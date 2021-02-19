CREATE VIEW viewBillableChanges AS

	SELECT	b.InvoiceID, a.Description AS ItemName, 'Change Order ' + LTRIM(CAST(a.OCORev AS varchar(7))) AS ItemDescription, a.Price AS Amount, 1 AS Created, a.ChangeOrderID AS OCOId, a.OCORev
	FROM	dbo.viewChangeOrders AS a INNER JOIN
			dbo.tblInvoice AS b ON a.ProjectID = b.ProjectID LEFT OUTER JOIN
			dbo.tblInvoiceDetail AS c ON c.InvoiceID = b.InvoiceID AND c.OCOId = a.ChangeOrderID
	WHERE	(c.InvoiceDetailID IS NULL) AND (a.Status = 'Approved')

GO

