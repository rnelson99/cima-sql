-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec dbo.VendorActiveTotals
create PROCEDURE dbo.VendorActiveTotals
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

    -- Insert statements for procedure here
	;with cte as (SELECT DISTINCT 
                         pwalog.EntityID, ISNULL(l1.Contract, 0) - ISNULL(backlog.PayAmount, 0) AS Backlog, ISNULL(l1.Contract, 0) AS ApprovedContract, ISNULL(l2.PayAmount, 0) AS Incomplete, 0 AS PendingSCO, 
                         ISNULL(ap.PayAmount, 0) AS AP, 0 AS Late, ISNULL(paid.PayAmount, 0) AS PayAmount, ISNULL(inProcess.PayAmount, 0) AS InProcess, ISNULL(PWP.PayAmount, 0) AS PWP, 
						 0 as ParentID
FROM            dbo.tblPWALog AS pwalog
LEFT OUTER JOIN
        (SELECT        SUM(PWALogAmount) AS Contract, EntityID
        FROM            dbo.tblPWALog
        WHERE        (PWAStatusID IN (5, 7)) AND (IsDeleted = 'N')  AND (ProjectID IN
                                        (SELECT        ProjectID
                                        FROM            dbo.tblProject
                                        WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
        GROUP BY EntityID) AS l1 ON l1.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
    (SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
    FROM            dbo.tblPWALog AS l INNER JOIN
                                dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
    WHERE        (l.IsDeleted = 'N') AND (s.AppStatus IN ('Incomplete')) AND (l.ProjectID IN
                                    (SELECT        ProjectID
                                    FROM            dbo.tblProject AS tblProject_6
                                    WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
    GROUP BY l.EntityID) AS l2 ON l2.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
    (SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
    FROM            dbo.tblPWALog AS l INNER JOIN
                                dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
    WHERE        (l.IsDeleted = 'N') AND (s.AppStatus NOT IN ('Temp')) AND (l.ProjectID IN
                                    (SELECT        ProjectID
                                    FROM            dbo.tblProject AS tblProject_5
                                    WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
    GROUP BY l.EntityID) AS backlog ON backlog.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
    (SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
    FROM            dbo.tblPWALog AS l INNER JOIN
                                dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
    WHERE        (l.IsDeleted = 'N') AND (s.AppStatus IN ('Ready to Pay', 'Check Printed')) AND (l.ProjectID IN
                                    (SELECT        ProjectID
                                    FROM            dbo.tblProject AS tblProject_4
                                    WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
    GROUP BY l.EntityID) AS ap ON ap.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
	(SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
	FROM            dbo.tblPWALog AS l INNER JOIN
								dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
	WHERE        (l.IsDeleted = 'N') AND (s.AppStatus = 'Paid') AND (l.ProjectID IN
									(SELECT        ProjectID
									FROM            dbo.tblProject AS tblProject_3
									WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
	GROUP BY l.EntityID) AS paid ON paid.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
    (SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
    FROM            dbo.tblPWALog AS l INNER JOIN
                                dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
    WHERE        (l.IsDeleted = 'N') AND (s.AppStatus = 'Approved by PM')
    GROUP BY l.EntityID) AS inProcess ON inProcess.EntityID = pwalog.EntityID 
LEFT OUTER JOIN
    (SELECT        SUM(s.WorkCompleted) AS TtlPay, SUM(s.WorkCompleted) - SUM(s.Retainage) AS PayAmount, l.EntityID
    FROM            dbo.tblPWALog AS l INNER JOIN
                                dbo.tblSubPayApp AS s ON s.PWALogID = l.PWALogID AND s.IsDeleted = 'N'
    WHERE        (l.IsDeleted = 'N') AND (s.AppStatus IN ('Pay When Paid', 'Complete-Acct')) AND (l.ProjectID IN
                                    (SELECT        ProjectID
                                    FROM            dbo.tblProject AS tblProject_2
                                    WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout'))))
    GROUP BY l.EntityID) AS PWP ON PWP.EntityID = pwalog.EntityID
WHERE        (pwalog.ProjectID IN
                             (SELECT        ProjectID
                               FROM            dbo.tblProject AS tblProject_1
                               WHERE        (CIMA_Status IN ('Active', 'Bidding', 'Awarded', 'Closeout')))) AND (pwalog.IsDeleted = 'N')
)



select * into #Results from cte

update #Results set ParentID = EntityID

Update t
set t.parentid = c.ParentEntityID
from #Results t
join Contacts.EntityParentChild c on c.ChildEntityID = t.entityid



select ParentID as EntityID, sum(Backlog) as Backlog, sum(ApprovedContract) as ApprovedContract, sum(Incomplete) as Incomplete, 
	sum(PendingSCO) as PendingSCO, sum(ap) as ap, sum(Late) as Late, sum(PayAmount) as PayAmount, sum(InProcess) as InProcess, sum(pwp) as pwp
from #Results
group by ParentID

END

GO

