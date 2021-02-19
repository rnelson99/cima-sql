CREATE VIEW dbo.viewProjectStatusReport AS

	SELECT tblProject.ProjectID, ProjectNum, ProjectName, tblProject.ClientID, ClientName, StatusID, tblProject.CIMA_Status, StatusSortOrder,
		ProjectStartDate,ms1.MilestoneDate AS ProjectSCDate, ms2.MilestoneDate AS ProjectFCDate,
		(CASE WHEN NOT ms2.MilestoneDate IS NULL THEN ms2.MilestoneDate ELSE ms1.MilestoneDate END) AS ProjectEndDate, CIMA_Bid,
		(SELECT CAST(SUM(ISNULL(Price,0)) AS MONEY) FROM viewChangeOrders WHERE ProjectID=tblProject.ProjectID AND [Status] NOT IN ('Pending','Declined')) AS ApprovedChanges,
		(SELECT CAST(SUM(ISNULL(Price,0)) AS MONEY) FROM viewChangeOrders WHERE ProjectID=tblProject.ProjectID AND [Status]='Pending') AS PendingChanges,
		(SELECT SUM(ISNULL(InvoiceAmount,0)) FROM viewPaymentProjectInvoices WHERE ProjectID=tblProject.ProjectID) AS Billed
	FROM tblClient
		INNER JOIN tblProject			ON tblClient.ClientID=tblProject.ClientID
		INNER JOIN tvalProjectStatus	ON tvalProjectStatus.CIMA_Status=tblproject.CIMA_Status
		LEFT JOIN tblMilestone ms1		ON tblProject.ProjectID=ms1.ProjectId AND ms1.MilestoneId=4
		LEFT JOIN tblMilestone ms2		ON tblProject.ProjectID=ms2.ProjectId AND ms2.MilestoneId=5

GO

