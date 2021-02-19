
CREATE PROCEDURE [dbo].[CleanEntityTable]
	
AS
BEGIN
	SET NOCOUNT ON;


	


	Insert into Contacts.EntityParentChild (ParentEntityID, ChildEntityID, Type, StartDate, AddDate)
	select e.vendorentityid, e.EntityID, 18, getdate(), getdate()
	from Contacts.Entity e
	left join Contacts.EntityParentChild pc on pc.ParentEntityID = e.VendorEntityID and pc.ChildEntityID = e.EntityID
	where e.VendorEntityID is not null and pc.id is null

	Insert into Contacts.EntityParentChild (ParentEntityID, ChildEntityID, Type, StartDate, AddDate)
	select e.ClientEntityID , e.EntityID, 18, getdate(), getdate()
	from Contacts.Entity e
	left join Contacts.EntityParentChild pc on pc.ParentEntityID = e.ClientEntityID and pc.ChildEntityID = e.EntityID
	where e.ClientEntityID is not null and pc.id is null

END

GO

