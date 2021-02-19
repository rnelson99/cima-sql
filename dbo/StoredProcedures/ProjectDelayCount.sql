-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ProjectDelayCount]
	@projectid int,
	@maxDate date,
	@startDate1 date = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
declare @startDate2 date = (select min(startdate) as startDate
from project.delays
where projectid = @projectid)

declare @startDate date = isnull(@startDate1, @startDate2)

declare @endDate date = (select max(isnull(endDate,getdate())) as endDate 
from project.Delays 
where projectid = @projectid)


IF OBJECT_ID('tempdb..#tmpProjectDelays') IS NOT NULL DROP TABLE #tmpProjectDelays
IF OBJECT_ID('tempdb..#tmpDelays') IS NOT NULL DROP TABLE #tmpDelays
 -- drop table #tmpDelays
create table #tmpDelays (projectid int, dtDate date, delayType int, processed int)

Select projectid, isnull(delayType,0) as delayType, DelayId, isnull(startDate, getdate()) as startDate, isnull(endDate,getdate()) as endDate 
into #tmpProjectDelays 
from project.Delays 
where projectid = @projectid 
and status = 1
union select d.ProjectID, w.BadWeather, d.DailyReportID, d.dDate, d.dDate
		from project.DailyReportWeather w
		join project.ProjectDailyReport d on d.DailyReportID = w.DailyReportID and d.Status > 0 and d.ProjectID = 1247
		where w.Status = 1
		and w.BadWeather > 0 

declare @delayCount int = (Select count(*) from project.Delays where projectid = @projectid and status > 0)

if @delayCount > 0
begin
Insert into #tmpDelays (dtDate)
SELECT TOP (DATEDIFF(DAY, @startDate, @endDate) + 1)
        Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @startDate)
FROM    sys.all_objects a
        CROSS JOIN sys.all_objects b;
end

update #tmpDelays set projectid = @projectid, delayType = 0, processed = 0

update #tmpDelays set processed = 1 where dtDate > @maxDate

while exists (Select top 1 dtDate from #tmpDelays where processed = 0)
begin
	declare @dtDate date = (Select top 1 cast(dtDate as date) from #tmpDelays where processed = 0)
	print @dtDate
	declare @delayTYpe int = 0
	-- Check if we have a full delay
	if exists (select top 1 DelayId from #tmpProjectDelays 
				where cast(startDate as date) <= @dtDate 
				and cast(endDate as date) >= @dtDate  
				and delayType = 1
			)
	begin
		set @delayTYpe = 1
	end
	
	if @delayTYpe = 0
	begin
		if exists (select top 1 DelayId from #tmpProjectDelays 
					where cast(startDate as date) <= @dtDate 
					and cast(endDate as date) >= @dtDate 
					and delayType = 2
				)
		begin
			set @delayTYpe = 2
		end	
	end
	-- Check if we have a partial delay
	update #tmpDelays set delayType = @delayTYpe, processed = 1 where dtDate = @dtDate
end


declare @fulldelays int = (Select count(*) as ct from #tmpDelays where delayType = 1)
declare @partialdelays int = (Select count(*) as ct from #tmpDelays where delayType = 2)

select @fulldelays as fulldelays, @partialdelays as partialdelays, @projectid as projectid
END


update Contacts.Entity set LastName = 'no name' where EntityID = 4788

GO

