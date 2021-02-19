
CREATE PROCEDURE dbo.tblVendorContactUpdate_FromWebApp
	
AS
BEGIN
	
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#VendorList') IS NOT NULL DROP TABLE #VendorList
	IF OBJECT_ID('tempdb..#VendorContactList') IS NOT NULL DROP TABLE #VendorContactList

	select distinct e.entityid, e.LastName, e.LegacyID, e.LegacyTable
	into #VendorList
	from Contacts.Entity e
	join Contacts.EntityType et on e.EntityID = et.EntityID and et.Type in (19,42,43,44,45,46)
	where e.LegacyID is not null


	select v.EntityID as VendorEntityID, v.LegacyID as VendorID, e.EntityID as ChildEntityID, e.FirstName as ContactName, e.Prefix , e.LastName as ContactLastName, e.LegacyID as VendorContactID, e.LegacyTable as VendorContactLegacyTable,
		(select count(*) as ct from Contacts.EntityType where entityid = e.EntityID and Type = 49) as VendorDefaultContracts,
		(select count(*) as ct from Contacts.EntityType where entityid = e.EntityID and Type = 50) as VendorDefaultJobSite,
		cell.Contact as usercellphone,
		email.Contact as useremail,
		work.Contact as workdirect
	into #VendorContactList
	from #VendorList v
	join Contacts.EntityParentChild pc on pc.ParentEntityID = v.EntityID
	join Contacts.Entity e on e.EntityID = pc.ChildEntityID and isnull(e.LegacyTable,'') != 'tblVendor'
	left join Contacts.Contact cell on cell.EntityID = e.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
	left join Contacts.Contact email on email.EntityID = e.EntityID and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
	left join Contacts.Contact work on work.EntityID = e.EntityID and work.ContactType = 2 and work.ContactStatus = 1 and work.DefaultContact = 1

	--select * from tblVendorContact where FirstName = 'christopher'



	Insert into tblVendorContact (VendorId, Salutation, FirstName, LastName, OfficePhone, MobilePhone, EMail, Title, primaryContactContracts, primaryContactJobsite, primaryContactPayApp, primaryContactWaivers, EntityID)
	Select VendorID, Prefix, ContactName, ContactLastName, workdirect, usercellphone, useremail, '', VendorDefaultContracts, VendorDefaultJobSite, 0, 0, ChildEntityID
	from #VendorContactList
	where VendorContactID is null

	Update e
	set e.LegacyID = c.ContactId,
		e.LegacyTable = 'tblVendorContact'
	from Contacts.Entity e
	join tblVendorContact c on c.entityid = e.entityid
	where e.LegacyID is null

	Update c
		set c.FirstName = v.ContactName,
			c.LastName = v.ContactLastName,
			c.Salutation = v.Prefix,
			c.OfficePhone = v.workdirect,
			c.MobilePhone = v.usercellphone,
			c.EMail = v.useremail,
			c.primaryContactContracts = v.VendorDefaultContracts,
			c.primaryContactJobsite = v.VendorDefaultJobSite
	from tblVendorContact c
	join #VendorContactList v on v.VendorContactID = c.ContactId

END

GO

