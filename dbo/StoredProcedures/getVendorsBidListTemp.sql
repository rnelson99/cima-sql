
--exec dbo.getVendorsBidListTemp 0,1,0,0,0,0,0
CREATE PROCEDURE [dbo].[getVendorsBidListTemp]
	@active int = 1,
	@inactive int = 0,
	@Retailer int = 0,
	@Sub int = 1,
	@Supplier int = 0,
	@DoNotUse int = 0,
	@missing int = 0
AS
BEGIN
	SET ANSI_PADDING ON

	
--	select * from WebLookup.LookUpCodes where LookupType = 'VendorType'
	IF OBJECT_ID('tempdb..#output') IS NOT NULL DROP TABLE #output
	IF OBJECT_ID('tempdb..#entityidTemp') IS NOT NULL DROP TABLE #entityidTemp
	create table #entityidTemp (entityid int)

	if @retailer = 1 and @DoNotUse = 0
	begin
		print 'getting retailer'
		insert into #entityidTemp (entityid)
		Select EntityID
		from Contacts.EntityType
		where type = 42 and status = 1 --retailer
	end
	if @Sub = 1  and @DoNotUse = 0
	begin
		print 'getting sub'
		insert into #entityidTemp (entityid)
		Select EntityID
		from Contacts.EntityType
		where type = 43 and status = 1 --sub
	end
	if @Supplier = 1  and @DoNotUse = 0
	begin
		print 'getting supplier'
		insert into #entityidTemp (entityid)
		Select EntityID
		from Contacts.EntityType
		where type = 45 and status = 1 --supplier
	end
	if @active != 1  and @DoNotUse = 0
	begin
		Delete from #entityidTemp where entityid in (select entityid from contacts.entity where status = 1)
	end
	if @inactive != 1  and @DoNotUse = 0
	begin
		Delete from #entityidTemp where entityid in (select entityid from contacts.entity where status = 0)
	end
	
	if @DoNotUse = 1
	begin
		Delete from #entityidTemp
		Insert into #entityidTemp (entityid)
		Select entityid 
		from Contacts.Attributes
		where attributetype = 'VendorDoNotContact' 
			and status = 1 
			and attribute = 'DO NOT USE'
		union Select entityid 
		from Contacts.Attributes
		where attributetype = 'VendorDoNotContact' 
			and status = 1 
			and attribute = 'Stop Calling'
	end

	;with cte as (select e.EntityID, e.FirstName, e.LastName, e.status, e.WebLogin, case when e.status = 1 then 'Active' else 'Inactive' end as VendorStatus,
			case when e.EntityType = 1 then 'CIMA' else pe.LastName end as Company,
			case when ltrim(rtrim(isnull(e.FirstName,''))) = '' then 0 else 1 end as HaveFirst,
			case when ltrim(rtrim(isnull(e.LastName,''))) = '' then 0 else 1 end as HaveLast,
			lastCON.attribute  as LastContactDate,
			doNotContact.attribute as doNotContact,
			NoOnBidList.attribute as NotOnBidList,
			isnull(newTotal.TotalContractAmount,0) as totalcontractamount,
			isnull(newCount.totalProjects,0) as totalProjects,
			VendorBidding.attribute as VendorBidding,
			isnull(NoBidAreas.attribute,'') as nobidarea,
			case when 
				isnull(NoBidAreas.attribute,'') = 'Yes' then 0 when isnull(a.entityidArea,0) = 0 then 1 else 0  end as missingarea,
			case when isnull(divCount.EntityID,0) = 0 then 1 else 0 end as missingdiv,
			isnull(e.lastname,'') as searchfield,
			case when isnull(retailer.EntityTypeID,0) = 0 then 0 else 1 end as retailer,
			case when isnull(sub.EntityTypeID,0) = 0 then 0 else 1 end as sub,
			case when isnull(subofsub.EntityTypeID,0) = 0 then 0 else 1 end as subofsub,
			case when isnull(supplier.EntityTypeID,0) = 0 then 0 else 1 end as supplier,
			case when isnull(worker.EntityTypeID,0) = 0 then 0 else 1 end as worker,
			case when isnull(clientsvendor.EntityTypeID,0) = 0 then 0 else 1 end as clientsvendor,
			case when isnull(consultant.EntityTypeID,0) = 0 then 0 else 1 end as consultant,
			isnull((select '' + STUFF((
                                select AirportCode + ', '
                                from VendorAreas va
                                join AreaList a on a.areaid = va.AreaID
                                where va.EntityID = e.entityid and isnull(va.status,1) = 1
                                for xml path(''), type
                                ).value('.', 'varchar(max)'), 1, 0, '') + ''),'') as AirportCodeRaw,
			c.AcctItemDescription, c.ConstructionDivCode, d.DivisionCode, d.DivisionDescription,
			a.*
		from contacts.entity e
		join #entityidTemp zzTemp on zzTemp.EntityID = e.entityid
		join Contacts.EntityType et on et.EntityID = e.EntityID and et.Type in (19)
		left join (SELECT count(*) as ct, EntityID
								FROM tblVendorConstDivCode v
								JOIN tblConstDivCodes c on c.CodeID = v.MasterConstDivCodeID and c.IsActive = 'Y'
								WHERE ISNULL(v.status,1) = 1
					group by v.EntityID) divCount on divCount.EntityID = e.EntityID
		   left join tblVendorConstDivCode vc on vc.EntityID = e.EntityID and isnull(vc.Status,1) = 1
           join tblConstDivCodes c on vc.MasterConstDivCodeID = c.CodeID and c.biddingshow = 1
           join tblConstDiv d on d.DivisionID = c.DivisionID
		left join ProviewTemp.dbo.VendorAreaTemp a on a.entityidArea = e.EntityID
		left join contacts.EntityParentChild pc on pc.ChildEntityID = e.entityid
		left join contacts.entity pe on pe.entityid = pc.ParentEntityID
		left join Contacts.EntityType retailer on retailer.EntityID = e.EntityID and retailer.Type = 42 and retailer.Status = 1
		left join Contacts.EntityType sub on sub.EntityID = e.EntityID and sub.Type = 43 and sub.Status = 1
		left join Contacts.EntityType subofsub on subofsub.EntityID = e.EntityID and subofsub.Type = 44 and subofsub.Status = 1
		left join Contacts.EntityType supplier on supplier.EntityID = e.EntityID and supplier.Type = 45 and supplier.Status = 1
		left join Contacts.EntityType worker on worker.EntityID = e.EntityID and worker.Type = 46 and worker.Status = 1
		left join Contacts.EntityType clientsvendor on clientsvendor.EntityID = e.EntityID and clientsvendor.Type = 123 and clientsvendor.Status = 1
		left join Contacts.EntityType consultant on consultant.EntityID = e.EntityID and consultant.Type = 192 and consultant.Status = 1
		left join (select attribute, EntityID from  Contacts.Attributes where attributetype like '%EntityLastContact%' and status = 1) lastCON on lastCON.EntityID = e.EntityID
		left join (Select attribute, EntityID from Contacts.Attributes where attributetype = 'VendorDoNotContact' and status = 1) doNotContact on doNotContact.EntityID = e.EntityID
		left join (Select attribute, entityid from Contacts.Attributes where attributetype = 'NotOnBidList' and status = 1) NoOnBidList on NoOnBidList.EntityID = e.EntityID
		left join (Select attribute, entityid from Contacts.Attributes where attributetype = 'NoBidAreas' and status = 1) NoBidAreas on NoBidAreas.EntityID = e.EntityID

		left join (Select attribute, entityid from Contacts.Attributes where attributetype = 'VendorBidding' and status = 1) VendorBidding on VendorBidding.EntityID = e.EntityID

		left join (SELECT SUM(PWALogAmount) AS TotalContractAmount, count(*) as totalProjects, ISNULL(c.masterentityid,l.EntityID) as EntityID
                               FROM            dbo.tblPWALog l
							   left join Contacts.EntityParentChild c on c.ChildEntityID = l.EntityID
                               WHERE        (PWAStatusID IN (5, 7)) AND (IsDeleted = 'N') AND (ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject
                                                               WHERE        1=1))
                               GROUP BY ISNULL(c.masterentityid,l.EntityID)) newTotal on newTotal.EntityID = e.EntityID
		left join (SELECT count(*) as totalProjects, ISNULL(c.masterentityid,l.EntityID) as EntityID
                               FROM            dbo.tblPWALog l
							   left join Contacts.EntityParentChild c on c.ChildEntityID = l.EntityID
                               WHERE    PWALogTypeID = 1 and   (PWAStatusID IN (5, 7)) AND (IsDeleted = 'N') AND (ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject
                                                               WHERE        1=1))
                               GROUP BY ISNULL(c.masterentityid,l.EntityID)) newCount on newCount.EntityID = e.EntityID
	where 1=1
	
	)
	

	select distinct *, case when missingarea = 1 or  missingdiv = 1 then 1 else 0 end as missingdata
		into #output
		from cte 
		where 1=1
			and HaveFirst+HaveLast > 0
		order by LastName

		if @DoNotUse = 0
		begin
			Select * from #output where missingdata = @missing
		end
		else
		begin
			Select * from #output 
		end
	
END

GO

