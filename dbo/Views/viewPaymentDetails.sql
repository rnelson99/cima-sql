
CREATE VIEW dbo.viewPaymentDetails AS
	SELECT		tblPayment.PaymentID, tblPayment.ClientID, tblPayment.Amount, tblPayment.DatePay, tblPayment.PaymentTypeID, tblPayment.ProViewAccountID, tblPayment.Notes, 
				tblPayment.IsDeleted, tblPayment.CreatedOn, tblPayment.CreatedUser, tblPayment.ModifiedLast, tblPayment.UpdatedUser, tblPayment.CheckNumber, tblPaymentApplied.InvoiceID, 
				tblPaymentApplied.ProjectID, tblPaymentApplied.AmountApply, tblPaymentApplied.IsDeleted AS AppliedIsDeleted, tblPaymentApplied.PaymentAppliedDate, 
				tlkpPaymentType.PaymentTypeDescription, tblProViewAccount.ProViewAccountName
	FROM		tblPayment
				INNER JOIN tblPaymentApplied ON tblPayment.PaymentID = tblPaymentApplied.PaymentID
				LEFT OUTER JOIN tblInvoice ON tblPaymentApplied.InvoiceID = tblInvoice.InvoiceID
				LEFT OUTER JOIN tblProViewAccount ON tblPayment.ProViewAccountID = tblProViewAccount.ProViewAccountID
				LEFT OUTER JOIN tlkpPaymentType ON tblPayment.PaymentTypeID = tlkpPaymentType.PaymentTypeID
	WHERE		(ISNULL(tblInvoice.Status,'') <> N'Void')

GO

