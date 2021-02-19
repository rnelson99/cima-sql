CREATE VIEW [dbo].[viewPaymentProjectInvoices] AS

	SELECT		 tblProject.ClientID
				,tblInvoice.ProjectID
				,tblProject.ProjectNum
				,tblInvoice.InvoiceID
				,tblInvoice.InvoiceNumber
				,tblInvoice.InvoiceDate				
				,CASE WHEN InvoiceStatus='Interim' THEN ISNULL(tblInvoice.InvoiceGross,0) - ISNULL(tblInvoice.Retainage, 0) ELSE ISNULL(RemainingUnbilled,0) END AS InvoiceAmount
				,tblInvoice.OwnerPayAppNumber
	FROM         tblInvoice
				 INNER JOIN tblProject ON tblInvoice.ProjectID = tblProject.ProjectID
	WHERE		(tblInvoice.Status <> 'Void')

GO

