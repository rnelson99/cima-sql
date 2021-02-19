-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec dbo.ExpensePartialMatch
CREATE PROCEDURE [dbo].[ExpensePartialMatch]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

;with cte  as (select id, startwithmatchname, p.entityid, dense_RANK() OVER   
    (PARTITION BY startwithmatchname ORDER BY p.entityid ) AS Rank, VendorCCName,
	e.LastName as VendorEntityName, e.EntityID as VendorEntityID, startwithmatchname as origstartwithmatchname
from Expense.expensepartialmatch p
join Contacts.Entity e on e.EntityID = p.entityid

)
select *, 0 as processed, ROW_NUMBER()  over(order by startwithmatchname) as row
into #Results
from cte
order by startwithmatchname



while exists (select top 1 row from #Results where processed = 0)
begin
	declare @row int = (select top 1 row from #Results where processed = 0)
	declare @sw varchar(1000) = (select top 1 startwithmatchname from #Results where row = @row)
	declare @vn varchar(1000) = (select top 1 vendorccname from #Results where row = @row)
	set @sw = isnull(@sw,ltrim(rtrim(SUBSTRING(@vn, 1, CHARINDEX(' ', @vn + ' ') - 1))))
	print '~' + @sw + '~'
	declare @osw varchar(1000) = @sw
	declare @entityid int = (Select top 1 entityid from #Results where row = @row)
	declare @ct int = (Select count(*) ct from #Results where startwithmatchname like  @sw + '%' and entityid != @entityid)
	print @ct
	if @ct > 0 
	begin
		declare @l int = len(@sw)
		print @l
		set @l = @l + 2
		print @l
		set @sw = left(@vn, @l)
		if @sw != @osw
		begin
			print 'here'
			update #Results set processed = 0, startwithmatchname = @sw where row = @row
		end
		else
		begin
			print '~' + @sw + '~'
			print '~' + @osw + '~'
			update #Results set processed = 2, startwithmatchname = @sw where row = @row
		end
	end 
	else
	begin
		print 'here 11'
		update #Results set startwithmatchname = @sw where row = @row
		update #Results set processed = 1 where row = @row
	end
	
end

update p
set p.startwithmatchname = r.startwithmatchname
from Expense.expensepartialmatch p
join #Results r on r.id = p.id 





END

GO

