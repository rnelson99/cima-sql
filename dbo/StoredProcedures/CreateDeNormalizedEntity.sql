-- =============================================
-- Author:		Chris Hubbard
-- Create date: 3/20/2017
-- Description:	Created this procedure to give an easy table to link to for the Entity information.
--				This table was setup more as a reporting table in the ProviewTemp database
--				Did this as a temp table so we would not have to call this as a view and run the joins each time.  
--				The reporting table will have all of the information that is needed so it can return back much faster on the webpages.			
-- =============================================
CREATE PROCEDURE [dbo].[CreateDeNormalizedEntity]
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY  
    -- Generate divide-by-zero error.  
		drop table proviewTemp.dbo.Entity
	END TRY  
	BEGIN CATCH  
		-- Execute error retrieval routine.  
		
	END CATCH;  

	
    


	select e.EntityID, ltrim(rtrim(e.FirstName)) as FirstName, ltrim(rtrim(e.LastName)) as LastName, e.status, e.WebLogin, e.nickname, pc.jobtitle, 
				case when e.FirstName is null then ltrim(rtrim(isnull(e.LastName,''))) else ltrim(rtrim(isnull(e.FirstName,'')  + ' ' +	isnull(e.LastName,''))) end  as ContactName,
				case when e.EntityType = 1 then 'CIMA' else pe.LastName end as Company,
				CompAdd.AddressID as cAddressID, CompAdd.Address1 as cAddress1, CompAdd.address2 as cAddress2, CompAdd.address3 as cAddress3, CompAdd.zip  as cZip, CompAdd.City as cCity, CompAdd.StateAbbr as cState, CompAdd.GooglePlaceID as CGooglePlaceID,
				MailAdd.AddressID as mAddressID, MailAdd.Address1 as mAddress1, MailAdd.address2 as mAddress2, MailAdd.address3 as mAddress3, MailAdd.zip  as mZip, MailAdd.City as mCity, MailAdd.StateAbbr as mState, MailAdd.GooglePlaceID as mGooglePlaceID,
				HomeAdd.AddressID as hAddressID, HomeAdd.Address1 as hAddress1, HomeAdd.address2 as hAddress2, HomeAdd.address3 as hAddress3, HomeAdd.zip  as hZip, HomeAdd.City as hCity, HomeAdd.StateAbbr as hState, HomeAdd.GooglePlaceID as hGooglePlaceID,
				cast(CompAdd.Address1 + ', ' + CompAdd.Address2 + ', ' + CompAdd.address3 + ', ' + CompAdd.City  + ', ' + CompAdd.Stateabbr + ' ' + CompAdd.zip as varchar(1000)) as CompanyFullAddress,
				cast(MailAdd.Address1 + ', ' + MailAdd.Address2 + ', ' + MailAdd.address3 + ', ' + MailAdd.City  + ', ' + MailAdd.Stateabbr + ' ' + MailAdd.zip as varchar(1000)) as MailFullAddress,
				cast(HomeAdd.Address1 + ', ' + HomeAdd.Address2 + ', ' + HomeAdd.address3 + ', ' + HomeAdd.City  + ', ' + HomeAdd.Stateabbr + ' ' + HomeAdd.zip as varchar(1000)) as HomeFullAddress,
				CompAdd.Latitude as CLocationCoordinates1, CompAdd.Longitude as CLocationCoordinates2, cast(CompAdd.Latitude + ', ' + CompAdd.Longitude as varchar(1000)) as CLocationCoordinates,
				MailAdd.Latitude as MLocationCoordinates1, MailAdd.Longitude as MLocationCoordinates2, cast(MailAdd.Latitude + ', ' + MailAdd.Longitude as varchar(1000)) as MLocationCoordinates,
				HomeAdd.Latitude as HLocationCoordinates1, HomeAdd.Longitude as HLocationCoordinates2, cast(MailAdd.Latitude + ', ' + MailAdd.Longitude as varchar(1000)) as HLocationCoordinates,
				e.Prefix,
				cell.Contact as usercellphone,
				email.Contact as useremail,
				work.Contact as workdirect,
				workemail.Contact as workemailsecondary,
				personalemail.Contact as personalemail,
				workdirect.Contact as workmaindirect,
				homeph.Contact  as homephone,
				pcell.Contact as personalmobile,
				wcell.Contact as mobilework,
				isnull(e.EntityID,0) as EntityID2,
				pc.StartDate, pc.EndDate
			into proviewTemp.dbo.Entity
			from proview.contacts.entity e
			left join contacts.EntityParentChild pc on pc.ChildEntityID = e.entityid
			left join contacts.entity pe on pe.entityid = pc.ParentEntityID
			left join (SELECT  a.EntityID, a.Address1, a.address2, a.address3, a.zip, a.City, a.state StateAbbr, GooglePlaceID, AddressID, a.Latitude, a.Longitude
							FROM  Contacts.Address a 
							INNER JOIN  WebLookup.LookUpCodes c ON a.AddressType = c.ID AND c.id = 15
							) as CompAdd on CompAdd.EntityID = e.EntityID
			left join (SELECT  a.EntityID, a.Address1, a.address2, a.address3, a.zip, a.City, a.state StateAbbr, GooglePlaceID, AddressID, a.Latitude, a.Longitude
						FROM  Contacts.Address a 
						INNER JOIN  WebLookup.LookUpCodes c ON a.AddressType = c.ID AND c.id = 16
						)  as MailAdd on MailAdd.EntityID = e.EntityID
			left join (SELECT  a.EntityID, a.Address1, a.address2, a.address3, a.zip, a.City, a.state StateAbbr, GooglePlaceID, AddressID, a.Latitude, a.Longitude
						FROM  Contacts.Address a 
						INNER JOIN  WebLookup.LookUpCodes c ON a.AddressType = c.ID AND c.id = 17
						) as HomeAdd on HomeAdd.EntityID = e.EntityID
			left join Contacts.Contact cell on cell.EntityID = e.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
			left join Contacts.Contact email on email.EntityID = e.EntityID and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
			left join Contacts.Contact work on work.EntityID = e.EntityID and work.ContactType = 2 and work.ContactStatus = 1 and work.DefaultContact = 1
			left join Contacts.Contact workemail on workemail.EntityID = e.EntityID and workemail.ContactType = 11 and workemail.ContactStatus = 1 and workemail.DefaultContact = 1
			left join Contacts.Contact personalemail on personalemail.EntityID = e.EntityID and personalemail.ContactType = 12 and personalemail.ContactStatus = 1 and personalemail.DefaultContact = 1
			left join Contacts.Contact workdirect on workdirect.EntityID = e.EntityID and workdirect.ContactType = 14 and workdirect.ContactStatus = 1 and workdirect.DefaultContact = 1
			left join Contacts.Contact homeph on homeph.EntityID = e.EntityID and homeph.ContactType = 1 and homeph.ContactStatus = 1 and homeph.DefaultContact = 1
			left join Contacts.Contact pcell on pcell.EntityID = e.EntityID and pcell.ContactType = 3 and pcell.ContactStatus = 1 and pcell.DefaultContact = 1
			left join Contacts.Contact wcell on wcell.EntityID = e.EntityID and wcell.ContactType = 4 and wcell.ContactStatus = 1 and wcell.DefaultContact = 1
		where 1=1


    
END

GO

