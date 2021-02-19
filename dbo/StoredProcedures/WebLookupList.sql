-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE dbo.WebLookupList
	
AS
BEGIN
	SET NOCOUNT ON;

    
	truncate table Weblookup.ProjectList
	Insert into Weblookup.ProjectList (projectid, projectname, cima_status, projectnum, showactive, showinactive, showbidding, showcloseout, showcima, shownj, rnk, projectnamenum, parentProjectID)
	select p.ProjectID, p.ProjectName, p.CIMA_Status, p.ProjectNum, s.ShowActive, s.ShowInactive, s.ShowBidding, s.ShowCloseout, s.ShowCIMA, s.ShowNJ,
		RANK() OVER(Order by ProjectNum) as rnk, p.ProjectNum + ' ' + p.ProjectName, p.parentProjectID
	from tblproject p
	join tvalProjectStatus s on s.CIMA_Status = p.CIMA_Status
	order by p.ProjectNum
END

GO

