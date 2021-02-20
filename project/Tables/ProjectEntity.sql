CREATE TABLE [project].[ProjectEntity] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]         INT            NOT NULL,
    [EntityID]          INT            NOT NULL,
    [ProjectEntityType] INT            NOT NULL,
    [Status]            INT            NULL,
    [AddID]             INT            NULL,
    [AddDate]           DATETIME       NULL,
    [ChangeID]          INT            NULL,
    [ChangeDate]        DATETIME       NULL,
    [StartDate]         DATETIME       NULL,
    [EndDate]           DATETIME       NULL,
    [ProjectStaffID]    INT            NULL,
    [CompanyEntityID]   INT            NULL,
    [ProjectRole]       VARCHAR (50)   NULL,
    [PunchVerify]       INT            NULL,
    [onsite]            INT            NULL,
    [pm]                INT            NULL,
    [px]                INT            NULL,
    [CompanyType]       VARCHAR (1000) NULL,
    [toVerify]          BIT            DEFAULT ((0)) NULL,
    [complete]          INT            NULL,
    [distList]          INT            NULL,
    [billing]           INT            NULL,
    [bidding]           INT            NULL,
    [contracts]         INT            NULL,
    [lienwaivers]       INT            NULL,
    [Engineer]          INT            NULL,
    [architect]         INT            NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190530-174303]
    ON [project].[ProjectEntity]([ProjectID] ASC)
    INCLUDE([ID]);


GO


CREATE TRIGGER [project].[ProjectEntityTrigger]
   ON  [project].[ProjectEntity]
   AFTER Insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
		IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

		select pe.CompanyType, pe.EntityID, l.Val, pe.ID, pe.ProjectID, pe.CompanyEntityID
		into #Results
		from project.ProjectEntity pe
		join Contacts.EntityType et on et.EntityID = pe.CompanyEntityID and et.Type in (select id from WebLookup.LookUpCodes		where lookuptype = 'entitytype'		and status = 1		and id not in (36,138,82,22,18,81,23))
		join WebLookup.LookUpCodes l on l.ID = et.Type
		where pe.CompanyType is null
		order by pe.entityid


		while exists (select top 1 entityid from #Results order by entityid )
		begin
			declare @peid int = (Select top 1 id from #Results )
			declare @entityid int = (Select top 1 EntityID from #Results where id = @peid)
			declare @CompanyEntityID int = (Select top 1 CompanyEntityID from #Results where id = @peid)
			declare @projectid int = (Select top 1 projectid from #Results  where id = @peid)
			declare @val varchar(100) = (Select top 1 val from #Results  where id = @peid)
	
			update project.ProjectEntity set CompanyType = isnull(companytype,'') + @val + ','
			where projectid = @projectid and CompanyEntityID = @CompanyEntityID and id = @peid

			delete from #Results WHERE id = @peid
		end

		update project.ProjectEntity set CompanyType = replace(CompanyType, 'Vendor,','Sub,')
		where CompanyType like '%vendor,%'
END

GO

