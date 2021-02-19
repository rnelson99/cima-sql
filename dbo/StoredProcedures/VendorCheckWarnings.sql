-- exec dbo.VendorCheckWarnings 8840
CREATE PROCEDURE [dbo].[VendorCheckWarnings]
	@SubPayAppDetailID int, @a int = 1
AS
BEGIN
	
	SET NOCOUNT ON;

declare @SubPayAppID int = (Select SubPayAppID from accounting.SubPayAppDetail where SubPayAppDetailID = @SubPayAppDetailID)    
declare @projectid int = (select ProjectID from accounting.SubPayApp where SubPayAppID = @SubPayAppID)
declare @entityid int =  (select EntityID from accounting.SubPayApp where SubPayAppID = @SubPayAppID)

;with cte as (Select e.EntityID as vendorentityid, e.LastName as vendorname, gl.Amount as GL_Amount, gl.Expiration as GL_Expiration,
        au.Amount as AU_Amount, au.Expiration as AU_Expiration,
        um.Amount as UM_Amount, um.Expiration as UM_Expiration,
        ag.agentname, ag.agency, ag.phone as agent_phone, ag.email as agent_email,
        vencon.FirstName + ' ' + vencon.LastName as vendor_name, vencon.email as vendor_email, vencon.phone as vendor_phone,
        isnull(DATEDIFF(D,getdate(),gl.Expiration),-999) as GL_EXP_DATE_DIFF,
        isnull(DATEDIFF(D,getdate(),au.Expiration),-999) as au_EXP_DATE_DIFF,
        isnull(DATEDIFF(D,getdate(),um.Expiration),-999) as um_EXP_DATE_DIFF
    from Contacts.Entity e 
    left join (Select EntityID, Amount, Expiration from Contacts.Insurance where InsuranceType = 76 and status = 1) gl on gl.EntityID = e.EntityID
    left join (Select EntityID, Amount, Expiration from Contacts.Insurance where InsuranceType = 75 and status = 1) au on au.EntityID = e.EntityID
    left join (Select EntityID, Amount, Expiration from Contacts.Insurance where InsuranceType = 78 and status = 1) um on um.EntityID = e.EntityID
    left join (select entityid, agentname, agency, phone, email from Contacts.InsuranceAgent where status = 1) ag on ag.entityid = e.EntityID
    left join (Select pc.ParentEntityID, pc.ChildEntityID, e.FirstName, e.LastName, 
                    coalesce(email.Contact, peremail.contact,'') as email,
                    coalesce(workdirect.Contact, cell.contact, personalMobile.contact,'') as phone,
                    RANK() OVER (PARTITION BY pc.parententityid ORDER BY isnull(et.rnk,99)) as rnk
                from Contacts.EntityParentChild pc
                join Contacts.Entity e on e.EntityID = pc.ChildEntityID and e.Status = 1
                left join Contacts.Contact cell on cell.EntityID = e.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
                left join Contacts.Contact peremail on peremail.EntityID = e.EntityID and peremail.ContactType = 12 and peremail.ContactStatus = 1 and peremail.DefaultContact = 1
                left join Contacts.Contact email on email.EntityID = e.EntityID and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
                left join Contacts.Contact workdirect on workdirect.EntityID = e.EntityID and workdirect.ContactType = 2 and workdirect.ContactStatus = 1 and workdirect.DefaultContact = 1
                left join Contacts.Contact personalMobile on personalMobile.EntityID = e.EntityID and personalMobile.ContactType = 3 and personalMobile.ContactStatus = 1 and personalMobile.DefaultContact = 1
                left join (
                            select et.EntityID, ett.val, ett.ID,
                                case when ett.id = 400 then 1 when ett.id = 49 then 2 when ett.id = 47 then 3 else 4 end as sorter,
                                Rank() over (partition by entityid order by case when ett.id = 400 then 1 when ett.id = 49 then 2 when ett.id = 47 then 3 else 4 end, entityid desc) as rnk
                            from Contacts.EntityType et
                            join WebLookup.LookUpCodes ett on ett.LookupType = 'VendorDefaultContacts' and ett.ID = et.Type			
                        ) et on et.EntityID = e.EntityID
                where pc.Type = 18 and pc.Status = 1
                ) vencon on vencon.ChildEntityID = e.EntityID and vencon.rnk = 1
    )

    ,cte2 as (Select e.EntityID as vendorentityid, e.LastName as vendorname, 
        vencon.FirstName, vencon.LastName, vencon.email, vencon.phone,
        vencon.FirstName + ' ' + vencon.LastName as vendor_name, vencon.email as vendor_email, vencon.phone as vendor_phone,
        mast.Expires as MAST_EXPIRE_DATE,
        isnull(DATEDIFF(D,getdate(),mast.Expires),-999) as MAT_EXP_DATE_DIFF,
        tx83.Expires as TX83_EXPIRE_DATE,
        isnull(DATEDIFF(D,getdate(),tx83.Expires),-999) as TX83_EXP_DATE_DIFF,
        tx83.Expires as TX85_EXPIRE_DATE,
        isnull(DATEDIFF(D,getdate(),tx85.Expires),-999) as TX85_EXP_DATE_DIFF
    from Contacts.Entity e 
    left join (
                select isnull(f.formid,0) as formid, l.id as FormTypeID, f.EntityID, f.FormType, 
                            f.Executed as Executed, isnull(f.Filed,-1) as Filed, f.Expires, f.status, f.addid, f.adddate, l.val as formname, isnull(d.DocumentID,0) as DocumentID, l.varFloat1
                        , d.FileName, d.FileNameOnly
                        from WebLookup.LookUpCodes l
                        left join Contacts.forms f on l.ID = f.formtype and f.status = 1 
                        left join Documents.Documents d on d.DocumentID = f.DocumentID and d.status = 1
                        where l.LookupType = 'VendorForms' and l.id = 95 --master
            ) mast on mast.EntityID = e.EntityID
    left join (
                select isnull(f.formid,0) as formid, l.id as FormTypeID, f.EntityID, f.FormType, 
                            f.Executed as Executed, isnull(f.Filed,-1) as Filed, f.Expires, f.status, f.addid, f.adddate, l.val as formname, isnull(d.DocumentID,0) as DocumentID, l.varFloat1
                        , d.FileName, d.FileNameOnly
                        from WebLookup.LookUpCodes l
                        left join Contacts.forms f on l.ID = f.formtype and f.status = 1 
                        left join Documents.Documents d on d.DocumentID = f.DocumentID and d.status = 1
                        where l.LookupType = 'VendorForms' and l.id = 96 --TX-83
            ) tx83 on tx83.EntityID = e.EntityID
    left join (
                select isnull(f.formid,0) as formid, l.id as FormTypeID, f.EntityID, f.FormType, 
                            f.Executed as Executed, isnull(f.Filed,-1) as Filed, f.Expires, f.status, f.addid, f.adddate, l.val as formname, isnull(d.DocumentID,0) as DocumentID, l.varFloat1
                        , d.FileName, d.FileNameOnly
                        from WebLookup.LookUpCodes l
                        left join Contacts.forms f on l.ID = f.formtype and f.status = 1 
                        left join Documents.Documents d on d.DocumentID = f.DocumentID and d.status = 1
                        where l.LookupType = 'VendorForms' and l.id = 97 --TX-85
            ) tx85 on tx85.EntityID = e.EntityID
    left join (Select pc.ParentEntityID, pc.ChildEntityID, e.FirstName, e.LastName, 
                    coalesce(email.Contact, peremail.contact,'') as email,
                    coalesce(workdirect.Contact, cell.contact, personalMobile.contact,'') as phone,
                    RANK() OVER (PARTITION BY pc.parententityid ORDER BY isnull(et.rnk,99)) as rnk
                from Contacts.EntityParentChild pc
                join Contacts.Entity e on e.EntityID = pc.ChildEntityID and e.Status = 1
                left join Contacts.Contact cell on cell.EntityID = e.EntityID and cell.ContactType = 13 and cell.ContactStatus = 1 and cell.DefaultContact = 1
                left join Contacts.Contact peremail on peremail.EntityID = e.EntityID and peremail.ContactType = 12 and peremail.ContactStatus = 1 and peremail.DefaultContact = 1
                left join Contacts.Contact email on email.EntityID = e.EntityID and email.ContactType = 10 and email.ContactStatus = 1 and email.DefaultContact = 1
                left join Contacts.Contact workdirect on workdirect.EntityID = e.EntityID and workdirect.ContactType = 2 and workdirect.ContactStatus = 1 and workdirect.DefaultContact = 1
                left join Contacts.Contact personalMobile on personalMobile.EntityID = e.EntityID and personalMobile.ContactType = 3 and personalMobile.ContactStatus = 1 and personalMobile.DefaultContact = 1
                left join (
                            select et.EntityID, ett.val, ett.ID,
                                case when ett.id = 400 then 1 when ett.id = 49 then 2 when ett.id = 47 then 3 else 4 end as sorter,
                                Rank() over (partition by entityid order by case when ett.id = 400 then 1 when ett.id = 49 then 2 when ett.id = 47 then 3 else 4 end, entityid desc) as rnk
                            from Contacts.EntityType et
                            join WebLookup.LookUpCodes ett on ett.LookupType = 'VendorDefaultContacts' and ett.ID = et.Type			
                        ) et on et.EntityID = e.EntityID
                where pc.Type = 18 and pc.Status = 1
                ) vencon on vencon.ChildEntityID = e.EntityID and vencon.rnk = 1
    )

    Select  vendorentityid, 'Expired/Missing Insurance' as warning, 0 as severity
    from cte c
    left join Contacts.Attributes a on a.EntityID = c.vendorentityid and a.status = 1 and a.attributetype = 'MissingInsuranceOverride'
    where 1=1
    and (
            GL_EXP_DATE_DIFF < 0
                or 
            au_EXP_DATE_DIFF < 0
                or
            um_EXP_DATE_DIFF < 0
        )
    and a.AttributeID is null
	and c.vendorentityid = @entityid
	and 1=@a
    
    union select EntityID, 'Vendor Stop Pay All Projects', 1 as severity
    from Contacts.Attributes
    where attributetype = 'VendorStopPay' and attribute = '1' and status = 1
	and EntityID = @entityid

    union select VendorID, Summary, 1 as severity
    from Tasks.TaskList 
    where isnull(vendorid,0) > 0
    and projectid = @projectid
    and vendorWarningAllProjects = 0
    and isnull(vendorWarning,0) > 0
	and VendorID = @entityid

    union select VendorID, Summary, 1 as severity
    from Tasks.TaskList 
    where isnull(vendorid,0) > 0
    and vendorWarningAllProjects = 1
    and isnull(vendorWarning,0) > 0
	and VendorID = @entityid

    union Select vendorentityid, 'Expired/Missing Vendor Forms' as warning, 0
    from cte2 c
    left join Contacts.Attributes a on a.EntityID = c.vendorentityid and a.status = 1 and a.attributetype = 'MissingVendorFormsOverride'
    where 1=1
    and (
            MAT_EXP_DATE_DIFF < 0
                or 
            TX83_EXP_DATE_DIFF < 0
                or
            TX85_EXP_DATE_DIFF < 0
        )
    and a.AttributeID is null
	and c.vendorentityid = @entityid
	and 1=@a

    order by severity desc, warning
END

GO

