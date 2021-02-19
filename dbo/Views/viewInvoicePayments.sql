

CREATE VIEW viewInvoicePayments
AS
SELECT InvoiceId, Sum(AmountApply) as Payments
FROM viewPaymentAppliedProjects
GROUP BY InvoiceId

GO

