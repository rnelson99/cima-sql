

CREATE PROCEDURE [dbo].[PopulateAccountLandingNJ]
	@OurCompany	nvarchar(50)= 'NJ'
AS
BEGIN

/*
	Version		Date			Name		Notes			
	1.00		27-Jan-2020		Butz		Created file
	2.00		10-Mar-2020		Butz		Updates:
											Receivable by Client: Sort by A/R in descending order
											Billed by Project: Sort Unbilled in desceding order
											Fix Chargeable Rate start and ending months
											Fix Unbilled by Project - temp table not being deleted when run, all values being picked up instead of just unbilled.
											Add TotalHours in Chargeability Rates.
											Fix A/P. Don't include ProjectID=1206 and APDays<0
											Fix Billable Last 30
	3.00		28-Mar-2020		Chris		Chargeable Rate changes
	4.00		10-Apr-2020		Butz		Add Chargeable Rate Details
											Add A/P Details
											Add Rec by Client Details
	5.00		16-Jun-2020		Butz		Add Company Parameter
	6.00		22-Jul-2020		Butz		A/R issue
	7.00		01-Oct-2020		Butz		Add Fee Schedule
*/

	DECLARE @BillableAmountLast30 money = 0;
	DECLARE @BillableExpensesLast30 money = 0;
	DECLARE @UnbilledAmountGT30 money = 0;
	DECLARE @UnbilledExpensesGT30 money = 0;
	DECLARE @AP money = 0;
	DECLARE @APLastWeek money = 0;
	DECLARE @APPercent smallint = 0;
	DECLARE @APBW bit = 1;
	DECLARE @CurrentDate datetime;
	DECLARE @DateLast30Days datetime;
	DECLARE @DateLast7Days datetime;

	DECLARE @Potential money = 0;
	DECLARE @PotentialLastMonth money = 0;
	DECLARE @PotentialPercent smallint = 0;
	DECLARE @PotentialBW bit = 1;

	DECLARE @BillableAmountLastMonth money = 0;
	DECLARE @BillableExpensesLastMonth money = 0;
	DECLARE @UnbilledAmountGTLastMonth money = 0;
	DECLARE @UnbilledExpensesGTLastMonth money = 0;
	DECLARE @BillablePercent smallint = 0;
	DECLARE @BillableBW bit = 1;
	DECLARE @UnbilledPercent smallint = 0;
	DECLARE @UnbilledBW bit = 1;

	DECLARE @ARGT30 money = 0;
	DECLARE @ARGT30LastMonth money = 0;
	DECLARE @ARGT30Percent smallint = 0;
	DECLARE @ARGT30BW bit = 1;

	DECLARE @Backlog money = 0;
	DECLARE @BacklogLastMonth money = 0;
	DECLARE @BacklogPercent smallint = 0;
	DECLARE @BacklogBW bit = 1;

	DECLARE @BacklogProject money;
	DECLARE @BacklogBase money;
	DECLARE @BacklogAdditional money;
	DECLARE @BacklogBillCharge money;
	DECLARE @BacklogBillExpenses money;
	DECLARE @BacklogBilled money;
	DECLARE @ProjectID int;

	DECLARE @TimeSheetStart datetime;
	DECLARE @TimeSheetEnd datetime;
	DECLARE @WorkingDays int;

	SET @CurrentDate = CONVERT(varchar, GETDATE(), 102);
	SET @DateLast7Days = DATEADD(dd, -7, @CurrentDate);
	SET @DateLast30Days = DATEADD(dd, -30, @CurrentDate);

	-- Temp Table used for Bill Hours
	IF OBJECT_ID('tempdb..#tmpNJBillHours') IS NOT NULL
		DROP TABLE #tmpNJBillHours;

	-- Temp Table used for Expenses
	IF OBJECT_ID('tempdb..#tmpNJBillExpenses') IS NOT NULL
		DROP TABLE #tmpNJBillExpenses;

	-- Temp Table used for Bill Hours last month
	IF OBJECT_ID('tempdb..#tmpNJBillHoursLastMonth') IS NOT NULL
		DROP TABLE #tmpNJBillHoursLastMonth;

	-- Temp Table used for Expenses last month
	IF OBJECT_ID('tempdb..#tmpNJBillExpensesLastMonth') IS NOT NULL
		DROP TABLE #tmpNJBillExpensesLastMonth;

	-- Temp Table used for A/R
	IF OBJECT_ID('tempdb..#tmpNJAR') IS NOT NULL
		DROP TABLE #tmpNJAR;

	-- Temp Table used for A/P
	IF OBJECT_ID('tempdb..#tmpNJAP') IS NOT NULL
		DROP TABLE #tmpNJAP;

	-- Temp Table used for Chargeable Rate
	IF OBJECT_ID('tempdb..#tmpNJChargeable') IS NOT NULL
		DROP TABLE #tmpNJChargeable;

	-- Temp Table used for A/P
	IF OBJECT_ID('tempdb..#tmpNJAPLastWeek') IS NOT NULL
		DROP TABLE #tmpNJAPLastWeek;

	-- Temp Table used for payment as of last week
	IF OBJECT_ID('tempdb..#tmpNJPaymentAppliedLastWeek') IS NOT NULL
		DROP TABLE #tmpNJPaymentAppliedLastWeek;

	-- Month 0
	IF OBJECT_ID('tempdb..#tmpNJCR0') IS NOT NULL
		DROP TABLE #tmpNJCR0;

	-- Month 1
	IF OBJECT_ID('tempdb..#tmpNJCR1') IS NOT NULL
		DROP TABLE #tmpNJCR1;

	-- Month 2
	IF OBJECT_ID('tempdb..#tmpNJCR2') IS NOT NULL
		DROP TABLE #tmpNJCR2;

	/********************************************************************************************************************************************
	----------------------------------------------------------- START: TEMP FEE SCHEDULE --------------------------------------------------------
	*********************************************************************************************************************************************/
	IF OBJECT_ID('tempdb..#tmpFeeScheduleProjectList') IS NOT NULL
		DROP TABLE #tmpFeeScheduleProjectList;

	DECLARE @tmpFeeSchedule table (
		ProjectID int
		,FeeDesc varchar(100)
		,Amt money
		,FeeLevel varchar(100)
	);

	SELECT DISTINCT p.ProjectID
	INTO #tmpFeeScheduleProjectList
	FROM TimeSheet.TimeSheetDetails d
		JOIN TimeSheet.Timesheet t ON t.TimeSheetID = d.TimesheetID
		JOIN tblProject p ON p.ProjectID = d.ReferenceID
		LEFT JOIN tlkpActivity a ON a.ActivityID = d.Task
		JOIN Contacts.Entity e ON e.EntityID = t.EntityID
		LEFT JOIN Contacts.Attributes aa ON aa.EntityID = e.EntityID AND aa.attributetype = 'JobClassification' AND aa.status = 1
		LEFT JOIN Contacts.Attributes aac ON aac.EntityID = e.EntityID AND aac.attributetype = 'JobClassificationCIMA' AND aac.status = 1
		LEFT JOIN ProviewTemp.dbo.ProjectFeeSchedule fs ON fs.FeeDesc = aa.attribute AND fs.ProjectID = p.ProjectID
		LEFT JOIN tblInvoice ii ON ii.invoiceid = d.invoiceid
	WHERE d.Status = 1
		AND (ISNULL(d.Hours,0) > 0 OR ISNULL(d.BHours,0) > 0)
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND p.ProjectID<>1206;

	IF CURSOR_STATUS('global','FeeScheduleCursor')>=-1
		DEALLOCATE FeeScheduleCursor

	DECLARE FeeScheduleCursor CURSOR FOR
		SELECT p.ProjectID
		FROM tblProject p
			JOIN tvalProjectStatus ps on ps.CIMA_Status = p.CIMA_Status	
			JOIN #tmpFeeScheduleProjectList t ON p.ProjectID = t.ProjectID;

	OPEN FeeScheduleCursor;

	FETCH NEXT FROM FeeScheduleCursor
	INTO @ProjectID;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF OBJECT_ID('tempdb..#tmpFeeTable') IS NOT NULL
			DROP TABLE #tmpFeeTable
    
		CREATE TABLE #tmpFeeTable (
			FeeDesc varchar(100)
			,Amt money
			,FeeLevel varchar(100)
		);

		DECLARE @StartDate datetime = (SELECT MilestoneDate FROM tblMilestone WHERE ProjectId = @ProjectID AND MilestoneId = 2 AND MilestoneDate IS NOT NULL);
		DECLARE @Count int = (
			SELECT COUNT(*)
				FROM users.FeeSchedule
				WHERE ProjectID = @ProjectID 
					OR ClientID = (SELECT ClientEntityID FROM tblProject WHERE ProjectID = @ProjectID)
			)

		IF (@Count = 0)
		BEGIN
			INSERT INTO #tmpFeeTable (FeeDesc, Amt, FeeLevel)
			SELECT FeeDescription, amt, 'Global Fee Schedule' AS FeeLevel
			FROM users.FeeSchedule 
			WHERE 1=1
				AND status = 1
				AND ProjectID = 0
				AND ClientID = 0
				AND EffectiveEnd IS NULL;
		END
		ELSE
		BEGIN
			IF (SELECT count(*) FROM users.FeeSchedule WHERE ProjectID = @ProjectID) = 0
			BEGIN
				--Client Level
				INSERT INTO #tmpFeeTable (FeeDesc, Amt, FeeLevel)
				SELECT FeeDescription, amt, 'Client Fee Schedule' as FeeLevel
				FROM users.FeeSchedule 
				WHERE 1=1
					AND status = 1
					AND ProjectID = 0
					AND ClientID = (SELECT ClientEntityID FROM tblProject WHERE ProjectID = @ProjectID)
					AND EffectiveEnd IS NULL
			END
			ELSE
			BEGIN
				INSERT INTO #tmpFeeTable (FeeDesc, Amt, FeeLevel)
				SELECT FeeDescription, Amt, 'Project Fee Schedule' AS FeeLevel
				FROM users.FeeSchedule 
				WHERE 1=1
					AND status = 1
					AND ProjectID = @projectid
					AND ClientID = 0
					AND EffectiveEnd IS NULL
			END;
		END;

		INSERT INTO @tmpFeeSchedule (ProjectID, FeeDesc, Amt, FeeLevel)
		SELECT @ProjectID, FeeDesc, Amt, FeeLevel
		FROM #tmpFeeTable

		FETCH NEXT FROM FeeScheduleCursor
		INTO @ProjectID;
	END
	CLOSE FeeScheduleCursor;
	DEALLOCATE FeeScheduleCursor;

	IF OBJECT_ID('tempdb..#tmpFeeTable') IS NOT NULL
	DROP TABLE #tmpFeeTable

	IF OBJECT_ID('tempdb..#tmpFeeScheduleProjectList') IS NOT NULL
		DROP TABLE #tmpFeeScheduleProjectList;

	/********************************************************************************************************************************************
	----------------------------------------------------------- END: TEMP FEE SCHEDULE ----------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	----------------------------------------------------------- START: BILLABLE/UNBILLED --------------------------------------------------------
	*********************************************************************************************************************************************/

	-- Populate Bill Hours Temp Table
	SELECT p.ProjectID
		,p.ProjectNum
		,p.ProjectShortName
		,p.ProjectName

		--x,ISNULL(d.BHours, d.Hours) * COALESCE(d.billrate, fs.Amt, 0) AS BillAmount
		,ISNULL(d.BHours, d.Hours) * (CASE WHEN p.OurCompany = 'NJ' THEN
			COALESCE(d.billrate, fs.Amt, 0) ELSE
			COALESCE(d.billrate,fsC.Amt, 0) END) AS BillAmount

		,DATEDIFF(dd, CONVERT(varchar, d.dDate, 102), @CurrentDate) AS AgeInDays
		,CASE WHEN d.InvoiceID IS NULL THEN 0 ELSE 1 END AS IsBilled
		,p.OurCompany
	INTO #tmpNJBillHours
	FROM TimeSheet.TimeSheetDetails d
		JOIN TimeSheet.Timesheet t ON t.TimeSheetID = d.TimesheetID
		JOIN tblProject p ON p.ProjectID = d.ReferenceID
		LEFT JOIN tlkpActivity a ON a.ActivityID = d.Task
		JOIN Contacts.Entity e ON e.EntityID = t.EntityID
		LEFT JOIN Contacts.Attributes aa ON aa.EntityID = e.EntityID AND aa.attributetype = 'JobClassification' AND aa.status = 1
		LEFT JOIN Contacts.Attributes aac ON aac.EntityID = e.EntityID AND aac.attributetype = 'JobClassificationCIMA' AND aac.status = 1
		LEFT JOIN @tmpFeeSchedule fs on fs.FeeDesc = aa.attribute AND fs.projectid = @ProjectID
		LEFT JOIN @tmpFeeSchedule fsC on fsC.FeeDesc = aaC.attribute AND fsC.projectid = @ProjectID
		LEFT JOIN tblInvoice ii ON ii.invoiceid = d.invoiceid
	WHERE d.Status = 1
		AND (ISNULL(d.Hours,0) > 0 OR ISNULL(d.BHours,0) > 0)
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND p.ProjectID<>1206;

	-- Populate Expenses Temp Table
	SELECT p.ProjectID
		,p.ProjectNum
		,p.ProjectShortName
		,p.ProjectName
		,COALESCE(e.billAmount, e.ccamount,0) AS ExpenseAmount
		,DATEDIFF(dd, CONVERT(varchar, e.TransactionDate, 102), @CurrentDate) as AgeInDays
		,CASE WHEN e.InvoiceID IS NULL THEN 0 ELSE 1 END AS IsBilled
		,e.TransactionDate
	INTO #tmpNJBillExpenses
	FROM tblExpense e
		JOIN tblProject p ON e.ProjectID =  p.ProjectID
	WHERE e.IsDeleted='N'
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND e.IsBillable=1
		AND p.ProjectID<>1206;

	-- Populate Bill Hours Temp Table Last Month
	SELECT p.ProjectID
		,p.ProjectNum
		,p.ProjectShortName
		,p.ProjectName
		,ISNULL(d.BHours, d.Hours) * COALESCE(d.billrate, fs.Amt, 0) AS BillAmount
		,DATEDIFF(dd, CONVERT(varchar, d.dDate, 102), CONVERT(varchar, @DateLast30Days, 102)) as AgeInDays
		,CASE WHEN d.InvoiceID IS NULL THEN 0 ELSE 1 END AS IsBilled
		,d.AddDate
		,d.dDate
	INTO #tmpNJBillHoursLastMonth
	FROM TimeSheet.TimeSheetDetails d
		JOIN TimeSheet.Timesheet t ON t.TimeSheetID = d.TimesheetID
		JOIN tblProject p ON p.ProjectID = d.ReferenceID
		LEFT JOIN tlkpActivity a ON a.ActivityID = d.Task
		JOIN Contacts.Entity e ON e.EntityID = t.EntityID
		LEFT JOIN Contacts.Attributes aa ON aa.EntityID = e.EntityID AND aa.attributetype = 'JobClassification' AND aa.status = 1
		LEFT JOIN Contacts.Attributes aac ON aac.EntityID = e.EntityID AND aac.attributetype = 'JobClassificationCIMA' AND aac.status = 1
		LEFT JOIN ProviewTemp.dbo.ProjectFeeSchedule fs ON fs.FeeDesc = aa.attribute AND fs.ProjectID = p.ProjectID
		LEFT JOIN tblInvoice ii ON ii.invoiceid = d.invoiceid
	WHERE d.Status = 1
		AND (ISNULL(d.Hours,0) > 0 OR ISNULL(d.BHours,0) > 0)
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND d.AddDate<@DateLast30Days
		AND p.AddDate<@DateLast30Days
		AND p.ProjectID<>1206;

	-- Populate Expenses Temp Table Last Month
	SELECT p.ProjectID
		,p.ProjectNum
		,p.ProjectShortName
		,p.ProjectName
		,COALESCE(e.billAmount, e.ccamount,0) AS ExpenseAmount
		,DATEDIFF(dd, CONVERT(varchar, e.TransactionDate, 102), CONVERT(varchar, @DateLast30Days, 102)) as AgeInDays
		,CASE WHEN e.InvoiceID IS NULL THEN 0 ELSE 1 END AS IsBilled
		,e.TransactionDate
	INTO #tmpNJBillExpensesLastMonth
	FROM tblExpense e
		JOIN tblProject p ON e.ProjectID =  p.ProjectID
	WHERE e.IsDeleted='N'
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND e.AddDate<@DateLast30Days
		AND p.AddDate<@DateLast30Days
		AND e.IsBillable=1
		AND p.ProjectID<>1206;

	-------------------------------------------------------------------------------------------------------------------------
	-- << Start: Populating AccountLandingNJ BillableLast30 & UnbilledMore30
	-------------------------------------------------------------------------------------------------------------------------

	-- Billable Amount in the last 30 days
	SELECT @BillableAmountLast30=ISNULL(SUM(#tmpNJBillHours.BillAmount),0)
	FROM #tmpNJBillHours
	WHERE AgeInDays<=30;

	-- Unbilled Amount > 30 days
	SELECT @UnbilledAmountGT30=ISNULL(SUM(#tmpNJBillHours.BillAmount),0)
	FROM #tmpNJBillHours
	WHERE AgeInDays>30
		AND IsBilled=0;

	-- Billable Expenses in the last 30 days
	SELECT @BillableExpensesLast30=ISNULL(SUM(#tmpNJBillExpenses.ExpenseAmount),0)
	FROM #tmpNJBillExpenses
	WHERE AgeInDays<=30;

	-- Unbilled Expenses > 30 days
	SELECT @UnbilledExpensesGT30=ISNULL(SUM(#tmpNJBillExpenses.ExpenseAmount),0)
	FROM #tmpNJBillExpenses
	WHERE AgeInDays>30
		AND IsBilled=0;

	----------------------------------------------------------------------------
	-- Billable Amount in the last month
	SELECT @BillableAmountLastMonth=ISNULL(SUM(#tmpNJBillHoursLastMonth.BillAmount),0)
	FROM #tmpNJBillHoursLastMonth
	WHERE AgeInDays<=30;

	-- Unbilled Amount > 30 days last month
	SELECT @UnbilledAmountGTLastMonth=ISNULL(SUM(#tmpNJBillHoursLastMonth.BillAmount),0)
	FROM #tmpNJBillHoursLastMonth
	WHERE AgeInDays>30
		AND IsBilled=0;

	-- Billable Expenses in the last month
	SELECT @BillableExpensesLastMonth=ISNULL(SUM(#tmpNJBillExpensesLastMonth.ExpenseAmount),0)
	FROM #tmpNJBillExpensesLastMonth
	WHERE AgeInDays<=30;

	-- Unbilled Expenses > 30 days last month
	SELECT @UnbilledExpensesGTLastMonth=ISNULL(SUM(#tmpNJBillExpensesLastMonth.ExpenseAmount),0)
	FROM #tmpNJBillExpensesLastMonth
	WHERE AgeInDays>30
		AND IsBilled=0;

	-- Billable Percent and BW
	SET @BillableAmountLast30 = (@BillableAmountLast30+@BillableExpensesLast30);
	SET @BillableAmountLastMonth = (@BillableAmountLastMonth+@BillableExpensesLastMonth);

	IF (@BillableAmountLast30 > @BillableAmountLastMonth)
	BEGIN
		IF (@BillableAmountLastMonth) <> 0
			SET @BillablePercent = (@BillableAmountLast30 - @BillableAmountLastMonth) / @BillableAmountLastMonth * 100;
		ELSE
			SET @BillablePercent = 100;
		SET @BillableBW = 1;
	END
	ELSE
	BEGIN
		IF (@BillableAmountLast30 <> 0)
			SET @BillablePercent = (@BillableAmountLastMonth - @BillableAmountLast30) / @BillableAmountLast30 * 100;
		ELSE
			SET @BillablePercent = 100;

		SET @BillableBW = 0;
	END;

	-- Unbilled Percent and BW
	IF (@UnbilledAmountGT30+@UnbilledExpensesGT30) > (@UnbilledAmountGTLastMonth+@UnbilledExpensesGTLastMonth)
	BEGIN
		IF (@UnbilledAmountGTLastMonth+@UnbilledExpensesGTLastMonth) <> 0
			SET @UnbilledPercent = ((@UnbilledAmountGT30+@UnbilledExpensesGT30) - (@UnbilledAmountGTLastMonth+@UnbilledExpensesGTLastMonth)) / (@UnbilledAmountGTLastMonth+@UnbilledExpensesGTLastMonth) * 100;
		ELSE
			SET @UnbilledPercent = 100;
		SET @UnbilledBW = 1;
	END
	ELSE
	BEGIN
		IF (@UnbilledAmountGT30+@UnbilledExpensesGT30) <> 0
			SET @UnbilledPercent = ((@UnbilledAmountGTLastMonth+@UnbilledExpensesGTLastMonth) - (@UnbilledAmountGT30+@UnbilledExpensesGT30)) / (@UnbilledAmountGT30+@UnbilledExpensesGT30) * 100;
		ELSE
			SET @UnbilledPercent = 100;

		SET @UnbilledBW = 0;
	END;

	DELETE FROM ProviewTemp.dbo.AccountLandingNJ;

	INSERT INTO ProviewTemp.dbo.AccountLandingNJ (dDate
		,BillableLast30
		,UnbilledMore30
		,billableLast30BW
		,UnbilledMore30BW
		,billableLast30Per
		,UnbilledMore30Per)
	VALUES (GETDATE()
		,@BillableAmountLast30
		,@UnbilledAmountGT30+@UnbilledExpensesGT30
		,@BillableBW
		,@UnbilledBW
		,@BillablePercent		
		,@UnbilledPercent);

	-------------------------------------------------------------------------------------------------------------------------
	-- << Start: Populating AccountLandingBilledByProjectNJ
	-------------------------------------------------------------------------------------------------------------------------
	DELETE FROM ProviewTemp.dbo.AccountLandingBilledByProjectNJ;

	;WITH BillableByProject AS (
		-- Billable Amount in the last 30 days
		SELECT ProjectID, ProjectName, BillAmount
		FROM #tmpNJBillHours
		WHERE IsBilled=0
		UNION ALL
		-- Billable Expenses in the last 30 days
		SELECT ProjectID, ProjectName, ExpenseAmount
		FROM #tmpNJBillExpenses
		WHERE IsBilled=0
	)
	INSERT INTO ProviewTemp.dbo.AccountLandingBilledByProjectNJ (ProjectID, Project, Unbilled)
	SELECT ProjectID, ProjectName, SUM(BillAmount) As Unbilled
	FROM BillableByProject
	GROUP BY ProjectID, ProjectName
	HAVING SUM(BillAmount)<>0;

	/********************************************************************************************************************************************
	------------------------------------------------------------ END: BILLABLE/UNBILLED ---------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	------------------------------------------------------------ START: CHARGEABLE RATE ---------------------------------------------------------
	*********************************************************************************************************************************************/

	DELETE FROM ProviewTemp.dbo.AccountLandingChargeableRateNJ;
	DELETE FROM ProviewTemp.dbo.AccountLandingChargeableRateDetailsNJ;

	IF @OurCompany='NJ'
	BEGIN

		SET @TimeSheetStart = DATEADD(mm, -2, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));
		SET @TimeSheetEnd = DATEADD(mm, 3, @TimeSheetStart)-1;
		SET @WorkingDays=(DATEDIFF(dd, @TimeSheetStart, @TimeSheetEnd) + 1)
		  -(DATEDIFF(wk, @TimeSheetStart, @TimeSheetEnd) * 2)
		  -(CASE WHEN DATENAME(dw, @TimeSheetStart) = 'Sunday' THEN 1 ELSE 0 END)
		  -(CASE WHEN DATENAME(dw, @TimeSheetEnd) = 'Saturday' THEN 1 ELSE 0 END);

		;WITH ChargeableUsers AS (
			SELECT a.EntityID
			FROM Contacts.Attributes a
			WHERE a.attributetype='TrackChargeability'
				AND a.attribute='Yes'
				AND a.[status]=1
		), UserTimesheet AS (
			SELECT t.EntityID
				,ISNULL(e.FirstName,'') + ' ' + CASE WHEN NOT e.LastName IS NULL THEN LEFT(e.LastName, 1)+'.' ELSE '' END AS EntityName
				,d.Hours
				,MONTH(d.dDate) AS ChargeMonth
				,LEFT(CONVERT(varchar, d.dDate, 107), 3) AS ChargeMonthName
				,YEAR(d.dDate) AS ChargeYear
				,DATEFROMPARTS(YEAR(d.dDate), MONTH(d.dDate), 1) AS MonthStart		
				,DATEADD(dd, -1, DATEADD(mm, 1, DATEFROMPARTS(YEAR(d.dDate), MONTH(d.dDate), 1))) As MonthEnd
			FROM Timesheet.TimeSheet t
				LEFT JOIN Contacts.Entity e ON t.EntityID=e.EntityID
				LEFT JOIN timesheet.TimeSheetDetails d ON d.TimesheetID = t.TimeSheetID and d.Status = 1 AND d.ReferenceID > 100
			WHERE 1=1
				AND d.Hours<>0
				AND (d.dDate>=@TimeSheetStart AND d.dDate<(@TimeSheetEnd+1))
		), TimesheetCombined AS (
			SELECT ut.EntityID
				,ut.EntityName
				,ut.Hours
				,ut.ChargeMonth
				,ut.ChargeMonthName
				,ut.ChargeYear
				,ut.MonthStart
				,ut.MonthEnd
				,(DATEDIFF(dd, ut.MonthStart, ut.MonthEnd) + 1)
					-(DATEDIFF(wk, ut.MonthStart, ut.MonthEnd) * 2)
					-(CASE WHEN DATENAME(dw, ut.MonthStart) = 'Sunday' THEN 1 ELSE 0 END)
					-(CASE WHEN DATENAME(dw, ut.MonthEnd) = 'Saturday' THEN 1 ELSE 0 END) AS WorkingDays
			FROM UserTimesheet ut JOIN ChargeableUsers cu
				ON ut.EntityID=cu.EntityID
			WHERE NOT ut.EntityID IN (1, 4, 12)
			UNION ALL
			SELECT utnj.EntityID
				,utnj.EntityName
				,utnj.Hours
				,utnj.ChargeMonth
				,utnj.ChargeMonthName
				,utnj.ChargeYear
				,utnj.MonthStart
				,utnj.MonthEnd
				,(DATEDIFF(dd, utnj.MonthStart, utnj.MonthEnd) + 1)
					-(DATEDIFF(wk, utnj.MonthStart, utnj.MonthEnd) * 2)
					-(CASE WHEN DATENAME(dw, utnj.MonthStart) = 'Sunday' THEN 1 ELSE 0 END)
					-(CASE WHEN DATENAME(dw, utnj.MonthEnd) = 'Saturday' THEN 1 ELSE 0 END) AS WorkingDays
			FROM UserTimesheet utnj
			WHERE utnj.EntityID IN (1, 4, 12) -- Rick, Matt, Pete
		)
		SELECT *
		INTO #tmpNJChargeable
		FROM TimesheetCombined

		-- Insert Employee names
		INSERT INTO ProviewTemp.dbo.AccountLandingChargeableRateNJ (EntityID, [User], Month0, Month1, Month2,Mth0, Mth1, Mth2)
		SELECT DISTINCT EntityID, EntityName, 0, 0, 0, FORMAT(DATEADD(mm, 2, @TimeSheetStart), 'MMM'), FORMAT(DATEADD(mm, 1, @TimeSheetStart), 'MMM'), FORMAT(@TimeSheetStart, 'MMM')
		FROM #tmpNJChargeable
		ORDER BY EntityName;

		-- Month 0
		SELECT EntityID, EntityName, SUM(Hours)/(WorkingDays*8) AS ChargeableRate, SUM(Hours) AS TotalHours
		INTO #tmpNJCR0
		FROM #tmpNJChargeable
		WHERE MONTH(DATEADD(mm, 2, @TimeSheetStart))=ChargeMonth
		GROUP BY EntityID, EntityName, WorkingDays;

		UPDATE cr
		SET Month0=(CAST(tmp.ChargeableRate*100 AS integer))
			,Month0Hours=ISNULL(tmp.TotalHours, 0)
		FROM ProviewTemp.dbo.AccountLandingChargeableRateNJ cr
			JOIN #tmpNJCR0 tmp ON cr.EntityID=tmp.EntityID;

		-- Month 1
		SELECT EntityID, EntityName, SUM(Hours)/(WorkingDays*8) AS ChargeableRate, SUM(Hours) AS TotalHours
		INTO #tmpNJCR1
		FROM #tmpNJChargeable
		WHERE MONTH(DATEADD(mm, 1, @TimeSheetStart))=ChargeMonth
		GROUP BY EntityID, EntityName, WorkingDays;

		UPDATE cr
		SET Month1=(CAST(tmp.ChargeableRate*100 AS integer))
			,Month1Hours=ISNULL(tmp.TotalHours, 0)
		FROM ProviewTemp.dbo.AccountLandingChargeableRateNJ cr
			JOIN #tmpNJCR1 tmp ON cr.EntityID=tmp.EntityID;

		-- Month 2
		SELECT EntityID, EntityName, SUM(Hours)/(WorkingDays*8) AS ChargeableRate, SUM(Hours) AS TotalHours
		INTO #tmpNJCR2
		FROM #tmpNJChargeable
		WHERE MONTH(@TimeSheetStart)=ChargeMonth
		GROUP BY EntityID, EntityName, WorkingDays;

		UPDATE cr
		SET Month2=(CAST(tmp.ChargeableRate*100 AS integer))
			,Month2Hours=ISNULL(tmp.TotalHours, 0)
		FROM ProviewTemp.dbo.AccountLandingChargeableRateNJ cr
			JOIN #tmpNJCR2 tmp ON cr.EntityID=tmp.EntityID;

		-- Chargeable Rate Details
		INSERT INTO ProviewTemp.dbo.AccountLandingChargeableRateDetailsNJ
		SELECT
			t.EntityID
			,LEFT(CONVERT(varchar, d.dDate, 107), 3) AS TimesheetMonth
			,d.ReferenceID AS ProjectID
			,p.ProjectNum
			,p.ProjectShortName AS ProjectName
			,d.Hours
			,d.dDate AS TimesheetDate
			,a.ActivityCode AS TaskCode
			,d.Comments
		FROM Timesheet.TimeSheet t
			LEFT JOIN Contacts.Entity e ON t.EntityID=e.EntityID
			LEFT JOIN timesheet.TimeSheetDetails d ON d.TimesheetID=t.TimeSheetID
				AND d.Status = 1
				AND d.ReferenceID > 100
			LEFT JOIN tlkpActivity a ON d.Task=a.ActivityID
			LEFT JOIN tblProject p ON p.ProjectID=d.ReferenceID
		WHERE 1=1
			AND d.Hours<>0
			AND (d.dDate>=@TimeSheetStart AND d.dDate<(@TimeSheetEnd+1))
		ORDER BY t.EntityID, d.dDate;

	END

	/********************************************************************************************************************************************
	------------------------------------------------------------- END: CHARGEABLE RATE ----------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	--------------------------------------------------------------- START: POTENTIAL ------------------------------------------------------------
	*********************************************************************************************************************************************/
	;WITH ProjectAttribute AS (
		SELECT a.ProjectID
			,CAST(ISNULL(a.attribute,'0') AS money) AS AttContractAmount
		FROM project.attributes a 
		WHERE a.attributetype='estContractAmt'
			AND a.status=1
	)
	SELECT @Potential = SUM(CASE WHEN ISNULL(p.CIMA_Bid,0)<>0 THEN ISNULL(p.CIMA_Bid,0) ELSE ISNULL(pa.AttContractAmount,0) END)
	FROM tblProject p
		LEFT JOIN ProjectAttribute pa ON p.ProjectID=pa.ProjectID
	WHERE p.CIMA_Status IN ('Potential', 'Proposal', 'Proposal Sent')
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND NOT p.CIMA_Bid IS NULL;

	-- Last Month
	SET @DateLast30Days = DATEADD(dd, -30, @CurrentDate);

	;WITH ProjectAttribute AS (
		SELECT a.ProjectID
			,CAST(ISNULL(a.attribute,'0') AS money) AS AttContractAmount
		FROM project.attributes a 
		WHERE a.attributetype='estContractAmt'
			AND a.status=1
	)
	SELECT @PotentialLastMonth = SUM(CASE WHEN ISNULL(p.CIMA_Bid,0)<>0 THEN ISNULL(p.CIMA_Bid,0) ELSE ISNULL(pa.AttContractAmount,0) END)
	FROM tblProject p
		LEFT JOIN ProjectAttribute pa ON p.ProjectID=pa.ProjectID
	WHERE p.CIMA_Status IN ('Potential', 'Proposal', 'Proposal Sent')
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND NOT p.CIMA_Bid IS NULL
		AND p.AddDate<@DateLast30Days;

	-- Final values
	IF @Potential > @PotentialLastMonth
	BEGIN
		IF @PotentialLastMonth <> 0
			SET @PotentialPercent = (@Potential - @PotentialLastMonth) / @PotentialLastMonth * 100;
		ELSE
			SET @PotentialPercent = 100;
		SET @PotentialBW = 1;
	END
	ELSE
	BEGIN
		IF @Potential <> 0
			SET @PotentialPercent = (@PotentialLastMonth - @Potential) / @Potential * 100;
		ELSE
			SET @PotentialPercent = 100;

		SET @PotentialBW = 0;
	END;

	UPDATE ProviewTemp.dbo.AccountLandingNJ
	SET potential=@Potential
		,potentialBW=@PotentialBW
		,potentialPer=@PotentialPercent;

	/********************************************************************************************************************************************
	--------------------------------------------------------------- END: POTENTIAL -------------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	---------------------------------------------------------------- START: BACKLOG -------------------------------------------------------------
	*********************************************************************************************************************************************/
	IF CURSOR_STATUS('global','BacklogCursor')>=-1
		DEALLOCATE BacklogCursor

	--
	-- Current
	--
	DECLARE BacklogCursor CURSOR FOR
		SELECT p.ProjectID
			,ISNULL(p.CIMA_Bid,0) AS Base
		FROM tblProject p
		WHERE 1=1
			AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
			AND p.CIMA_Status IN ('Awarded', 'Active', 'Closeout');

	OPEN BacklogCursor;
	FETCH NEXT FROM BacklogCursor
	INTO @ProjectID, @BacklogBase;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @BacklogProject = 0;
		SET @BacklogAdditional = 0;
		SET @BacklogBillCharge = 0;
		SET @BacklogBillExpenses = 0;
		SET @BacklogBilled = 0;

		SELECT @BacklogAdditional=ISNULL(SUM(cod.Qty * cod.UnitPrice),0)
		FROM tblChangeOrder co
			JOIN tblProject p ON p.ProjectID=co.ProjectID
			JOIN tblChangeOrderDetail cod ON co.ChangeOrderID=cod.ChangeOrderID
		WHERE 1=1
			AND co.ProjectID=@ProjectID
			AND NOT cod.Qty IS NULL
			AND NOT cod.UnitPrice IS NULL
			AND co.IsDeleted='N'		
			AND co.BillingStatus NOT IN ('Declined', 'Pending');

		SELECT @BacklogBillCharge=ISNULL(SUM(ISNULL(d.BHours, d.Hours) * COALESCE(d.billrate, fs.Amt, 0)),0)
		FROM TimeSheet.TimeSheetDetails d
			JOIN TimeSheet.Timesheet t ON t.TimeSheetID = d.TimesheetID
			JOIN tblProject p ON p.ProjectID = d.ReferenceID
			LEFT JOIN tlkpActivity a ON a.ActivityID = d.Task
			JOIN Contacts.Entity e ON e.EntityID = t.EntityID
			LEFT JOIN Contacts.Attributes aa ON aa.EntityID = e.EntityID AND aa.attributetype = 'JobClassification' AND aa.status = 1
			LEFT JOIN Contacts.Attributes aac ON aac.EntityID = e.EntityID AND aac.attributetype = 'JobClassificationCIMA' AND aac.status = 1
			LEFT JOIN ProviewTemp.dbo.ProjectFeeSchedule fs ON fs.FeeDesc = aa.attribute AND fs.ProjectID = p.ProjectID
			LEFT JOIN tblInvoice ii ON ii.invoiceid = d.invoiceid
		WHERE 1=1
			AND p.ProjectID = @ProjectID
			AND d.Status = 1
			AND (ISNULL(d.Hours,0) > 0 OR ISNULL(d.BHours,0) > 0);

		SELECT @BacklogBillExpenses=ISNULL(SUM(COALESCE(e.billAmount, e.ccamount,0)),0)
		FROM tblExpense e
		WHERE 1=1
			AND e.ProjectID=@ProjectID		
			AND e.IsDeleted='N'
			AND e.IsBillable=1;

		SELECT @BacklogBilled=ISNULL(SUM(CASE WHEN i.invoicestatus = 'Interim' THEN ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0)ELSE ISNULL(i.InvoiceGross,0) END),0)
		FROM tblInvoice i
		WHERE 1=1
			AND i.ProjectID=@ProjectID
			AND i.Status <> 'Void'

		SET @BacklogProject = @BacklogBase + @BacklogAdditional - @BacklogBilled - @BacklogBillCharge - @BacklogBillExpenses;

		IF @BacklogProject < 0
			SET @BacklogProject = 0;

		SET @Backlog = @Backlog + @BacklogProject;

		FETCH NEXT FROM BacklogCursor
		INTO @ProjectID, @BacklogBase;
	END;
	CLOSE BacklogCursor;
	DEALLOCATE BacklogCursor;

	--
	-- Last Month
	--
	SET @DateLast30Days = DATEADD(dd, -60, @CurrentDate);

	DECLARE BacklogCursor CURSOR FOR
		SELECT p.ProjectID
			,ISNULL(p.CIMA_Bid,0) AS Base
		FROM tblProject p
		WHERE 1=1
			AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
			AND p.CIMA_Status IN ('Awarded', 'Active', 'Closeout')
			AND p.AddDate<@DateLast30Days;

	OPEN BacklogCursor;
	FETCH NEXT FROM BacklogCursor
	INTO @ProjectID, @BacklogBase;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @BacklogProject = 0;
		SET @BacklogAdditional = 0;
		SET @BacklogBillCharge = 0;
		SET @BacklogBillExpenses = 0;
		SET @BacklogBilled = 0;

		SELECT @BacklogAdditional=ISNULL(SUM(cod.Qty * cod.UnitPrice),0)
		FROM tblChangeOrder co
			JOIN tblProject p ON p.ProjectID=co.ProjectID
			JOIN tblChangeOrderDetail cod ON co.ChangeOrderID=cod.ChangeOrderID
		WHERE 1=1
			AND co.ProjectID=@ProjectID
			AND NOT cod.Qty IS NULL
			AND NOT cod.UnitPrice IS NULL
			AND co.IsDeleted='N'		
			AND co.BillingStatus NOT IN ('Declined', 'Pending')
			AND co.AddDate<@DateLast30Days;

		SELECT @BacklogBillCharge=ISNULL(SUM(ISNULL(d.BHours, d.Hours) * COALESCE(d.billrate, fs.Amt, 0)),0)
		FROM TimeSheet.TimeSheetDetails d
			JOIN TimeSheet.Timesheet t ON t.TimeSheetID = d.TimesheetID
			JOIN tblProject p ON p.ProjectID = d.ReferenceID
			LEFT JOIN tlkpActivity a ON a.ActivityID = d.Task
			JOIN Contacts.Entity e ON e.EntityID = t.EntityID
			LEFT JOIN Contacts.Attributes aa ON aa.EntityID = e.EntityID AND aa.attributetype = 'JobClassification' AND aa.status = 1
			LEFT JOIN Contacts.Attributes aac ON aac.EntityID = e.EntityID AND aac.attributetype = 'JobClassificationCIMA' AND aac.status = 1
			LEFT JOIN ProviewTemp.dbo.ProjectFeeSchedule fs ON fs.FeeDesc = aa.attribute AND fs.ProjectID = p.ProjectID
			LEFT JOIN tblInvoice ii ON ii.invoiceid = d.invoiceid
		WHERE 1=1
			AND p.ProjectID = @ProjectID
			AND d.Status = 1
			AND (ISNULL(d.Hours,0) > 0 OR ISNULL(d.BHours,0) > 0)
			AND d.AddDate<@DateLast30Days;

		SELECT @BacklogBillExpenses=ISNULL(SUM(COALESCE(e.billAmount, e.ccamount,0)),0)
		FROM tblExpense e
		WHERE 1=1
			AND e.ProjectID=@ProjectID		
			AND e.IsDeleted='N'
			AND e.AddDate<@DateLast30Days
			AND e.IsBillable=1;

		SELECT @BacklogBilled=ISNULL(SUM(CASE WHEN i.invoicestatus = 'Interim' THEN ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0)ELSE ISNULL(i.InvoiceGross,0) END),0)
		FROM tblInvoice i
		WHERE 1=1
			AND i.ProjectID=@ProjectID
			AND i.Status <> 'Void'
			AND i.InvoiceDate<@DateLast30Days;

		SET @BacklogProject = @BacklogBase + @BacklogAdditional - @BacklogBilled - @BacklogBillCharge - @BacklogBillExpenses;

		IF @BacklogProject < 0
			SET @BacklogProject = 0;

		SET @BacklogLastMonth = @BacklogLastMonth + @BacklogProject;

		FETCH NEXT FROM BacklogCursor
		INTO @ProjectID, @BacklogBase;
	END;
	CLOSE BacklogCursor;
	DEALLOCATE BacklogCursor;

	-- Final values
	IF @Backlog < @BacklogLastMonth
	BEGIN
		IF @Backlog <> 0
			SET @BacklogPercent = (@BacklogLastMonth - @Backlog) / @Backlog * 100;
		ELSE
			SET @BacklogPercent = 100;

		SET @BacklogBW = 1;
	END
	ELSE
	BEGIN
		IF @BacklogLastMonth <> 0
			SET @BacklogPercent = (@Backlog - @BacklogLastMonth) / @BacklogLastMonth * 100;
		ELSE
			SET @BacklogPercent = 100;

		SET @BacklogBW = 0;
	END;

	UPDATE ProviewTemp.dbo.AccountLandingNJ
	SET backlog=@Backlog
		,backlogBW=@BacklogBW
		,backlogPer=@BacklogPercent;
	/********************************************************************************************************************************************
	----------------------------------------------------------------- END: BACKLOG --------------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	------------------------------------------------------------------ START: A/R ---------------------------------------------------------------
	*********************************************************************************************************************************************/
	;WITH InvoiceAmount AS (
		SELECT 
			i.InvoiceID
			,i.InvoiceNumber
			,i.OwnerPayAppNumber
			,i.InvoiceDate
			,DATEDIFF(dd, CONVERT(varchar, i.InvoiceDueDate, 102), @CurrentDate) AS ARdays
			,p.ProjectID
			,p.ProjectShortName ProjectName
			,p.ProjectNum
			,ISNULL(p.FeeType,0) AS FeeTypeID
			,ISNULL(ft.val,'Fee Type') AS FeeTypeDesc
			,c.LastName AS ClientName
			,c.EntityID
			,i.InvoiceDueDate
			,i.InvoiceStatus
			,i.[Status]
			,i.InvoiceGross	
			,ISNULL(v.TotalAmountApply,0) AS PayAmount
			,CASE WHEN i.invoicestatus = 'Interim' THEN
				ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) ELSE
				ISNULL(i.InvoiceGross,0) END AS NetInvoice

			,CASE WHEN i.invoicestatus = 'Interim' THEN
				ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL(v.TotalAmountApply,0) ELSE
				ISNULL(i.InvoiceGross,0) - ISNULL(v.TotalAmountApply,0) END AS NetBalanceDueOld
		
			,CASE WHEN ISNULL(ft.val,'Fee Type')='Fixed' THEN
				CASE WHEN i.invoicestatus = 'Interim' THEN
					ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL(v.TotalAmountApply,0) ELSE
					ISNULL(i.InvoiceGross,0) - ISNULL(v.TotalAmountApply,0) END ELSE
				ISNULL(i.totalExpenseTax,0) + ISNULL(i.totalExpenseAmount,0) + ISNULL(i.totalServiceAmount,0) + ISNULL(i.totalServiceTax,0) - ISNULL(v.TotalAmountApply,0)
			END AS NetBalanceDue
			,ISNULL(i.totalExpenseTax,0) + ISNULL(i.totalExpenseAmount,0) + ISNULL(i.totalServiceAmount,0) + ISNULL(i.totalServiceTax,0) - ISNULL(v.TotalAmountApply,0) AS HourlyNetBalanceDue
			,CASE WHEN i.invoicestatus = 'Interim' THEN
				ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL(v.TotalAmountApply,0) ELSE
				ISNULL(i.InvoiceGross,0) - ISNULL(v.TotalAmountApply,0) END AS FixedNetBalanceDue
		FROM tblProject p
			JOIN tblInvoice i ON i.ProjectID = p.ProjectID
			JOIN Contacts.Entity c ON c.EntityID = p.ClientEntityID
			LEFT JOIN WebLookup.LookUpCodes ft ON ft.id = p.feetype
			LEFT JOIN viewPaymentAppliedInvoiceTotals v ON i.InvoiceID = v.InvoiceID 
			LEFT JOIN InvoicePriors ip ON ip.CurrentInvoiceID = i.invoiceid
			LEFT JOIN (
				SELECT SUM(basebudgetamount) AS basebudget, projectid
				FROM tblBudget 
				GROUP BY projectid
			) basebudget ON basebudget.projectid = p.projectid
			LEFT JOIN viewProjectBasics vp ON vp.projectid = p.projectid
			LEFT JOIN (
				SELECT SUM(totalPriceWithGCOHP) + SUM(ISNULL(salestaxamount,0)) AS totalAmt, projectid, count(*) AS ct, SUM(ttlCIMACost) AS cimacost
				FROM view_Proview_Web_Change_Order_Totals v
				WHERE (BillingStatus = 'Pending')
				GROUP BY v.projectid
			) pend ON pend.projectid = p.projectid
			LEFT JOIN (
				SELECT SUM(totalPriceWithGCOHP) + SUM(ISNULL(salestaxamount,0)) AS totalAmt, projectid, count(*) AS ct, SUM(ttlCIMACost) AS cimacost
				FROM view_Proview_Web_Change_Order_Totals v
				WHERE (BillingStatus in ('Verbally Approved', 'Approved'))
				GROUP BY v.projectid
			) app ON app.projectid = p.projectid
		WHERE 1=1
			AND i.Status != 'Void'
			AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
	)
	SELECT ia.*
		,CASE WHEN ARdays < 31THEN NetBalanceDue ELSE 0 END AS Thirty
		,CASE WHEN ARdays < 61 AND ARdays > 30THEN NetBalanceDue ELSE 0 END AS Sixty
		,CASE WHEN ARdays < 91 AND ARdays > 60THEN NetBalanceDue ELSE 0 END AS Ninety
		,CASE WHEN ARdays > 30THEN NetBalanceDue ELSE 0 END AS PastThirty
		,CASE WHEN ARdays > 45THEN NetBalanceDue ELSE 0 END AS PastFortyFive
		,CASE WHEN ARdays > 91THEN NetBalanceDue ELSE 0 END AS PastNinety
	INTO #tmpNJAR
	FROM InvoiceAmount ia
	WHERE 1=1
		AND NetBalanceDueOld > .50
		AND ProjectID > 644
	ORDER BY ClientName, ProjectNum;

	-- Populate Rec By Client Details
	DELETE FROM ProviewTemp.dbo.AccountLandingRecByClientDetailsNJ;

	INSERT INTO ProviewTemp.dbo.AccountLandingRecByClientDetailsNJ 
	SELECT EntityID, ProjectID, ProjectNum, ProjectName, SUM(NetBalanceDue), SUM(PastFortyFive)
	FROM #tmpNJAR
	GROUP BY EntityID, ProjectID, ProjectNum, ProjectName
	ORDER BY EntityID, ProjectNum;

	--------------------------------------------------------------

	SELECT @ARGT30 = ISNULL(SUM(#tmpNJAR.PastThirty),0)
	FROM #tmpNJAR;

	DELETE FROM ProviewTemp.dbo.AccountLandingRecByClientNJ;

	INSERT INTO ProviewTemp.dbo.AccountLandingRecByClientNJ (EnityID, Company, AR, AR45, LastContact)
	SELECT EntityID, ClientName, SUM(NetBalanceDue) AS AR, SUM(PastFortyFive) AS AR45, 0
	FROM #tmpNJAR
	GROUP BY EntityID, ClientName;

	UPDATE c
	SET c.LastContact=ISNULL(elc.LastContact,0)
	FROM ProviewTemp.dbo.AccountLandingRecByClientNJ c
		LEFT JOIN (
			SELECT a.EntityID, l.attribute, a.attribute AS attvalue
				,CASE WHEN ISDATE(a.attribute)=1 THEN
					DATEDIFF(dd, CAST(a.attribute AS datetime), @CurrentDate)
				 ELSE 0 END AS LastContact
			FROM WebLookup.AttributeList l
				LEFT JOIN Contacts.Attributes a ON l.attribute = a.attributetype AND ISNULL(a.Status,1) = 1
			WHERE l.attribute='EntityLastContact'
				AND NOT a.attribute IS NULL
		) elc 
		ON elc.EntityID=c.EnityID;

	DELETE FROM ProviewTemp.dbo.AccountLandingRecByAgeNJ;

	INSERT INTO ProviewTemp.dbo.AccountLandingRecByAgeNJ (Sorter, Age, AR)
	SELECT 1 AS Sorter, '0-30 days'	AS Age, SUM(Thirty) AS AR
	FROM #tmpNJAR
	HAVING SUM(Thirty)<>0
	UNION
	SELECT 2 AS Sorter, '31-60 days'	AS AgeDesc, SUM(Sixty) AS AR
	FROM #tmpNJAR
	HAVING SUM(Sixty)<>0
	UNION
	SELECT 3 AS Sorter, '61-90 days'	AS AgeDesc, SUM(Ninety) AS AR
	FROM #tmpNJAR
	HAVING SUM(Ninety)<>0
	UNION
	SELECT 4 AS Sorter, '> 90 days'	AS AgeDesc, SUM(PastNinety) AS AR
	FROM #tmpNJAR
	HAVING SUM(PastNinety)<>0;

	-------------------
	-- A/R LAST MONTH
	-------------------

	SET @DateLast30Days = DATEADD(dd, -30, @CurrentDate);

	-- Temp Table used for A/R Month
	IF OBJECT_ID('tempdb..#tmpNJARLastMonth') IS NOT NULL
		DROP TABLE #tmpNJARLastMonth;

	;WITH InvoiceAmount AS (
		SELECT i.InvoiceID
			,i.InvoiceNumber
			,i.InvoiceDate
			,CASE WHEN i.invoicestatus = 'Interim' THEN ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL([TotalAmountApply],0) ELSE ISNULL(i.InvoiceGross,0) - ISNULL([TotalAmountApply],0) END AS NetBalanceDue
			,p.ProjectShortName ProjectName
			,p.ProjectNum
			,p.ProjectID
			,p.AddDate
			,c.LastName AS ClientName
			,c.EntityID
			,DATEDIFF(dd, CONVERT(varchar, i.InvoiceDueDate, 102), @DateLast30Days) AS ARdays
		FROM tblInvoice i
			LEFT JOIN viewPaymentAppliedInvoiceTotals v ON i.InvoiceID = v.InvoiceID 
			JOIN tblProject p ON p.ProjectID = i.ProjectID
			JOIN Contacts.Entity c ON c.EntityID = p.ClientEntityID
		WHERE i.Status <> 'Void'
			AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
			AND p.AddDate<@DateLast30Days
	)
	SELECT ia.*
		,CASE WHEN ARdays < 31 THEN NetBalanceDue ELSE 0 END AS Thirty
		,CASE WHEN ARdays < 61 AND ARdays > 30 THEN NetBalanceDue ELSE 0 END AS Sixty
		,CASE WHEN ARdays < 91 AND ARdays > 60 THEN NetBalanceDue ELSE 0 END AS Ninety
		,CASE WHEN ARdays > 30 THEN NetBalanceDue ELSE 0 END AS PastThirty
		,CASE WHEN ARdays > 45 THEN NetBalanceDue ELSE 0 END AS PastFortyFive
		,CASE WHEN ARdays > 91 THEN NetBalanceDue ELSE 0 END AS PastNinety
	INTO #tmpNJARLastMonth
	FROM InvoiceAmount ia
	WHERE NetBalanceDue > .50       
		AND ProjectID > 644
	ORDER BY ClientName, ProjectNum;

	SELECT @ARGT30LastMonth = ISNULL(SUM(#tmpNJARLastMonth.PastThirty),0)
	FROM #tmpNJARLastMonth;

	IF @ARGT30 < @ARGT30LastMonth
	BEGIN
		IF @ARGT30 <> 0
			SET @ARGT30Percent = (@ARGT30LastMonth - @ARGT30) / @ARGT30 * 100;
		ELSE
			SET @ARGT30Percent = 100;

		SET @ARGT30BW = 1;
	END
	ELSE
	BEGIN
		IF @ARGT30LastMonth <> 0
			SET @ARGT30Percent = (@ARGT30 - @ARGT30LastMonth) / @ARGT30LastMonth * 100;
		ELSE
			SET @ARGT30Percent = 100;

		SET @ARGT30BW = 0;
	END;

	UPDATE ProviewTemp.dbo.AccountLandingNJ
	SET ARMore30=@ARGT30
		,ARMore30BW=@ARGT30BW
		,ARMore30Per=@ARGT30Percent;
	/********************************************************************************************************************************************
	------------------------------------------------------------------- END: A/R ----------------------------------------------------------------
	*********************************************************************************************************************************************/


	/********************************************************************************************************************************************
	------------------------------------------------------------------ START: A/P ---------------------------------------------------------------
	*********************************************************************************************************************************************/
	-- Populate temp A/P table
	SELECT i.InvoiceID
		,i.ProjectID
		,p.ProjectNum
		,p.ProjectShortName AS ProjectName
		,i.InvoiceNumber
		,i.OwnerPayAppNumber
		,i.InvoiceDate		
		,DATEDIFF(dd, CONVERT(varchar, i.InvoiceDate, 102), CONVERT(varchar, GETDATE(),102)) AS APDays
		,i.InvoiceStatus	
		,i.Status
		,i.InvoiceGross
		,ISNULL([TotalAmountApply],0) AS PayAmount
		,CASE WHEN i.invoicestatus = 'Interim' THEN ISNULL(i.totalInvoiceGross,0) - ISNULL(i.Retainage,0) ELSE ISNULL(i.totalInvoiceGross,0) END AS NetInvoice
		,CASE WHEN i.invoicestatus = 'Interim' THEN
			ISNULL(i.totalInvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL([TotalAmountApply],0) ELSE
			ISNULL(i.totalInvoiceGross,0) - ISNULL([TotalAmountApply],0)
		END AS NetBalanceDue
		--,i.InvoiceDueDate
	INTO #tmpNJAP
	FROM tblInvoice i
		JOIN tblProject p ON i.ProjectID=p.ProjectID
		LEFT JOIN viewPaymentAppliedInvoiceTotals v ON i.InvoiceID = v.InvoiceID 
	WHERE i.Status <> 'Void'
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND p.ProjectID<>1206;

	-- Populate A/P Details
	DELETE FROM ProviewTemp.dbo.AccountLandingAPDetailsNJ;

	INSERT INTO ProviewTemp.dbo.AccountLandingAPDetailsNJ
	SELECT * FROM #tmpNJAP
	WHERE APDays>0
		AND NetBalanceDue>0;

	-- Populate temp A/P Payment Applied Last Week
	SET @DateLast7Days = DATEADD(dd, -7, @CurrentDate);

	SELECT pa.InvoiceID
		,SUM(pa.AmountApply) AS TotalAmountApply
	INTO #tmpNJPaymentAppliedLastWeek
	FROM tblPayment p
		INNER JOIN tblPaymentApplied pa ON p.PaymentID = pa.PaymentID
	WHERE pa.IsDeleted='N'
		AND p.IsDeleted='N'
		AND pa.PaymentAppliedDate<@DateLast7Days
	GROUP BY pa.InvoiceID, pa.IsDeleted
	HAVING (NOT (pa.InvoiceID IS NULL));

	-- Populate temp A/P table last week
	SELECT i.ProjectID
		,p.ProjectNum
		,p.ProjectShortName AS ProjectName
		,ISNULL(v.TotalAmountApply,0) AS PayAmount
		,CASE WHEN i.invoicestatus = 'Interim' THEN ISNULL(i.InvoiceGross,0) - ISNULL(i.Retainage,0) ELSE ISNULL(i.InvoiceGross,0) END AS NetInvoice
		,CASE WHEN i.invoicestatus = 'Interim' THEN
			ISNULL(i.totalInvoiceGross,0) - ISNULL(i.Retainage,0) - ISNULL([TotalAmountApply],0) ELSE
			ISNULL(i.totalInvoiceGross,0) - ISNULL([TotalAmountApply],0)
		END AS NetBalanceDue
		,DATEDIFF(dd, CONVERT(varchar, i.InvoiceDate, 102), CONVERT(varchar, GETDATE(),102)) AS APDays
	INTO #tmpNJAPLastWeek
	FROM tblInvoice i
		JOIN tblProject p ON i.ProjectID=p.ProjectID
		LEFT JOIN #tmpNJPaymentAppliedLastWeek v ON i.InvoiceID = v.InvoiceID 
	WHERE i.Status <> 'Void'
		AND p.OurCompany IN (SELECT VALUE FROM STRING_SPLIT(@OurCompany,','))
		AND p.AddDate<@DateLast7Days
		AND p.ProjectID<>1206;
	
	-- A/P
	SELECT @AP = ISNULL(SUM(NetBalanceDue),0)
	FROM #tmpNJAP
	WHERE APDays>0
		AND NetBalanceDue>0;

	-- A/P Last week
	SELECT @APLastWeek = ISNULL(SUM(NetBalanceDue),0)
	FROM #tmpNJAPLastWeek
	WHERE APDays>0
		AND NetBalanceDue>0;

	IF @AP > @APLastWeek
	BEGIN
		IF @APLastWeek <> 0
			SET @APPercent = (@AP - @APLastWeek) / @APLastWeek * 100;
		ELSE
			SET @APPercent = 100;

		SET @APBW = 1;
	END
	ELSE
	BEGIN
		IF @AP <> 0
			SET @APPercent = (@APLastWeek - @AP) / @AP * 100;
		ELSE
			SET @APPercent = 100;

		SET @APBW = 0;
	END;

	--PRINT @AP
	--PRINT @APLastWeek
	--PRINT (@AP - @APLastWeek)
	--PRINT (@AP - @APLastWeek) / @APLastWeek
	--PRINT @APPercent

	UPDATE ProviewTemp.dbo.AccountLandingNJ
	SET AP=@AP
		,APBW=@APBW
		,APPer=@APPercent;

	/********************************************************************************************************************************************
	------------------------------------------------------------------- END: A/P ----------------------------------------------------------------
	*********************************************************************************************************************************************/

END

GO

