--exec dbo.getVendors 1, 9999, 1, 0
CREATE PROCEDURE [dbo].[getVendors]
	-- Add the parameters for the stored procedure here
	@entityid1 int = 0,
	@entityid2 int = 999999,
	@stat1 int = 0,
	@stat2 int = 1,
	@supplier int = 0,
	@worker int = 0,
	@sub int = 0,
	@subofsub int = 0,
	@retailer int = 0,
	@all int = 0,
	@Potential int = 0
AS
BEGIN
	SET ANSI_PADDING ON

	IF OBJECT_ID('tempdb..#entVType') IS NOT NULL DROP TABLE #entVType


	--select * from WebLookup.LookUpCodes
	

	--select * from WebLookup.LookUpCodes where LookupType = 'VendorType'
	create table #entVType (entityid int, vendortype int, keepRecord int)

	insert into #entVType (entityid, vendortype, keepRecord)
	select e.entityid, isnull(zet.Type,0), 0
	from Contacts.Entity e
	left join Contacts.EntityType zet on zet.EntityID = e.EntityID and zet.Status = 1 and zet.Type in (select id from WebLookup.LookUpCodes where LookupType = 'VendorType')
	where 1=1 and e.EntityID >= @entityid1 and e.EntityID <= @entityid2
	and e.Status in (@stat1, @stat2)
	and e.EntityID not in (select ChildEntityID from Contacts.EntityParentChild where type in (81,82))

	--select * from  WebLookup.LookUpCodes

	declare @typefilter int = 0
	set @typefilter = @supplier + @worker + @sub + @subofsub + @retailer
	


	if @typefilter > 0 
		begin
			--print 'why'
			if @supplier = 1
			begin
				--delete from #entVType where vendortype != 45
				update #entVType set keepRecord = 1 where vendortype = 45
			end

			if @worker = 1
			begin
				--delete from #entVType where vendortype != 46
				update #entVType set keepRecord = 1 where vendortype = 46
			end

			if @sub = 1
			begin
				--delete from #entVType where vendortype != 43
				update #entVType set keepRecord = 1 where vendortype = 43
			end

			if @subofsub = 1
			begin
				--delete from #entVType where vendortype != 44
				update #entVType set keepRecord = 1 where vendortype = 44
			end

			if @retailer = 1
			begin
				--delete from #entVType where vendortype != 42
				update #entVType set keepRecord = 1 where vendortype = 42
			end

			delete from #entVType where isnull(keepRecord,0) = 0
		end
	else
		begin
			if @all = 0
			begin
				delete from #entVType where vendortype not in (43,45)
				--delete from #entVType where vendortype = 46
				print 'not running this section now'
			end 
			print 'hello'
		end
	create table #excludePotential (entityid int)

	if @Potential = 0
	begin
		insert into #excludePotential (entityid)
		select entityid from Contacts.Attributes
		where attribute = 'Potential' 
		and attributetype = 'VendorDoNotContact' 
		and status = 1
	end

	;with cte as (select e.EntityID, e.FirstName, e.LastName, e.status, e.WebLogin, 
		case when e.status = 1 then 'Active' else 'Inactive' end + ' ' + isnull(doNotUse.attribute,'') as VendorStatus,
			case when e.EntityType = 1 then 'CIMA' else pe.LastName end as Company,
			CompAdd.AddressID as cAddressID, CompAdd.Address1 as cAddress1, CompAdd.address2 as cAddress2, CompAdd.address3 as cAddress3, CompAdd.zip  as cZip, CompAdd.City as cCity, CompAdd.StateAbbr as cState, CompAdd.GooglePlaceID as CGooglePlaceID,
			CompAdd.Address1 + ', ' + CompAdd.Address2 + ', ' + CompAdd.address3 + ', ' + CompAdd.City  + ', ' + CompAdd.Stateabbr + ' ' + CompAdd.zip as CompanyFullAddress,
			case when ltrim(rtrim(isnull(e.FirstName,''))) = '' then 0 else 1 end as HaveFirst,
			case when ltrim(rtrim(isnull(e.LastName,''))) = '' then 0 else 1 end as HaveLast,
			isnull(a1.VendorAreaID,0) as AllTx,
			isnull(a2.VendorAreaID,0) as Austin,
			isnull(a3.VendorAreaID,0) as DFW,
			isnull(a4.VendorAreaID,0) as Houston,
			isnull(a5.VendorAreaID,0) as SanAntonio,
			isnull((select '' + STUFF((
			        select distinct
			          '' +  etlc.Val +','
						from Contacts.EntityType zet
						left join WebLookup.LookUpCodes etlc on etlc.ID = zet.Type and etlc.LookupType = 'VendorType'
						where zet.entityid = e.EntityID and zet.Status = 1
			        for xml path(''), type
				    ).value('.', 'varchar(max)'), 1, 0, '') + ''),'') as VendorType,
			isnull(f.backlog,0) as backlog, 
			isnull(f.approvedcontract,0) as approvedcontract, 
			isnull(f.pendingsco,0) as pendingsco, 
			isnull(f.ap,0) as ap, 
			isnull(f.late,0) as late, 
			isnull(f.payamount,0) as payamount, 
			isnull(f.inprocess,0) as inprocess, 
			isnull(f.PWP,0) as PWP, 
			isnull(f.INCOMPLETE,0) as INCOMPLETE,
			e.LegacyID as vendorid,
			e.LegacyTable,
			lastCON.attribute  as LastContactDate,
			newTotal.TotalContractAmount,
			newTotal.totalProjects,
			isnull(doNotUse.attribute,'') as doNotUse
		from contacts.entity e
		join Contacts.EntityType et on et.EntityID = e.EntityID and et.Type = 19
		--left join dbo.viewVendorListFigures f on f.entityid = e.entityid
		left join (select ISNULL(c.masterentityid,f.EntityID) as EntityID, sum(backlog) as backlog, sum(approvedcontract) as approvedcontract, 
						sum(incomplete) as incomplete, sum(pendingsco) as pendingsco, sum(ap) as ap, sum(late) as late, sum(payamount) as payamount, 
						sum(inprocess) as inprocess, sum(pwp) as pwp
					from dbo.viewVendorListFigures f
					left join Contacts.EntityParentChild c on c.ChildEntityID = f.EntityID and c.status = 1
					group by ISNULL(c.masterentityid,f.EntityID)) f on f.entityid = e.entityid
		left join contacts.EntityParentChild pc on pc.ChildEntityID = e.entityid
		left join contacts.entity pe on pe.entityid = pc.ParentEntityID
		left join (SELECT  a.EntityID, a.Address1, a.address2, a.address3, a.zip, a.City, a.state as StateAbbr, GooglePlaceID, AddressID
						from Contacts.Address a 
						INNER JOIN  WebLookup.LookUpCodes c ON a.AddressType = c.ID AND c.id = 15
						where a.MainOffice = 1
						) as CompAdd on CompAdd.EntityID = e.EntityID
		left join (select distinct EntityID, AreaID as VendorAreaID from VendorAreas where AreaID = 1 and isnull(Status,1)  = 1) A1 on a1.EntityID = e.EntityID
		left join (select distinct EntityID, AreaID as VendorAreaID from VendorAreas where AreaID = 2 and isnull(Status,1)  = 1) A2 on a2.EntityID = e.EntityID
		left join (select distinct EntityID, AreaID as VendorAreaID from VendorAreas where AreaID = 3 and isnull(Status,1)  = 1) A3 on a3.EntityID = e.EntityID
		left join (select distinct EntityID, AreaID as VendorAreaID from VendorAreas where AreaID = 4 and isnull(Status,1)  = 1) A4 on a4.EntityID = e.EntityID
		left join (select distinct EntityID, AreaID as VendorAreaID from VendorAreas where AreaID = 5 and isnull(Status,1)  = 1) A5 on a5.EntityID = e.EntityID
		left join (select attribute, EntityID from  Contacts.Attributes where attributetype like '%EntityLastContact%' and status = 1) lastCON on lastCON.EntityID = e.EntityID
		left join (select attribute, entityid from Contacts.Attributes where attributetype =  'VendorDoNotContact' and attribute = 'Potential' and status = 1) doNotUse on doNotUse.EntityID = e.EntityID 
		left join (SELECT SUM(PWALogAmount) AS TotalContractAmount, count(*) as totalProjects, ISNULL(c.masterentityid,l.EntityID) as EntityID
                               FROM            dbo.tblPWALog l
							   left join Contacts.EntityParentChild c on c.ChildEntityID = l.EntityID
                               WHERE        (PWAStatusID IN (5, 7)) AND (IsDeleted = 'N') AND (ProjectID IN
                                                             (SELECT        ProjectID
                                                               FROM            dbo.tblProject
                                                               WHERE        1=1))
                               GROUP BY ISNULL(c.masterentityid,l.EntityID)) newTotal on newTotal.EntityID = e.EntityID
	where 1=1
		and e.entityid in (select distinct entityid from #entVType)
		and e.entityid not in (select entityid from #excludePotential)
	)
	select * from cte 
	where 1=1
		and HaveFirst+HaveLast > 0
	--and EntityID = 416
	order by LastName
END

--select * from tblSubPayApp

GO

