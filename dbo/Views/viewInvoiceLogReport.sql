CREATE VIEW dbo.viewInvoiceLogReport AS

	SELECT tblProject.ProjectID, tblProject.ClientID, tblClient.ClientName, tvalProjectStatus.StatusId, tblProject.CIMA_Status, StatusSortOrder, tblProject.ProjectNum, tblProject.ProjectName,
		tblProject.CIMAChargingSalesTax, CAST(ISNULL([SumOfSalesTaxRate],0) AS DECIMAL(18,6))  AS ProjectSalesTax,
		viewPaymentProjectInvoices.InvoiceDate, viewPaymentProjectInvoices.InvoiceNumber, viewPaymentProjectInvoices.InvoiceAmount,
		CASE WHEN CAST(ISNULL([SumOfSalesTaxRate],0) AS DECIMAL(18,6))>0 THEN CAST([InvoiceAmount]/(1+CAST(ISNULL([SumOfSalesTaxRate],0) AS DECIMAL(18,6))) AS MONEY) ELSE 0  END AS Taxable,
		viewProjectSalesTax.SumOfSalesTaxRate
	FROM (((tblProject LEFT JOIN viewProjectSalesTax ON tblProject.ProjectID = viewProjectSalesTax.ProjectID)
		INNER JOIN tblClient ON tblProject.ClientID = tblClient.ClientID)
		INNER JOIN viewPaymentProjectInvoices ON tblProject.ProjectID = viewPaymentProjectInvoices.ProjectID)
		INNER JOIN tvalProjectStatus ON tblProject.CIMA_Status = tvalProjectStatus.CIMA_Status

GO

