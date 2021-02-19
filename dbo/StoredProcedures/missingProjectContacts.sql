-- =============================================
-- Author:		Chris Hubbard
-- Create date: 10/13/2017
-- Description:	Gets the list of missing default contacts......
-- =============================================
-- exec dbo.missingProjectContacts 858



CREATE PROCEDURE [dbo].[missingProjectContacts]
	@projectID int
AS
BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#CompanyList') IS NOT NULL DROP TABLE #CompanyList
	IF OBJECT_ID('tempdb..#ToShow') IS NOT NULL DROP TABLE #ToShow

	create table #CompanyList ( CompanyEntityid int, ContactType int, ContactTypeDesc varchar(100), DefaultEntityID int, DefaultRole varchar(100), check1 int, check2 int, searchfield varchar(1000)  )

	Insert into #CompanyList (CompanyEntityid, ContactType, ContactTypeDesc)
	Select distinct entityid, 50, 'Onsite' 
	from tblPWALog 
	where PWAStatusID != 6 
	and projectid = @projectid 
	and entityid not in (select CompanyEntityID from project.ProjectEntity where projectid = @projectid and onsite = 1)
	
	Insert into #CompanyList (CompanyEntityid, ContactType, ContactTypeDesc)
	Select distinct entityid, 52, 'PM' 
	from tblPWALog 
	where PWAStatusID != 6 
	and projectid = @projectid 
	and entityid not in (select CompanyEntityID from project.ProjectEntity where projectid = @projectid and pm = 1)

	Insert into #CompanyList (CompanyEntityid, ContactType, ContactTypeDesc)
	Select distinct entityid, 53, 'PX' 
	from tblPWALog 
	where PWAStatusID != 6 
	and projectid = @projectid 
	and entityid not in (select CompanyEntityID from project.ProjectEntity where projectid = @projectid and px = 1)

	Update #CompanyList set DefaultEntityID = (Select top 1 EntityID from Contacts.EntityType where type = 50 and var1 = CompanyEntityid order by adddate desc) 
	where ContactType = 50

	Update #CompanyList set DefaultEntityID = (Select top 1 EntityID from Contacts.EntityType where type = 52 and var1 = CompanyEntityid order by adddate desc) 
	where ContactType = 52

	Update #CompanyList set DefaultEntityID = (Select top 1 EntityID from Contacts.EntityType where type = 53 and var1 = CompanyEntityid order by adddate desc) 
	where ContactType = 53

	update #CompanyList set check1 = 0, check2 = 0, DefaultEntityID = isnull(DefaultEntityID,0)

	update #CompanyList set check1 = 1 where isnull(DefaultEntityID,0) > 0

	select l.EntityID, sum(l.PWALogAmount) as Contract, sum(isnull(Retainage,0)) as Retainage, sum(workcompleted)-sum(isnull(Retainage,0)) as backlog
	into #ToShow
	from tblPWALog l
	join tblSubPayApp s on s.PWALogID = l.PWALogID and s.IsDeleted = 'N'
	where l.IsDeleted = 'N'  and l.ProjectID = @projectID 
	group by l.EntityID

	delete from #ToShow where Contract > 0 and Retainage <=0 and backlog <=0

	select e.lastname as CompanyName, l.ContactTypeDesc, isnull(de.EntityID,0) as DefaultEntityID, de.FirstName as defaultFirst, de.LastName as defaultLast,
		pc.JobRole, pc.JobTitle, 
			isnull(e.LastName,'') + ' ' + isnull(de.FirstName,'') + ' ' + isnull(de.LastName,'') as searchfield,
			check1, check2, 0 as check3, 'Select Other' as selectName, 0 as selectentityid, l.CompanyEntityid
	from #CompanyList l
	join Contacts.Entity e on e.EntityID = l.CompanyEntityid
	left join #ToShow zz on zz.EntityID = l.CompanyEntityid
	left join Contacts.Entity de on de.EntityID = l.DefaultEntityID
	left join Contacts.EntityParentChild pc on pc.ParentEntityID = l.CompanyEntityid and pc.ChildEntityID = de.EntityID
	order by e.LastName
END

GO

