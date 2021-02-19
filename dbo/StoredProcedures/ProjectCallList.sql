-- =============================================
-- Author:		Chris Hubbard
-- Create date: 11/14/2017
-- Description:	SPROC to pull back or insert into temp table Call List....
-- =============================================
--exec dbo.ProjectCallList 0,567
CREATE PROCEDURE [dbo].[ProjectCallList]
	@doInsert int = 0,
	@projectid int = 0,
	@sub int = 1,
	@retailer int = 1,
	@supplier int = 1
AS
BEGIN
	
	declare @areaid int = (select bidarea from tblProject where projectid = @projectid)
	set @areaid = isnull(@areaid,0)
		IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
		IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2
		IF OBJECT_ID('tempdb..#entityIDList') IS NOT NULL DROP TABLE #entityIDList
		
		
		update tblVendorConstDivCode set status = 1 where status is null
		update VendorAreas set status = 1 where status is null


		--select * from project.bidding
		if @areaid > 0
			begin
				--Insert into project.bidding (ProjectID, EntityID, DivisionID, CodeID, status)
				Select distinct @projectid as projectid, a.EntityID, z.DivisionID, z.CodeID, 1 as status
				into #Results
				from VendorAreas a
				join tblVendorConstDivCode c on c.EntityID = a.EntityID and isnull(c.Status,1) = 1
				join tblConstDivCodes z on z.CodeID = c.MasterConstDivCodeID and z.IsActive = 'Y'
				join tblConstDiv d on d.DivisionID = z.DivisionID
				join project.divCodes pd on pd.DivisionID = d.DivisionID and pd.ProjectID = @projectid and pd.Status = 1
				join contacts.entity e on e.entityid = c.entityid and e.status = 1 and e.entityid not in (select entityid from Contacts.Attributes where attributetype = 'VendorDoNotContact' and attribute = 'DO NOT USE' and status = 1)
				where 1=1
				and isnull(a.Status,1) = 1
				and (a.areaid = @areaid or a.AreaID = 1)
				
								
				delete r
				from #Results r 
				join project.bidding b on b.EntityID = r.EntityID and b.DivisionID = r.DivisionID and b.CodeID = r.CodeID and b.ProjectID = @projectid

				delete r
				from project.bidding b 
				left join #Results r on b.EntityID = r.EntityID and b.DivisionID = r.DivisionID and b.CodeID = r.CodeID
				where r.CodeID is null

				Insert into project.bidding (ProjectID, EntityID, DivisionID, CodeID, status)
				Select ProjectID, EntityID, DivisionID, CodeID, null
				from #Results
				--select * from #Results
		end
		
		create table #entityIDList (entityid int)
		
		if @retailer = 1
		begin
			Insert into #entityIDList (entityid)
			Select entityid from Contacts.EntityType where type = 42 and Status = 1 
		end
		if @sub = 1
		begin
			Insert into #entityIDList (entityid)
			Select entityid from Contacts.EntityType where type = 43 and Status = 1 
		end
		if @supplier = 1
		begin
			Insert into #entityIDList (entityid)
			Select entityid from Contacts.EntityType where type = 45 and Status = 1 
		end

		insert into #entityIDList (entityid)
		select entityid from project.bidding where manualAdd = 1 and projectid = 567

		Update b
		set b.EmployeeEntityID = t.EntityID
		from project.bidding b
		join Contacts.EntityType t on t.type = 48 and t.Status = 1 and t.var1 = b.entityid
		where isnull(b.EmployeeEntityID,0) = 0

		/*
		<!--- ******* CRITICAL   ******** --->
		<!--- if any fields are added to the query below, the table ProviewTemp.dbo.ProjectCallList must be altered to have that new field.   --->
		*/
		--select * from project.bidding
		select b.projectbidid, b.projectid, b.entityid, b.blackboard, isnull(b.status,-1) as status, l.val as statusdesc, e.LastName as company,
				d.DivisionCode, d.DivisionDescription, d.BiddingDescription, c.AcctItem, c.AcctItemDescription, c.constructiondivcode,
				isnull(ee.entityid,0) as haveemployee,
				ee.firstname, ee.lastname, isnull(ee.firstname,'') + ' ' + isnull(ee.lastname,'') as fullemployeename,
				email.contact as email,			cell.contact as mobile,			workdirect.contact as office,			b.blackboard as comments,			0 as emaildwg,
				0 as emailbidreminder, 0 as isbidding, 0 as called, 0 as selected, isnull(e.LastName,'') + ' ' + isnull(ee.firstname,'') + ' ' + isnull(ee.lastname,'') + ' ' + isnull(d.divisiondescription,'') as searchfield
			into #Results2
			from project.bidding b
			join Contacts.Entity e on e.entityid = b.entityid
				--Left join on area
				left join VendorAreas a on a.EntityID = e.EntityID and (a.AreaID = 1 or a.AreaID = @areaid) and a.Status = 1
			left join WebLookup.LookUpCodes l on l.developercode = b.status and LookupType = 'BiddingStatus' --and l.DeveloperCode not in (0,3)
			left join contacts.entity ee on ee.entityid = b.EmployeeEntityID
			left join Contacts.Contact cell on cell.EntityID = ee.entityid and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
			left join Contacts.Contact email on email.EntityID = ee.entityid and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
			left join Contacts.Contact workdirect on workdirect.EntityID = ee.entityid and workdirect.ContactType = 2 and workdirect.ContactStatus = 1 and workdirect.DefaultContact = 1
			left join tblConstDivCodes c on c.CodeID = b.codeid and c.IsActive = 'Y'
			left join tblConstDiv d on d.DivisionID = b.divisionid
			left join tblVendorConstDivCode vdc on vdc.MasterConstDivCodeID = c.CodeID and vdc.EntityID = e.EntityID and isnull(vdc.status,1) = 1
			where b.projectid = @projectid and isnull(b.isDelete,0) = 0
			and b.EntityID not in (select entityid from Contacts.Attributes where status = 1 and attributetype = 'VendorDoNotContact' and attribute = 'Stop Calling')
			and b.EntityID in (select EntityID from #entityIDList)
			and (
					b.manualAdd = 1
						or
					(
						a.AreaID is not null and vdc.VendorConstDivCodeID is not null
					)
				)
			order by ltrim(rtrim(e.LastName))

		if @doinsert = 1
		begin
			Delete from ProviewTemp.dbo.ProjectCallList where projectid = @projectid

			Insert into ProviewTemp.dbo.ProjectCallList (projectbidid ,projectid ,entityid ,blackboard ,status ,statusdesc ,company ,DivisionCode ,DivisionDescription ,BiddingDescription ,AcctItem ,AcctItemDescription ,constructiondivcode ,haveemployee ,firstname ,lastname ,fullemployeename ,email ,mobile ,office ,comments ,emaildwg ,emailbidreminder ,isbidding ,called ,selected ,searchfield)
			Select * from #Results2
			where 1=1
			and (mobile is not null or office is not null)
			order by entityid, DivisionCode
			
		end
		else
		begin
			select * from #Results2
			order by entityid, DivisionCode
		end

		IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
		IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2
			

		
END

GO

