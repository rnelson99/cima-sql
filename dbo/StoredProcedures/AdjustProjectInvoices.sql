
CREATE PROCEDURE dbo.AdjustProjectInvoices
	@ProjectId int,
	@ProjectStartDate datetime,
	@BaseContract money
AS
DECLARE @InvoiceId int
DECLARE @InvoiceDate datetime
DECLARE @InvoiceStatus nvarchar(50)
DECLARE @InvoiceGross  money
DECLARE @InvoiceAmount money
DECLARE @OwnerPayAppNumber int   -- Increment
DECLARE @RetainagePercentage decimal(18,2)
DECLARE @BillingStartDate datetime
DECLARE @WorkTotalPrior money
DECLARE @WorkTotalNew money
DECLARE @PercentCompletePrior decimal(18,2)
DECLARE @PercentComplete decimal(18,2)
DECLARE @RetainagePrior money
DECLARE @Retainage money
DECLARE @ChangeOrders money
--  Cumulative variables
DECLARE @PayAppNumber int
DECLARE @StartDate datetime
DECLARE @WorkTotalCumulative money
DECLARE @PctCompletion decimal(18,2)
DECLARE @RetainageCumulative money
DECLARE InvoiceCursor CURSOR FOR
SELECT a.invoiceid , a.ownerpayappnumber, a.InvoiceDate
,a.RetainagePercentage, a.InvoiceStatus, a.InvoiceGross
, sum(CASE InvoiceDetailCreatedBySystem WHEN 0 THEN b.invoicedetailamount
    ELSE 0.0 END) as invoiceamount
, sum(CASE InvoiceDetailCreatedBySystem WHEN 1 THEN b.invoicedetailamount
    ELSE 0.0 END) as changestotal
FROM tblInvoice a LEFT JOIN tblInvoiceDetail b ON a.invoiceid=b.invoiceid
WHERE a.ProjectId=@ProjectId
GROUP BY  a.invoiceid , a.ownerpayappnumber, a.InvoiceDate
,a.RetainagePercentage, a.InvoiceStatus, a.InvoiceGross
OPEN InvoiceCursor
-- Initialize cumulative variables
SET @PayAppNumber =0
SET @StartDate = DateAdd(day,1,@ProjectStartDate)
SET @WorkTotalCumulative = 0.0
SET @PctCompletion =0.00
SET @RetainageCumulative =0
FETCH NEXT FROM InvoiceCursor
INTO @InvoiceID,@OwnerPayAppNumber,@InvoiceDate,@RetainagePercentage,@InvoiceStatus,
  @InvoiceGross,@InvoiceAmount,@ChangeOrders
WHILE @@FETCH_STATUS=0
BEGIN
	IF (@InvoiceStatus = 'Interim')
		BEGIN
			SET @BillingStartDate=@StartDate
			SET @PayAppNumber=@PayAppNumber + 1
			SET @InvoiceGross=@InvoiceAmount
			SET @WorkTotalPrior = @WorkTotalCumulative
			SET @WorkTotalNew = @WorkTotalCumulative + @InvoiceGross
			SET @WorkTotalCumulative=@WorkTotalNew
			SET @PercentCompletePrior=@PctCompletion
			SET @PercentComplete = @WorkTotalNew/(@BaseContract + @ChangeOrders)
			SET @PctCompletion=@PercentComplete
			SET @RetainagePrior=@RetainageCumulative
			SET @Retainage = @RetainagePercentage * @InvoiceGross
			SET @RetainageCumulative=@RetainagePrior + @Retainage
		END
	ELSE   -- Final Invoice
		BEGIN
			SELECT @ChangeOrders = Sum(ISNULL(Price,0)) FROM viewChangeOrders
			  WHERE ProjectId=@ProjectId AND Status='Approved'
			IF @ChangeOrders IS NULL
			   SET @ChangeOrders=0.00
			SET @BillingStartDate=@StartDate		
			SET @PayAppNumber=@PayAppNumber + 1
			SET @WorkTotalPrior = @WorkTotalCumulative
			SET @WorkTotalNew =@BaseContract + @ChangeOrders
			SET @InvoiceGross=@WorkTotalNew-@WorkTotalCumulative
			SET @WorkTotalCumulative=@WorkTotalNew
			SET @PercentCompletePrior=@PctCompletion
			SET @PercentComplete = 1.0
			SET @RetainagePrior=@RetainageCumulative
			SET @Retainage = -@RetainageCumulative
			SET @RetainageCumulative =0
		END
	UPDATE tblInvoice SET OwnerPayAppNumber=@PayAppNumber,BillingEndDate=@InvoiceDate,
	BillingStartDate=@BillingStartDate, WorkTotalPrior=@WorkTotalPrior,
	WorkTotalNew=@WorkTotalNew, PercentCompletePrior=@PercentCompletePrior,
	PercentComplete=@PercentComplete,RetainagePrior=@RetainagePrior,
	Retainage=@Retainage, InvoiceGross=@InvoiceGross,
	RemainingUnbilled =(@BaseContract + @ChangeOrders)-@WorkTotalNew
	   WHERE InvoiceId=@InvoiceId;
	SET @StartDate = DateAdd(day,1,@InvoiceDate)
	FETCH NEXT FROM InvoiceCursor
	INTO @InvoiceID,@OwnerPayAppNumber,@InvoiceDate,@RetainagePercentage,@InvoiceStatus,
	  @InvoiceGross,@InvoiceAmount,@ChangeOrders
END
CLOSE InvoiceCursor;
DEALLOCATE InvoiceCursor;

GO

