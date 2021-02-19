
/*  Create view frmProjectSelectionList used as the Row Source for the
    list control (lstProjectList) on frmProjectSelection.  To allow
    filtering by CIMA_Status, Project Number, Project Name, Project City and
    Project City.  Created 28-Jun-2014  */
    CREATE VIEW frmProjectSelectionList
    AS
		SELECT a.ProjectId, a.ProjectNum, a.ProjectName, a.ProjectCity, 
		b.ClientName,a.CIMA_Status
		FROM tblProject a JOIN tblClient b ON a.ClientId=b.ClientId;

GO

