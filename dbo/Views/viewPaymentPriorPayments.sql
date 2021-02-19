
CREATE VIEW dbo.viewPaymentPriorPayments AS
	SELECT		tblPayment.ClientID, tblPaymentApplied.InvoiceID, SUM(tblPaymentApplied.AmountApply) AS PriorPayments, tblPaymentApplied.PaymentID
	FROM		tblPayment
				INNER JOIN tblPaymentApplied ON tblPayment.PaymentID = tblPaymentApplied.PaymentID
				INNER JOIN tblInvoice ON tblPaymentApplied.InvoiceID = tblInvoice.InvoiceID
	WHERE		(tblPayment.IsDeleted = 'N')
				AND (ISNULL(tblInvoice.Status,'') <> N'Void')
	GROUP BY	tblPayment.ClientID, tblPaymentApplied.InvoiceID, tblPaymentApplied.PaymentID
	HAVING		(NOT tblPaymentApplied.InvoiceID IS NULL)

GO

