--exec dbo.getContacts 1, 10000, 1, 1, 0, 1
CREATE PROCEDURE [dbo].[getContacts]
	-- Add the parameters for the stored procedure here
	@entityid1 int = 0,
	@entityid2 int = 999999,
	@stat1 int = 0,
	@stat2 int = 1,
	@passProject int = 0,
	@angularAPI int = 0
AS
BEGIN
	update Contacts.Address set MainPhone = replace(mainphone,'(','')
	update Contacts.Address set MainPhone = replace(mainphone,')','')
	update Contacts.Address set MainPhone = replace(mainphone,'.','')
	update Contacts.Address set MainPhone = replace(mainphone,' ','')
	IF OBJECT_ID('tempdb..#tmpTemp') IS NOT NULL DROP TABLE #tmpTemp
	
	select e.EntityID, ltrim(rtrim(e.FirstName)) as FirstName, ltrim(rtrim(e.LastName)) as LastName, e.status, e.WebLogin, e.nickname, pc.jobtitle, pc.jobrole,
			case when e.FirstName is null then ltrim(rtrim(isnull(e.LastName,''))) else ltrim(rtrim(isnull(e.FirstName,'')  + ' ' +	isnull(e.LastName,''))) end  as ContactName,
			case when e.EntityType = 1 then 'CIMA' else pe.LastName end as Company,
			'' as cAddressID, '' as cAddress1, '' as cAddress2, '' as cAddress3, ''  as cZip, '' as cCity, '' as cState, '' as CGooglePlaceID,
			'' as mAddressID, '' as mAddress1, '' as mAddress2, '' as mAddress3, ''  as mZip, '' as mCity, '' as mState, '' as mGooglePlaceID,
			'' as hAddressID, '' as hAddress1, '' as hAddress2, '' as hAddress3, ''  as hZip, '' as hCity, '' as hState, '' as hGooglePlaceID,
			'' as CompanyFullAddress,
			'' as MailFullAddress,
			'' as HomeFullAddress,
			'                                                     ' as CLocationCoordinates,
			'                                                     ' as MLocationCoordinates,
			'                                                     ' as HLocationCoordinates,
			'' as VendorDivCodes,
			isnull((select '' + STUFF((
			        select
			          'entitytype-' +  val +' '
			        from Contacts.EntityType t
					join WebLookup.LookUpCodes l on l.ID = t.Type and l.LookupType = 'EntityType'
					where t.status = 1 and EntityID = e.entityid and val not in ('Vendor','Client', 'Credit Card', 'Retailer')
			        for xml path(''), type
				    ).value('.', 'varchar(max)'), 1, 0, '') + ''),'DONOTSHOW') as EntityType,
			case when ltrim(rtrim(isnull(e.FirstName,''))) = '' then 0 else 1 end as HaveFirst,
			case when ltrim(rtrim(isnull(e.LastName,''))) = '' then 0 else 1 end as HaveLast,
			e.Prefix,
			'                                                     ' as OFFICELOCATIONCOORDINATES, 
			'                                                     ' as OFFICELOCATIONCOORDINATES1, 
			'                                                     ' as OFFICELOCATIONCOORDINATES2,
			cell.Contact as usercellphone,
			email.Contact as useremail,
				
			isnull(work.Contact,'') as workdirect,
			'' as mainoffice,
			
			workemail.Contact as workemailsecondary,
			personalemail.Contact as personalemail,
			workdir.Contact as workmaindirect,
			homeph.Contact  as homephone,
			pcell.Contact as personalmobile,
			wcell.Contact as mobilework,
			isnull(e.EntityID,0) as EntityID2,
			pc.StartDate,
			pc.EndDate
		into #tmpTemp
		from contacts.entity e
		join contacts.EntityParentChild pc on pc.ChildEntityID = e.entityid and pc.Status = 1
		left join contacts.entity pe on pe.entityid = pc.ParentEntityID
		left join Contacts.Contact cell on cell.EntityID = e.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
		left join Contacts.Contact email on email.EntityID = e.EntityID and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
		left join Contacts.Contact work on work.EntityID = e.EntityID and work.ContactType = 2 and work.ContactStatus = 1 and work.DefaultContact = 1
		left join Contacts.Contact workemail on workemail.EntityID = e.EntityID and workemail.ContactType = 11 and workemail.ContactStatus = 1 and workemail.DefaultContact = 1
		left join Contacts.Contact personalemail on personalemail.EntityID = e.EntityID and personalemail.ContactType = 12 and personalemail.ContactStatus = 1 and personalemail.DefaultContact = 1
		left join Contacts.Contact workdir on workdir.EntityID = e.EntityID and workdir.ContactType = 14 and workdir.ContactStatus = 1 and workdir.DefaultContact = 1
		left join Contacts.Contact homeph on homeph.EntityID = e.EntityID and homeph.ContactType = 1 and homeph.ContactStatus = 1 and homeph.DefaultContact = 1
		left join Contacts.Contact pcell on pcell.EntityID = e.EntityID and pcell.ContactType = 3 and pcell.ContactStatus = 1 and pcell.DefaultContact = 1
		left join Contacts.Contact wcell on wcell.EntityID = e.EntityID and wcell.ContactType = 4 and wcell.ContactStatus = 1 and wcell.DefaultContact = 1
	where 1=1
		and e.EntityID >= @entityid1 
		and e.EntityID <= @entityid2
		and e.Status in (@stat1, @stat2)

	if @passProject = 1
		begin
			Insert into #tmpTemp (EntityID, FirstName, ContactName, Company, cAddress1, cCity, cState, cZip, CompanyFullAddress, EntityType, HaveFirst, HaveLast,Status, CGooglePlaceID, CLocationCoordinates, MLocationCoordinates, HLocationCoordinates, VendorDivCodes, OFFICELOCATIONCOORDINATES, OFFICELOCATIONCOORDINATES1, OFFICELOCATIONCOORDINATES2,EntityID2,StartDate,EndDate)
			Select
			0, ltrim(rtrim(ProjectName)), ltrim(rtrim(ProjectName)), ltrim(rtrim(ProjectName)), 
			ProjectStreet, ProjectCity, ProjectState, ProjectZip,  cast(ProjectStreet  + ' ' + ' ' + ProjectCity + ' ' + ProjectState + ' ' + ProjectZip as varchar(1000)),
			'entity-Project',1,1,1, GooglePlaceID,
				isnull(ltrim(rtrim(replace(LatitudeLongitude,' ',''))),'') as CLocationCoordinates,
				case when isnull(LatitudeLongitude,'') != '' then isnull(ltrim(rtrim(LEFT(LatitudeLongitude,CHARINDEX(',',LatitudeLongitude)-1))),'') else '' end as CLocationCoordinates1,
				case when isnull(LatitudeLongitude,'') != '' then isnull(ltrim(rtrim(LTRIM(RIGHT(LatitudeLongitude,LEN(LatitudeLongitude) - CHARINDEX(',',LatitudeLongitude) )))),'') else '' end AS CLocationCoordinates2,
				'', '', '', '', 0, '', ''
			from tblProject
				where CIMA_Status = 'Active'
				and isnull(smallProject,0)=0
		end
	if @angularAPI = 0
	begin
		select * from #tmpTemp 			where EntityType != 'DONOTSHOW' 				and HaveFirst+HaveLast > 0			order by LastName
	end
	else 
	begin
		Select EntityID, isnull(FirstName,'') as FirstName, isnull(LastName,'') as lastname, replace(workdirect,'.','') as workdirect, usercellphone, 
		ContactName as fullname,
		cAddress1, cAddress2, cCity, cState, czip, JobTitle, jobrole, workmaindirect, useremail, Company
		from #tmpTemp 			where EntityType != 'DONOTSHOW' 				and HaveFirst+HaveLast > 0			order by LastName
	end
	IF OBJECT_ID('tempdb..#tmpTemp') IS NOT NULL DROP TABLE #tmpTemp
END

GO

