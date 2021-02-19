-- =============================================
--update Tasks.TaskList set SoftDue = getdate()
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--exec dbo.UserTaskList 26, 1, 1, 0, 0, 0, 0, 'My Tasks'
CREATE PROCEDURE [dbo].[UserTaskList]
	@userid int = 0,
	@open int = 1,
	@closed int = 0,
	@priv int = 0,
	@pers int = 0,
	@hidd int = 0,
	@groupOnly int = 1,
	@list varchar(50) = '',
	@bugStatus int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
IF OBJECT_ID('tempdb..#Results') IS NOT NULL    DROP TABLE #Results
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL    DROP TABLE #Results2

;WITH cte AS
					(
					  SELECT
					    EntityID
					  FROM contacts.Entity
					  where entityid = @userid
					  and entitytype = 1
					  and status = 1
					  UNION ALL
					  SELECT
					    e.EntityID
					  FROM contacts.Entity e
					  INNER JOIN cte c
					    ON c.Entityid = e.Heirarchy
					  where entitytype = 1
					  and status = 1
					)

					
--select bugstatus from Tasks.TaskList

SELECT		EntityID	into #Results	FROM cte					

;with cte as (
	select t.taskid, isnull(t.projectid,0) as projectid, t.importance, t.urgency, t.hiddentill, t.softdue, t.harddue, t.harddue as DueDate, t.summary as Task,
		replace(t.longdescription,char(35),'') as LongDescription,
		t.visibility, isnull(t.parentid,0) as ParentID,
		e1.EntityID as AssignedID, e1.FirstName,
		case when e2.entityid is null then isnull(e.FirstName,'') + ' ' + isnull(e.LastName,'') else isnull(e2.FirstName,'') + ' ' + isnull(e2.LastName,'') end as AssignedFrom,
		isnull(e.FirstName,'') + ' ' + isnull(e.LastName,'') as OpenedBy,
		isnull(e1.FirstName,'') + ' ' + isnull(e1.LastName,'') as AssignedTo,
		e2.EntityID as AssignedFromID, e1.EntityID as AssignedToID,
		 DATEDIFF(DAY,getdate(),DATEADD( D,1,t.harddue))-1 as DaysTillDue,
		 DATEDIFF(DAY,getdate(),DATEADD( D,1,t.softdue))-1 as DaysTillDueSoft,
		 p.projectname as Project,
		 'Hard' as Deadline, t.Status, case when t.status = 1 then 'Open' else 'Complete' end as StatusD,
		 isnull(t.PrivateTask,0) as Private,
		 isnull(t.PersonalTask, 0) as Personal,
		 case when isnull(t.PersonalTask, 0) > 0 then pp.personalproject else p.projectname end as ProjectNamePrint,
		 isnull(t.HiddenTask,0) as Hidden,
		 isnull((select count(*) as ct from tasks.assigned where entityid = @userid and taskid = t.taskid),0) as IsUsersTask,
		 isnull((select count(*) as ct from tasks.assigned where entityid != @userid and taskid = t.taskid),0) as IsOtherUsers,
		 t.addid, RelCt.ct as RelCT, t.tasktype,
		 p.projectnum + ' ' + p.projectname + ' (' + p.CIMA_Status + ')' as projectdescription,
		 t.areasection, isnull(t.bugstatus,1) as bugstatus, isnull(bs.val,'Unassigned') as bugstatusD,
		 pp.personalproject, t.CoreTask as cCoreTask
		 ,
		 case when t.CoreTask = 1 then 'Core Task' else '' end as CoreTask
		 ,
		 case when t.softdue is null or t.softdue < getdate() then t.harddue else t.softdue end as DueDt
		 ,
		 case when t.SoftDue is null and t.HardDue is null then '' when t.softdue is null or t.softdue < getdate() then 'Hard' else 'Soft' end as DueTextType
		 ,
		 case when t.softdue is null or t.softdue < getdate() then DATEDIFF(DAY,getdate(),t.harddue) else DATEDIFF(DAY,getdate(),t.softdue) end as DaysTillUse
		 ,
		 case when e1.EntityID is null then 1 when e1.EntityID = @userid then 1 else 0 end as IsUsersTaskPrint,
		 	case when t.tasktype = 1 then null else bs.Sorter2 end as Sorter,
		 t.startDate, t.enddate,
		 isnull(a.Accepted,0) as TaskAccepted,
		 case when t.addid = @userid then 1 else 0 end as UserCreated,
		 t.adddate
	from tasks.tasklist t
	left join WebLookup.LookUpCodes bs on bs.DeveloperCode = t.bugstatus and bs.lookuptype = 'BugStatus'
	left join tasks.assigned a on a.taskid = t.taskid
	left join Contacts.Entity e on e.EntityID = t.addid
	left join Contacts.Entity e1 on e1.EntityID = a.EntityID
	left join Contacts.Entity e2 on e2.EntityID = a.AddID
	left join tblProject p on p.projectid = t.projectid
	left join dbo.personalprojects pp on pp.personalprojectid = t.projectid 
	left join (
				select count(*) as ct, mainParentID
				from tasks.tasktree
				where parentid is not null
				group by mainParentID) as RelCt on RelCt.mainParentID = t.TaskID
	where 1=1
	and t.TaskType in (1,24,25)
--	select * from tasks.TaskList where TaskType = 1
		and
		(t.addid in (select entityid from #Results)
			or
		a.entityid in (select entityid from #Results)
			or
		 a.addid in (select entityid from #Results)
		 )
	)

	select *	into #Results2	from cte	where 1=1

	/*
		The queries below will run the cleanup on the temp tables.
		alter table proviewTemp.dbo.TaskListAngAPI add bugstatus int
	*/
Delete from proviewTemp.dbo.TaskListAngAPI where userid = @userid
insert into proviewTemp.dbo.TaskListAngAPI (taskid, menugroup, userid, status, bugstatus)
Select taskid, 
	case when bugstatusD != 'Unassigned' then 'BugList' 
			when IsUsersTask = 1 and isnull(TaskAccepted,-1) = 0 then 'Inbox' 
			when IsUsersTask = 0 and AddID = @userid and IsOtherUsers = 1 then 'Delegated' 
			when IsUsersTask = 0 and IsUsersTask = 0 and IsOtherUsers = 1 then 'Organization' 
			else 'My Tasks' end, 
@userid, 1, bugstatus
from #Results2
--where status = 1

if @groupOnly = 0
begin
	if @bugStatus > 0
	begin
		Delete from #Results2 where bugstatus != @bugStatus
	end
	if @open = 0
	begin
		Delete from #Results2 where status = 1
	end
	if @closed = 0
	begin
		Delete from #Results2 where status = 0
	end	
	if @priv = 0
	begin
		Delete from #Results2 where Private = 1
	end
	if @pers = 0
	begin
		Delete from #Results2 where Personal = 1
	end
	if @hidd = 0
	begin
		Delete from #Results2 where Hidden = 1
	end
	

	select r.*
	from #Results2 r
	join proviewTemp.dbo.TaskListAngAPI z on z.taskid = r.TaskID and z.menugroup = @list and z.userid = @userid
end

	--select * from WebLookup.LookUpCodes
--	select * from proviewTemp.dbo.TaskListAngAPI where taskid = 4973
	

IF OBJECT_ID('tempdb..#Results') IS NOT NULL    DROP TABLE #Results
IF OBJECT_ID('tempdb..#Results2') IS NOT NULL    DROP TABLE #Results2					
END

GO

