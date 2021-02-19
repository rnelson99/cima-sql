--exec dbo.VendorList

CREATE PROCEDURE [dbo].[VendorList]
	-- Add the parameters for the stored procedure here
	--@stat1 int = 0,
	--@stat2 int = 1,
	--@supplier int = 0,
	--@worker int = 0,
	--@sub int = 0,
	--@subofsub int = 0,
	--@retailer int = 0,
	--@all int = 0,
	--@Potential int = 0
AS
BEGIN
	SET NOCOUNT ON;

	--query 1 needs to be a list of All Vendor Bid areas. (DFW, AUS, OKC, etc)
	--RS1
		Select AreaID, Area, AirportCode 
		from AreaList


	-- query 2 needs to be a list of all vendor types (sub, supplier, etc)
	--RS2
		select id, val, DeveloperCode
		from WebLookup.LookUpCodes where LookupType = 'VendorType'

	-- query 3 needs to be vendors one to many allowed with the airport codes and vendor types as "LEFT" joins
	--RS3
		select e.EntityID, e.LastName, et.val as VendorType, et.id as vendortypeid, 
			isnull(f.Backlog,0) as Backlog,
			isnull(f.ApprovedContract,0) as ApprovedContract,
			isnull(f.Incomplete,0) as Incomplete,
			isnull(f.PendingSCO,0) as PendingSCO,
			isnull(f.ap,0) as ap,
			isnull(f.late,0) as late,
			isnull(f.PayAmount,0) as payamount,
			isnull(f.InProcess,0) as InProcess,
			isnull(f.PWP,0) as pwp,
			isnull(e.status,0) as status, 
			case when e.status = 1 then 'Active' else 'Inactive' end as statusdesc,
			lastcon.attribute as lastcontactdate,
			case when isnull(doNotUse.attribute,'') = '' then 0 else 1 end as PotentialVendor
		from Contacts.Entity e
		join Contacts.EntityType etv on etv.EntityID = e.EntityID and etv.Type = 19
		left join Contacts.EntityType zet on zet.EntityID = e.EntityID and zet.Status = 1 and zet.Type in (select id from WebLookup.LookUpCodes where LookupType = 'VendorType') 
		left join WebLookup.LookUpCodes et on et.ID = zet.Type
		left join dbo.viewVendorListFigures f on f.entityid = e.entityid
		left join Contacts.Attributes lastcon on lastcon.EntityID = e.EntityID and lastcon.attributetype = 'EntityLastContact' and lastcon.status = 1
		left join (select attribute, entityid from Contacts.Attributes where attributetype =  'VendorDoNotContact' and attribute = 'Potential' and status = 1) doNotUse on doNotUse.EntityID = e.EntityID 
		where e.EntityID not in (Select ChildEntityID from Contacts.EntityParentChild where status = 1 and type in (81,82))
		

				-- query 4 this returns what areas the vendors are in.
		--RS4
		select va.EntityID, al.Area, al.AreaID
		from AreaList al 
		join VendorAreas va on al.AreaID = va.AreaID and va.Status = 1
		

		--query 5
		-- RS5
		select e.EntityID, e.LastName, e.FirstName, pc.ParentEntityID, pc.type,
			case when pc.Type = 81 then 'Subsidiary' when pc.Type = 82 then 'Division' else 'Missing TYpe' end as EntityTypeDesc
		from Contacts.Entity e  
		join Contacts.EntityParentChild pc on pc.Type in (81,82) and isnull(pc.Status,1) = 1 and pc.ChildEntityID = e.EntityID
		where 1=1

		--query 6
		-- RS6
		Select sum(backlog) as backlogtotal, sum(ApprovedContract) as contracttotal,
		 sum(Incomplete) as incompletetotal,sum(AP) as aptotal, sum(Late) as latetotal,sum(InProcess) as inprocesstotal, sum(PWP) as pwptotal
		from dbo.viewVendorListFigures

		--query 7
		--rs7
--		select * from dbo.viewVendorListFiguresByProject
		Select entityid, case when cima_status in ('Active') then 'Active' when CIMA_Status in ('Closeout') then 'Closeout' else 'Inactive' end as status, 
			sum(backlog) as backlogtotal, sum(ApprovedContract) as contracttotal,
		 sum(Incomplete) as incompletetotal,sum(AP) as aptotal, sum(Late) as latetotal,sum(InProcess) as inprocesstotal, sum(PWP) as pwptotal
		from dbo.viewVendorListFiguresByProject
		group by entityid, case when cima_status in ('Active') then 'Active' when CIMA_Status in ('Closeout') then 'Closeout' else 'Inactive' end 
END

-- select * from dbo.viewVendorListFigures

GO

