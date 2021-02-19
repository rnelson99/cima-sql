-- exec dbo.UserTaskCounts 1
CREATE PROCEDURE [dbo].[UserTaskCounts]
	-- Add the parameters for the stored procedure here
	@userid int = 0
AS
BEGIN
	SET NOCOUNT ON;

	
IF OBJECT_ID('tempdb..#EntityHeirarchy') IS NOT NULL
    DROP TABLE #EntityHeirarchy

IF OBJECT_ID('tempdb..#TaskResults') IS NOT NULL
    DROP TABLE #TaskResults

Delete from proviewTemp.dbo.usertasks where entityid = @userid

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

			SELECT		  *	into #EntityHeirarchy	FROM cte
	
	select t.taskid, @userid as EntityID, t.tasktype, t.bugstatus, t.Status, t.PrivateTask, t.HiddenTask, t.PersonalTask,
		isnull((select count(*) as ct from tasks.assigned where entityid = @userid and taskid = t.taskid),0) as IsUsersTask,
		isnull((select count(*) as ct from tasks.assigned where entityid != @userid and taskid = t.taskid),0) as IsOtherUsers,
		isnull(a.Accepted,0) as TaskAccepted,
		case when t.addid = @userid then 1 else 0 end as UserCreated,
		DATEDIFF(DAY,getdate(),DATEADD( D,1,t.harddue))-1 as DaysTillDue,
		 DATEDIFF(DAY,getdate(),DATEADD( D,1,t.softdue))-1 as DaysTillDueSoft
	into #TaskResults
	from tasks.tasklist t
	left join tasks.assigned a on a.taskid = t.taskid
	where 1=1
	and t.status = 1
		and
		(t.addid in (@userid)
			or
		a.entityid in (@userid)
			or 
		a.EntityID in (select entityid from #EntityHeirarchy)
			or
			t.AddID in (select entityid from #EntityHeirarchy)
		 )
		alter table #TaskResults add DaysToUse int
		alter table #TaskResults add DueGroup varchar(100)

		update #TaskResults set DaysTillDueSoft = null where DaysTillDueSoft < 0 and DaysTillDue is not null

		Update #TaskResults set DaysToUse = ISNULL(daystillduesoft,daystilldue)


		Update #TaskResults set DueGroup = 'PastDue' where DaysToUse < 0 and DueGroup is null
		Update #TaskResults set DueGroup = 'DueToday' where DaysToUse = 0 and DueGroup is null
		Update #TaskResults set DueGroup = 'DueTomorrow' where DaysToUse = 1 and DueGroup is null
		Update #TaskResults set DueGroup = 'Less1Week' where DaysToUse > 1 and DaysToUse < 8 and DueGroup is null
		Update #TaskResults set DueGroup = 'Less1Month' where DaysToUse > 7 and DaysToUse < 30 and DueGroup is null
		Update #TaskResults set DueGroup = 'More1Month' where DaysToUse > 30 and DueGroup is null
		Update #TaskResults set DueGroup = 'NoDueDate' where DaysToUse is null and DueGroup is null

		

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListUnassigned', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 1

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListInqueue', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 2

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListInProcess', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 3

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListPendingVerification', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 4

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListFuture', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 5

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListRevisionsNeeded', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 6

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'BugListOnHold', DueGroup from #TaskResults where TaskType > 20 and bugstatus = 7

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'Inbox', DueGroup from #TaskResults where isnull(TaskType,1) = 1 and status = 1 and isnull(TaskAccepted,-1) = 0	and IsUsersTask = 1	and UserCreated = 0

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'MyTasks', DueGroup from #TaskResults where isnull(TaskType,1) = 1 and status = 1 
			and (
					(IsUsersTask = 0 and IsOtherUsers = 0)
						or
					(IsUsersTask = 1 and TaskAccepted = 1)
						or 
					(UserCreated = 1 and IsOtherUsers = 0)
				)
		

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'Organization', DueGroup from #TaskResults where isnull(TaskType,1) = 1 and status = 1 and (IsUsersTask = 1 or ( UserCreated = 1 and IsOtherUsers = 0 ))

		Insert into proviewTemp.dbo.usertasks (taskid, entityid, menugroup, DueGroup)
		select taskid, @userid, 'Delegated', DueGroup from #TaskResults where isnull(TaskType,1) = 1 and status = 1 and UserCreated > 0	and IsUsersTask = 0	and IsOtherUsers > 0

		--select * from #TaskResults

		select distinct * from proviewTemp.dbo.usertasks where entityid = @userid


		IF OBJECT_ID('tempdb..#EntityHeirarchy') IS NOT NULL
			DROP TABLE #EntityHeirarchy

		IF OBJECT_ID('tempdb..#TaskResults') IS NOT NULL
			DROP TABLE #TaskResults
END

GO

