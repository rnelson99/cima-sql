CREATE VIEW [dbo].[viewProjectEmployeeAgg]
AS
	with pm as (select 
		p.projectId
		,STRING_AGG (CONVERT(NVARCHAR(max), isnull(pePMe.FirstName,'') + ' ' + left(isnull(pePMe.LastName,''),1)), ',') as Pm
	from
		tblProject p
		inner join contacts.BusinessEntity be on  be.BusEntityID = p.BusEntityID
		inner join project.ProjectEntity pePM on pePM.ProjectID = p.projectid and pePM.CompanyEntityID = be.companyEntityId and isnull(pepm.pm,0) = 1 and pePM.Status = 1 and isnull(pePM.complete,0) = 0
		inner join contacts.entity pePMe on pePMe.entityid = pePM.entityid
	group by p.projectId)
	,sup as (select 
		p.projectId
		,STRING_AGG (CONVERT(NVARCHAR(max), isnull(peSupe.FirstName,'') + ' ' + left(isnull(peSupe.LastName,''),1)), ',') as Sup
	from
		tblProject p
		inner join contacts.BusinessEntity be on  be.BusEntityID = p.BusEntityID
		inner join  project.ProjectEntity AS peSup ON peSup.ProjectID = p.ProjectID AND peSup.CompanyEntityID = be.CompanyEntityId AND isnull(peSup.onsite,0) = 1 AND peSup.Status = 1 AND ISNULL(peSup.complete, 0) = 0
		inner join contacts.entity peSupe on peSupe.entityid = peSup.entityid
	group by p.projectId)
	,engineer as (select 
		p.projectId
		,STRING_AGG (CONVERT(NVARCHAR(max), isnull(peEngi.FirstName,'') + ' ' + left(isnull(peEngi.LastName,''),1)), ',') as Engineer
	from
		tblProject p
		inner join contacts.BusinessEntity be on  be.BusEntityID = p.BusEntityID
		inner join project.ProjectEntity peEng on peEng.ProjectID = p.projectid and isnull(peEng.engineer,0) = 1 and peEng.Status = 1 and isnull(peEng.complete,0) = 0		
		inner join contacts.entity peEngi on peEngi.entityid = peEng.entityid
	group by p.projectId)
    select 
		p.projectId
		,pm.pm
		,sup.sup
		,engineer.engineer
	from 
		tblProject p
		inner join contacts.BusinessEntity be on  be.BusEntityID = p.BusEntityID
		left join pm on pm.projectId = p.projectId
		left join sup on sup.ProjectID = p.projectId
		left join engineer on engineer.ProjectID = p.projectId