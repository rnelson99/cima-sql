-- exec dbo.UsersTopFive 1,0
CREATE PROCEDURE [dbo].[UsersTopFive]
	@userid int,
	@topFive int
AS
BEGIN
	
	--select * from tasks.assigned
	
	declare @date date = convert(varchar(10),getdate(), 120)

	IF OBJECT_ID('tempdb..#userTopFive') IS NOT NULL DROP TABLE #userTopFive
	IF OBJECT_ID('tempdb..#userTopFiveFinal') IS NOT NULL DROP TABLE #userTopFiveFinal

	select taskid
	into #userTopFive 
	from Tasks.topFive 
	where entityid = @userid

	select t.taskid, 
		(select count(*) as ct from tasks.assigned where entityid = @userid and taskid = t.taskid and status = 1) as IsUsersTask,
				(select count(*) as ct from tasks.bugissues where AssignedTo = @userid and taskid = t.taskid and status not in (3,5,6)) as IsUsersTaskItems,
				case when t.addid = @userid then 1 else 0 end as UserCreatedTask,
				0 as removeItem
	into #userTopFiveFinal
	from Tasks.TaskList t
	join #userTopFive tt on tt.taskid = t.taskid
	where t.status = 1

	update #userTopFiveFinal set removeItem = 1 where IsUsersTask = 0 and IsUsersTaskItems = 0 and UserCreatedTask = 0

	delete from Tasks.topFive where entityid = @userid and taskid in (select taskid from #userTopFiveFinal where removeItem = 1)


	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2

	;with cte as (SELECT 
		f.id, t.TaskID, t.Summary, f.sorter, t.softdue, t.harddue,
			case when t.softdue is not null and t.harddue is not null and t.softdue >= @date then t.softdue
			when t.softdue is not null and t.harddue is null then t.softdue
			else t.harddue end as dduedate,
			(select min(duedate) from tasks.bugissues where AssignedTo = @userid and status in (1,2,4) and taskid = t.taskid) as usersMinDueDate,
			case when t.SoftDue is null then 0 else 1 end as HaveSoft,
			case when t.HardDue is null then 0 else 1 end as HaveHard,
			case when (select min(duedate) from tasks.bugissues where AssignedTo = @userid and status in (1,2,4) and taskid = t.taskid) is null then 0 else 1 end as HaveItem,
			p.projectid, p.projectnum, p.projectname as project
		from Tasks.topFive f
		join Tasks.TaskList t on t.taskid = f.taskid
		left join tblProject p on p.projectid = t.projectid
		where entityid = @userid
	)
	select *, case when usersMinDueDate is not null and usersMinDueDate < dduedate then usersMinDueDate else dduedate end as duedate
	into #Results
	from cte
	order by Sorter

	

	select *, case when SoftDue = duedate then 'soft' when HardDue = duedate then 'hard' else '' end as usingDate, 0 as Processed, 'no-format-needed' as formatting
	into #results2
	from #Results

	while exists (select top 1 * from #results2 where Processed = 0)
	begin
		declare @id int = (Select top 1 id from #results2 where processed = 0)
		declare @h int = (Select top 1 havehard from #results2 where id = @id)
		declare @s int = (Select top 1 HaveSoft from #results2 where id = @id)
		declare @i int = (Select top 1 HaveItem from #results2 where id = @id)
		declare @formatting varchar(100) = 'no-format-needed'
		declare @due datetime = (select duedate from #results2 where id = @id)
		declare @harddue datetime = (Select harddue from #results2 where id = @id)

		if @h = 1 and @harddue < @date
		begin
			set @formatting = 'past-due'
		end
		
		if @h = 1 and @harddue = @date
		begin
			set @formatting = 'due-today'
		end
		print @formatting
		if @formatting = 'no-format-needed'
		begin
		--exec dbo.UsersTopFive 26,0
			print 'output'
			print @due 
			print @date
			if @due < @date
			begin
				set @formatting = 'past-due'
			end	
			if @due = @date
			begin
				set @formatting = 'due-today'
			end
		end
		update #results2 set formatting = @formatting where id = @id
		Update #results2 set Processed = 1 where id = @id	
		print ''
	end
	
	if @topFive = 1 
	begin
		Select top 5 * from #results2
	end
	else
	begin
		Select * from #results2
	end
	

	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
	IF OBJECT_ID('tempdb..#Results2') IS NOT NULL DROP TABLE #Results2
END

GO

