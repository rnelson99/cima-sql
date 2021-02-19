
/* Set Billing Start Date for tblInvoice  */
CREATE VIEW viewInvoiceStartDates
AS
WITH InvoiceRank (ProjectId, InvoiceId, InvoiceDate,InvoiceRank)
AS (
	SELECT ProjectId, InvoiceId, InvoiceDate,
		RANK() OVER (PARTITION BY ProjectId ORDER BY InvoiceDate) AS 'Rank'
	FROM tblInvoice
	)
SELECT a.ProjectId,a.InvoiceRank,a.InvoiceId,a.InvoiceDate,
CASE WHEN b.ProjectId IS NULL THEN c.ProjectStartDate
  ELSE dateadd(d,1,b.InvoiceDate) END as BillStartDate
FROM InvoiceRank a LEFT JOIN InvoiceRank b ON a.ProjectId=b.ProjectId AND
   a.InvoiceRank =  b.InvoiceRank + 1
   JOIN tblProject c ON a.ProjectId=c.ProjectId
   JOIN tblInvoice ON tblInvoice.InvoiceId = a.InvoiceId;

GO

