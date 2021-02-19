--exec dbo.TaskTreeRun
CREATE PROCEDURE [dbo].[TaskTreeRun]
	@ProcessTaskID int = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TaskTree') IS NOT NULL DROP TABLE #TaskTree

	--select * from tasks.TaskList
	--select * from tasks.TaskTree

	create table #TaskTree (TaskID int, ParentID int, Summary varchar(100), TaskTreeOrder int, Status int, Processed int, hasChild int, mainParentID int, LongDescription varchar(max))
	declare @TaskTreeOrder int = 10;

	if @ProcessTaskID = 0
	begin
		Insert into #TaskTree (TaskID, ParentID, Summary, TaskTreeOrder, Status, Processed, hasChild, mainParentID, LongDescription)
		select TaskID, ParentID, Summary, @TaskTreeOrder, Status, 0, 0, 0, LongDescription
		from tasks.TaskList
		where isnull(parentid, 0) = 0 --going to get all of the parent tasks so I can find all of the child tasks below them.
	end
	else
	begin
		Insert into #TaskTree (TaskID, ParentID, Summary, TaskTreeOrder, Status, Processed, hasChild, mainParentID, LongDescription)
		select TaskID, ParentID, Summary, @TaskTreeOrder, Status, 0, 0, 0, LongDescription
		from tasks.TaskList
		where taskid = @ProcessTaskID --going to get all of the parent tasks so I can find all of the child tasks below them.
	end
	
	declare @TaskID int = 0
	declare @ParentID int = 0
	declare @t int = 0
	While (Select count(*) from #TaskTree where Processed = 0) > 0
		begin
			declare @tmp int = @TaskTreeOrder
			
			set @TaskID = (Select top 1 taskid from #TaskTree where Processed = 0)
			declare @ParentIDTemp int = (Select top 1 ParentID from #TaskTree where TaskID = @TaskID)

			set @TaskTreeOrder = (Select TaskTreeOrder from #TaskTree where TaskID = @ParentID)
			set @TaskTreeOrder = @TaskTreeOrder + 1

			Insert into #TaskTree (TaskID, ParentID, Summary, TaskTreeOrder, Status, Processed, hasChild, mainParentID, LongDescription)
			select TaskID, ParentID, Summary, @TaskTreeOrder, Status, 0, 0, 0, LongDescription
			from tasks.TaskList
			where isnull(parentid, 0) = @taskid

			Update #TaskTree set Processed = 1 where TaskID = @TaskID
		end

		Update #TaskTree set hasChild = 1 where taskid in (select parentid from #TaskTree where isnull(parentid,0) != 0) 
		
		
	while (Select count(*) from #TaskTree where mainParentID = 0 and ParentID != 0) > 0
		begin
			set @TaskID	= (Select top 1 taskid from #TaskTree where mainParentID = 0 and ParentID != 0)
			set @t = @TaskID
			set @ParentID = (Select isnull(ParentID,0) from #TaskTree where taskid = @TaskID)
			while @ParentID > 0
				begin
					print 'hello'		
					set @TaskID = @ParentID
					set @ParentID = (Select isnull(ParentID,0) from #TaskTree where taskid = @TaskID)
				end
			update #TaskTree set mainParentID = @TaskID where taskid = @t
		end


	truncate table tasks.tasktree

	insert into tasks.tasktree (TaskID, ParentID, Summary, TaskTreeOrder, Status, hasChild, mainParentID, LongDescription)
	select TaskID, ParentID, Summary, TaskTreeOrder, Status, hasChild, mainParentID, LongDescription
	from #TaskTree

END

GO

