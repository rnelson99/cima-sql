
		CREATE PROCEDURE dbo.RelatedTasks
			@TaskID int
		AS
		BEGIN
			SET NOCOUNT ON;

			declare @ParentID int = (Select ParentID from tasks.TaskList where taskid = @TaskID)
			set @ParentID = isnull(@ParentID,0)

			select *, 2 as Sorter, 'Current Task' as TaskDesc
				from tasks.tasklist
				where taskid = @TaskID

				--Will Show Tasks that are a child of this task
				Union Select *, 3 as Sorter, 'Child Task' as TaskDesc
				from tasks.TaskList
				where ParentID = @TaskID

				--Need to get the parent id of the current task then check for parents
				Union Select *, 1 as Sorter, 'Parent Task' as TaskDesc
				from tasks.TaskList
				where TaskID = @ParentID
			Order by Sorter

		END

GO

