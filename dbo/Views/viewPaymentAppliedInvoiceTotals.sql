
CREATE VIEW dbo.viewPaymentAppliedInvoiceTotals AS

	SELECT		InvoiceID, SUM(AmountApply) AS TotalAmountApply
	FROM        dbo.tblPayment INNER JOIN dbo.tblPaymentApplied
				ON dbo.tblPayment.PaymentID = dbo.tblPaymentApplied.PaymentID
	WHERE		(dbo.tblPaymentApplied.IsDeleted = 'N')
				AND (dbo.tblPayment.IsDeleted = 'N')
	GROUP BY	InvoiceID, dbo.tblPaymentApplied.IsDeleted
	HAVING      (NOT (InvoiceID IS NULL))

GO

