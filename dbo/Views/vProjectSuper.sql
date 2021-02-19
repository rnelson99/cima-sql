

-- View for sfrmProjectEdit_Milestones
CREATE VIEW [dbo].[vProjectSuper]
AS


select 
p.projectid, 
p.projectname, 
p.projectnum, 
(select MilestoneDate from tblMilestone where projectid =  p.projectid and MilestoneId = 2) as msstartdate,
(select MilestoneDate from tblMilestone where projectid =  p.projectid and MilestoneId = 4) as mssubstantial,
(select MilestoneDate from tblMilestone where projectid =  p.projectid and MilestoneId = 5) as msfinal,
s.fullName as super,
s.EntityID as superEntityID,
pm.fullName as pm,
pm.EntityID as pmEntityID,
p.bidduedate
from tblProject p
join Contacts.Entity c on c.EntityID = p.ClientEntityID
left join (
			select p.ProjectID, p.EntityID, e.FirstName + ' ' + e.LastName as fullName, cell.Contact 
			from project.ProjectEntity p 
			left join contacts.entity e on e.EntityID = p.EntityID
			left join Contacts.Contact cell on cell.EntityID = p.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
			where CompanyEntityID = 25 and  p.Status = 1
			and (ProjectRole = 'Super' or ProjectEntityType = 125 or onsite = 1)
		) s ON p.ProjectID = s.ProjectID
left join (
			select p.ProjectID, p.EntityID, e.FirstName + ' ' + e.LastName as fullName, cell.Contact 
			from project.ProjectEntity p 
			left join contacts.entity e on e.EntityID = p.EntityID 
			left join Contacts.Contact cell on cell.EntityID = p.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1	
			where CompanyEntityID = 25 and p.Status = 1
			and (ProjectRole = 'PM' or ProjectEntityType = 124 or pm = 1)
			) pm ON p.ProjectID = pm.ProjectID

GO

