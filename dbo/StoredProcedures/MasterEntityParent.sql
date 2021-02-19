-- =============================================
-- Author:		Chris Hubbard
-- Create date: 3/25/2017
-- Description:	This will update the table anytime to make sure that the Master Entity ID is set correctly.  
--				Important for keeping all of the parents and child records linked together.
-- =============================================
CREATE PROCEDURE dbo.MasterEntityParent
	
AS
BEGIN
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#tmp') IS NOT NULL DROP TABLE #tmp
	select *, 0 as Processed into #tmp from Contacts.EntityParentChild where type in (81,82) and status = 1
	Update #tmp
		set MasterEntityID = ParentEntityID
	where ParentEntityID not in (select ChildEntityID from Contacts.EntityParentChild where status = 1  and type in (81,82)) and status = 1 and type in (81,82)

	while exists (select top 1 * from #tmp where Processed = 0 and MasterEntityID = 0)
		begin
			declare @id int = (select top 1 id from #tmp where Processed = 0 and MasterEntityID = 0)
			declare @child int = (select ChildEntityID from #tmp where id = @id)
			declare @parent int = (select ParentEntityID from #tmp where id = @id)
			declare @master int = (Select MasterEntityID from #tmp where ChildEntityID = @parent and MasterEntityID != 0)		
			update #tmp set Processed = 1, MasterEntityID = @master where id = @id
		end

	Update c
	set c.MasterEntityID = t.MasterEntityID
	from Contacts.EntityParentChild c
	join #tmp t on t.ID = c.ID

END

GO

