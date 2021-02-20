create procedure [dbo].[ProjectAdd] (
  @projectName        varchar(100)
  ,@projectShortName  varchar(24)
  ,@clientEntityId    int = 0
  ,@clientName        varchar(200)
  ,@subProjectNum     nvarchar(50) = ''
  ,@ourCompany        varchar(20)
  ,@userId            int = 0
)
as
begin
  begin try
    begin transaction
    
    if (@clientEntityId = 0 and datalength(@clientName) > 0)
      begin
      			insert into Contacts.Entity (
              LastName, ShortName, EntityType, AddDate, AddID, Status, LegacyID, LegacyTable
            )
			      select 
              @clientName
              ,@clientName
              ,0
              ,getdate()
              ,@userId
              ,1
              ,0
              , ''

            set @clientEntityId = scope_identity()

            insert into Contacts.EntityType (
              EntityID, Type, AddID, AddDate, Status
            )
            select 
              @clientEntityId
              ,20
              ,@userId
              ,getdate()
              ,1

      end

    declare @tmpProjectNumber int
    
    select @tmpProjectNumber = isnull(max(projectnum2) ,0)
    from tblProject 
    where ProjectYear = right(year(getdate()),2)

    set @tmpProjectNumber = isnull(@tmpProjectNumber,0) + 1

    if (@clientEntityId = 0)
      set @clientEntityId = 25

    declare @companyProjectLetter varchar(10) = 'C'
    if @ourCompany = 'NJ'
      set @companyProjectLetter = 'D'

    declare @projectNum nvarchar(50)

    set @projectNum = @companyProjectLetter 
      + format(getdate(), 'yy')
      + '-' + format(@tmpProjectNumber, '0000')

    if (datalength(isnull(@subProjectNum,'')) > 0)
      begin
        declare @c int
        select @c = count(*)
        from tblProject
        where
          ProjectNum2 = (Select projectnum2 from tblProject where ProjectNum = @subProjectNum)
          and ProjectYear = (Select ProjectYear from tblProject where ProjectNum = @subProjectNum)

        select @projectNum = left(@subProjectNum,8) + '.' + convert(nvarchar, @c)
      end

    if datalength(rtrim(isnull(@projectShortName,''))) = 0
      begin
        set @projectShortName = left(@projectName,20)
      end

    declare
      @projectYear varchar(10) =''
      ,@projectNum2 varchar(10)= ''

    if (datalength(@subProjectNum)) in (8,9)
      begin
        select 
          @projectYear = substring(projectnum,2,2)
          ,@projectNum2 = right(projectnum,4)
        from tblproject
        where  len(projectnum) in (8,9)
          and projectnum = @subProjectNum
      end
    
    declare @projectId int
    
    insert into tblProject ( 
      ProjectNum, ProjectName, projectshortname, ClientEntityID, CIMAChargingSalesTax, incios, OurCompany, AddID, AddDate, CIMA_Status, ClientID, ProjectYear, ProjectNum2 
    )
    select
      @projectNum
      ,@projectName
      ,@projectShortName
      ,@clientEntityId
      ,0
      ,1
      ,@ourCompany
      ,@userId
      ,getdate()
      ,'Leads'
      ,0
      ,@projectYear
      ,@projectNum2


    set @projectId = scope_identity()

    update p
    set 
      p.projectYear = z.yr
      ,p.projectNum2 = z.projectnum2
    from tblproject p
      inner join (
      select substring(projectnum,2,2) as yr, right(projectnum,4) as projectnum2, projectid
      from tblproject
      where trim(isnull(projectyear,'')) = '' and len(trim(projectnum)) = 8
      ) z on z.projectid = p.projectid
    where trim(isnull(p.projectyear,'')) = ''

    exec dbo.WebLookupList

    insert into Project.attributes (
      ProjectID, attribute, attributetype, adddate, addid, Status
    )
    select 
      @projectId
      ,case when @ourCompany = 'NJ' then
          'Plus Tax'
        else
          'Tax Included'
        end
      ,'SalesTaxApply'
      ,getdate()
      ,0, 1

    select *
    from dbo.tblProject
    where projectId = @projectId

    commit transaction
  end try
  begin catch
    if (xact_state()) = -1
      rollback transaction
    if (xact_state()) =  1
      commit transaction

    declare 
      @message varchar(MAX) = error_message()
      ,@severity int = error_severity()
      ,@state smallint = error_state()
 
   raiserror (@message, @severity, @state)
  end catch
end