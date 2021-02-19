CREATE VIEW dbo.InvoicePriors AS

WITH AllInvoices(InvoiceId, ProjectId) AS (SELECT     InvoiceID, ProjectID
                                                                                          FROM          dbo.tblInvoice
                                                                                          WHERE      (Status <> 'Void'))
    SELECT     a.ProjectId, a.InvoiceId AS CurrentInvoiceId, CAST(MAX(ISNULL(b.PercentComplete, 0)) AS decimal(18, 2)) AS PercentCompletePrior, 
                            CAST(MAX(ISNULL(b.WorkTotalNew, 0) + ISNULL(b.WorkTotalPrior, 0)) AS money) AS WorkTotalPrior, CAST(SUM(ISNULL(b.StoredNew, 0)) AS money) AS StoredPrior, 
                            CAST(SUM(ISNULL(b.Retainage, 0)) AS money) AS RetainagePrior, CAST(SUM(ISNULL(b.InvoiceGross, 0) - ISNULL(b.Retainage, 0)) AS money) AS PriorBilled, 
                            CAST(SUM(ISNULL(c.Payments, 0)) AS money) AS PaymentsPrior
     FROM         AllInvoices AS a INNER JOIN
                            dbo.tblInvoice AS b ON a.ProjectId = b.ProjectID AND a.InvoiceId > b.InvoiceID LEFT OUTER JOIN
                            dbo.viewInvoicePayments AS c ON b.InvoiceID = c.InvoiceId
     WHERE     (b.Status <> 'Void')
     GROUP BY a.ProjectId, a.InvoiceId

GO

