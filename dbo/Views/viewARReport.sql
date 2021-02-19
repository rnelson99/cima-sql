CREATE VIEW dbo.viewARReport AS

	SELECT tblProject.ProjectID, tblProject.ClientID, tblClient.ClientName, tblProject.CIMA_Status, tblProject.ProjectNum,
		tblProject.ProjectName, viewPaymentProjectInvoices.InvoiceDate, viewPaymentProjectInvoices.InvoiceNumber, tvalProjectStatus.StatusId, tvalProjectStatus.StatusSortOrder,
		viewPaymentProjectInvoices.InvoiceAmount, viewPaymentAppliedInvoiceTotals.TotalAmountApply, ([InvoiceAmount]-ISNULL([TotalAmountApply],0)) AS Balance
	FROM (((tblProject INNER JOIN tblClient ON tblProject.ClientID = tblClient.ClientID)
		INNER JOIN viewPaymentProjectInvoices ON tblProject.ProjectID = viewPaymentProjectInvoices.ProjectID)
		INNER JOIN tvalProjectStatus ON tblProject.CIMA_Status = tvalProjectStatus.CIMA_Status)
		LEFT JOIN viewPaymentAppliedInvoiceTotals ON viewPaymentProjectInvoices.InvoiceID = viewPaymentAppliedInvoiceTotals.InvoiceID
	WHERE ([InvoiceAmount]-ISNULL([TotalAmountApply],0)>0.01)

GO

