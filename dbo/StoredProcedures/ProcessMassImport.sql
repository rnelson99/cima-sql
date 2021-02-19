--exec dbo.ProcessMassImport 'A0A12178-04C0-4B41-8715DE63E61F3167'
CREATE PROCEDURE [dbo].[ProcessMassImport]
	@importGUID varchar(100)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	declare @keepString varchar(100) = '^a-z0-9 '
		--SELECT dbo.fn_StripCharacters('a 1 ! s   2@d3#f4$', @keepString)

	update Contacts.Entity set nameNoSpecial = dbo.BusinessTypeRemove(LastName)
	update Contacts.Entity set nameNoSpecial = dbo.fn_StripCharacters(nameNoSpecial, @keepString)

	
--	select * from proviewtemp.dbo.massVendorImport
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#alias') IS NOT NULL DROP TABLE #alias

    update ProviewTemp.dbo.massVendorImport 
	set importDivCode = 1
	where importDivCode is null

	select *, DENSE_RANK() OVER (ORDER BY companyname) AS RankNum
	into #Results
	from ProviewTemp.dbo.massVendorImport 
	where importGUID = @importGUID
	order by companyname

	alter table #results add Processed int
	

	update #Results set processed = 0

	select entityid, Alias 
	into #alias
	from Contacts.Alias where isnull(alias,'') != ''
	union select entityid, FormalName from Contacts.Address where isnull(FormalName,'') != ''

	update #alias set Alias = dbo.BusinessTypeRemove(Alias)
	update #alias set Alias = dbo.fn_StripCharacters(Alias, @keepString)

	while exists (select importid from #Results where processed = 0)
	begin
		declare @possibleDuplicate int = 0
		declare @entityid int = 0
		declare @matchOn varchar(1000) = ''
		declare @importid int = (Select top 1 importid from #Results where processed = 0)
		declare @companyName varchar(1000) = (Select companyname from #Results where importid = @importid)
		declare @phone varchar(1000) = (Select phone from #Results where importid = @importid)
		declare @mobile varchar(1000) = (Select mobile from #Results where importid = @importid)
		declare @email varchar(1000) = (Select email from #Results where importid = @importid)
		declare @AreaID int = (Select AreaID from #Results where importid = @importid)
		declare @tmpEntityID int = 0
		declare @addressMatch int = 0
		declare @companyNameMatch int = 0

		declare @address varchar(100) = (select top 1 address1 from #Results where importid = @importID)
		declare @city varchar(100) = (select top 1 city from #Results where importid = @importID)
		declare @state varchar(100) = (select top 1 state from #Results where importid = @importID)
		declare @companyNameClean varchar(100) = dbo.fn_StripCharacters(@companyName, @keepString)
		set @address = dbo.fn_StripCharacters(@address, @keepString)
		

		--4854 Olson Dr
		set @address = '%' + @address + '%'
		set @addressMatch = (select count(*) from Contacts.Address where Address1 like @address)

		set @companyNameMatch = (select count(*) from Contacts.Entity where nameNoSpecial = @companyNameClean)

		if @companyNameMatch = 0
		begin
			set @companyNameMatch = (select count(*) from #alias where Alias = @companyNameClean)
		end

		set @phone = ltrim(rtrim(stuff(@phone, 1, patindex('%[0-9]%', @phone)-1, '')))
		set @mobile = ltrim(rtrim(stuff(@mobile, 1, patindex('%[0-9]%', @mobile)-1, '')))

		set @phone = replace(@phone,'(','')
		set @phone = replace(@phone,')','')
		set @phone = replace(@phone,'-','')
		set @phone = replace(@phone,' ','')

		set @mobile = replace(@mobile,'(','')
		set @mobile = replace(@mobile,')','')
		set @mobile = replace(@mobile,'-','')
		set @mobile = replace(@phone,' ','')

		set @email = ltrim(rtrim(@email))

		print @phone

		declare @entityid1 int = 0
		declare @entityid2 int = 0
		declare @entityid3 int = 0

		if @phone != ''
		begin
			set @tmpEntityID = isnull((select top 1 entityid from Contacts.Contact where contact = @phone order by ContactStatus desc),0)
			if @tmpEntityID > 0
			begin
				set @entityid1 = @tmpEntityID
				set @matchOn = @matchOn + ', ' + 'Phone'
				Set @entityid = @tmpEntityID
				print @matchOn
			end
		end

		if @mobile != ''
		begin
			set @tmpEntityID = isnull((select top 1 entityid from Contacts.Contact where contact = @mobile order by ContactStatus desc),0)
			if @tmpEntityID > 0
			begin
				set @entityid2 = @tmpEntityID
				set @matchOn = @matchOn + ', ' + 'Mobile'
				Set @entityid = @tmpEntityID
			end
		end

		if @email != ''
		begin
			set @tmpEntityID = isnull((select top 1 entityid from Contacts.Contact where contact = @email order by ContactStatus desc),0)
			if @tmpEntityID > 0
			begin
				set @entityid3 = @tmpEntityID
				set @matchOn = @matchOn + ', ' + 'Email'
				Set @entityid = @tmpEntityID
			end
		end



		declare @CompanyEntityIDCreated int = (Select top 1 isnull(CompanyEntityIDCreated,0) as CompanyEntityIDCreated from logDatabase.dbo.massVendorImport where origcompanyname = @companyName)
		declare @alreadyImported int = (Select count(*) from logDatabase.dbo.massVendorImport where origcompanyname = @companyName)
		declare @alreadyImportedArea int = (Select count(*) from logDatabase.dbo.massVendorImport where origcompanyname = @companyName and AreaID = @AreaID)
		
		--update Contacts.Entity set nameNoSpecial = dbo.BusinessTypeRemove(LastName)
		--update Contacts.Entity set nameNoSpecial = dbo.fn_StripCharacters(nameNoSpecial, @keepString)

		if @alreadyImported > 0
		begin
			Update proviewtemp.dbo.massVendorImport set alreadyImported = 1, importCompany = 0, importContact = 0, importDivCode = 0
			where importid = @importid
			
			set @alreadyImported = 1
		end


		if @CompanyEntityIDCreated > 0
		begin
			declare @EmployeeEntityIDCreated int = (Select top 1 isnull(EmployeeEntityIDCreated,0) as EmployeeEntityIDCreated from logDatabase.dbo.massVendorImport where origcompanyname = @companyName)
			Update ProviewTemp.dbo.massVendorImport 
			set CompanyEntityIDCreated = @CompanyEntityIDCreated,
			EmployeeEntityIDCreated = @EmployeeEntityIDCreated
			where importid = @importid
		end

		


		update #Results 
		set processed = 1,
			possibleDuplicate = @possibleDuplicate,
			entityid = @entityid,
			matchOn = @matchOn,
			alreadyImported = @alreadyImported,
			entityid1 = @entityid1,
			entityid2 = @entityid2,
			entityid3 = @entityid3,
			alreadyImportedArea = @alreadyImportedArea,
			CompanyEntityIDCreated = @CompanyEntityIDCreated,
			EmployeeEntityIDCreated = @EmployeeEntityIDCreated,
			companyNameMatch = @companyNameMatch,
			addressMatch = @addressMatch
		where importid = @importid
	end

	update #Results set runImport = 1 where isnull(possibleDuplicate,0) = 0 and isnull(alreadyImported,0) = 0
	
	


	update #Results set runImport = 0 where isnull(alreadyImported,0) = 1

	update ProviewTemp.dbo.massVendorImport 
		set origCompanyName = companyname,
			origFirstName = FirstName,
			origLastName = LastName,
			origEmail = Email,
			origPhone = Phone,
			origMobile = Mobile,
			origAddress1 = Address1,
			origAddress2 = Address2,
			origCity = City,
			origFax = Fax,
			origState = [State]
	where importGUID = @importGUID

	select r.*, 
		e1.FirstName + ' ' +  e1.LastName as Entity1, 
		e2.FirstName + ' ' +  e2.LastName as Entity2, 
		e3.FirstName + ' ' +  e3.LastName as Entity3
	from #Results r
	left join Contacts.Entity e1 on e1.EntityID = r.entityid1
	left join Contacts.Entity e2 on e2.EntityID = r.entityid2
	left join Contacts.Entity e3 on e3.EntityID = r.entityid3
	order by r.companyname
END
--exec dbo.ProcessMassImport '131E24F4-0BDF-47F9-9C7784631C1D6C40'

GO

