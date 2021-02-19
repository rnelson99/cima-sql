
CREATE VIEW dbo.viewPaymentAppliedProjects AS
	SELECT		tblPaymentApplied.PaymentAppliedID, tblPaymentApplied.PaymentID, tblPaymentApplied.InvoiceID, tblPaymentApplied.ProjectID, tblProject.ProjectNum, tblProject.ClientID, 
				tblPaymentApplied.AmountApply
	FROM		tblProject
				INNER JOIN tblPaymentApplied ON tblProject.ProjectID = tblPaymentApplied.ProjectID
				INNER JOIN tblPayment ON tblPayment.PaymentID = tblPaymentApplied.PaymentID
				INNER JOIN tblClient ON tblProject.ClientID = tblClient.ClientID
				LEFT OUTER JOIN tblInvoice ON tblPaymentApplied.InvoiceID = tblInvoice.InvoiceID
	WHERE		(tblPaymentApplied.IsDeleted = 'N')
				AND (tblPayment.IsDeleted = 'N')
				AND (ISNULL(tblInvoice.Status,'') <> N'Void')

GO

