CREATE TABLE [dbo].[tblProjectStaff] (
    [ProjectStaffID] INT          IDENTITY (1, 1) NOT NULL,
    [ProjectID]      INT          NOT NULL,
    [UserSecurityID] INT          NOT NULL,
    [StaffRole]      VARCHAR (50) NOT NULL,
    [StartDate]      DATETIME     NULL,
    [EndDate]        DATETIME     NULL,
    [EntityID]       INT          NULL,
    [PunchVerify]    BIT          DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblProjectStaff] PRIMARY KEY CLUSTERED ([ProjectStaffID] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tblProjectStaffTrigger]
   ON  [dbo].[tblProjectStaff]
   AFTER INSERT,UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	

	/*
	Update s
	set s.entityid = e.EntityID
	from tblProjectStaff s
	join Contacts.Entity e on e.LegacyID = s.UserSecurityID and e.LegacyTable = 'User'
	where isnull(s.EntityID,0) = 0


	Insert into project.projectentity (projectid, entityid, projectentitytype, status, addid, adddate)
	select s.ProjectID, s.entityid, 124, 1, 0, getdate()
	from tblProjectStaff s
	left join project.projectentity pe on pe.entityid = s.entityid and pe.projectid = s.ProjectID and pe.ProjectEntityType = 124
	where StaffRole = 'PM' and pe.id is null

	Insert into project.projectentity (projectid, entityid, projectentitytype, status, addid, adddate)
	select s.ProjectID, s.entityid, 127, 1, 0, getdate()
	from tblProjectStaff s
	left join project.projectentity pe on pe.entityid = s.entityid and pe.projectid = s.ProjectID and pe.ProjectEntityType = 127
	where StaffRole = 'PX' and pe.id is null

	Insert into project.projectentity (projectid, entityid, projectentitytype, status, addid, adddate)
	select s.ProjectID, s.entityid, 125, 1, 0, getdate()
	from tblProjectStaff s
	left join project.projectentity pe on pe.entityid = s.entityid  and pe.projectid = s.ProjectID and pe.ProjectEntityType = 125
	where StaffRole = 'Super' and pe.id is null

	*/


END

GO

