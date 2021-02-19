-- =============================================
-- Author:		Chris Hubbard
-- Create date: 10/14/2016
-- Description:	Had some issues with the SQL triggers not linking contact entity information
--				This will fix the issue.  Since the old tables will go away, this is a temp fix
--				to correct the issue and link everything up.  Will stop this procedure once we are good.
-- =============================================

--exec dbo.FixContacts

CREATE PROCEDURE [dbo].[FixContacts]
	
AS
BEGIN
	SET NOCOUNT ON;

	insert into Contacts.EntityType (EntityID, Type, AddDate, AddID, Status)
	select distinct e.entityid, 18, getdate(), 0, 1
	from Contacts.Entity e
	left join Contacts.EntityType t on t.EntityID = e.EntityID
	where t.EntityTypeID is null
	and e.LegacyTable like '%contact%'

	insert into Contacts.EntityType (EntityID, Type, AddDate, AddID, Status)
	select distinct e.entityid, 19, getdate(), 0, 1
	from Contacts.Entity e
	left join Contacts.EntityType t on t.EntityID = e.EntityID
	where t.EntityTypeID is null
	and e.LegacyTable = 'tblVendor'

	insert into Contacts.EntityType (EntityID, Type, AddDate, AddID, Status)
	select distinct e.entityid, 20, getdate(), 0, 1
	from Contacts.Entity e
	left join Contacts.EntityType t on t.EntityID = e.EntityID
	where t.EntityTypeID is null
	and e.LegacyTable = 'tblClient'

	--update Contacts.Contact set haveLine = 1 where contactid in (
	--	select c.ContactID
	--	from Contacts.Contact C
	--	join Contacts.ContactLink L on l.LinkID = c.ContactID
	--	)
	--	and isnull(haveLine,0) = 0

	delete from Contacts.Contact where Contact is null

	update c
	set c.tempEntityID = e.EntityID, c.entityid = e.entityid, c.HaveLine = 1
	from Contacts.Entity e
	join Contacts.Contact C on c.LegacyID = e.LegacyID and c.LegacyTable = e.LegacyTable-- = 'tblClientContact'
	where isnull(c.haveLine,0) = 0

	--insert into Contacts.ContactLink (EntityID, LinkType, LinkID, Status, StartDate, AddDate, AddID, Type)
	--select c.tempEntityID, c.ContactType, c.ContactID, 1, getdate(), getdate(), 0, 0
	--from Contacts.Contact c
	--where isnull(tempEntityID,0) > 0

	Update Contacts.Contact set tempEntityID = null
	    
		
	--update Contacts.ContactLink  set linktype = 13 where LinkType = 4
END

GO

