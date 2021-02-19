
CREATE FUNCTION [dbo].[PhotoDateDiff]
(
	@datein datetime,
	@adddate datetime,
	@startdate datetime
	
)
RETURNS int
AS
BEGIN
	declare @dateUse datetime = null

	if @datein is null
	begin
		set @datein = @adddate
	end

	if @datein = '1970-01-01 00:00:00.000'
	begin
		set @dateUse = @addDate
	end
	else
	begin
		set @dateUse = @datein
	end

	if @startdate is null 
	begin
		set @startdate = getdate()
	end
	

	--select DATEDIFF(D,@startdate, @dateUse), @startDate, @dateUse
	declare @weeks int = 0
	declare @days int = DATEDIFF(D,@startdate, @dateUse)
	if @days > 0  
		begin
			--set @days = @days + 1
			declare @f float = DATEDIFF(D,@startdate, @dateUse) + 1
			declare @ff float = 7
			declare @tmp float = @f / @ff
			set @weeks = CEILING(@tmp)
			--set @weeks = @weeks + 1
		end
	
	if cast(@datein as date ) = cast(@startdate as date) or cast(@adddate as date) = cast(@startdate as date)
	begin
		Set @weeks = 1
	end
	
	RETURN @weeks
	
	--declare @f float = 8
	--declare @ff float = 7
	--declare @h decimal(18,2) = @f / @ff
	--print @h
	--print ceiling(@h)
	--select ceiling(6/7)
	--SELECT Ceiling(45.01), Ceiling(45.49), Ceiling(45.99)
	-- select dbo.PhotoDateDiff('2019-08-26 00:00:00.000', '2019-08-26 00:00:00.000', '2019-08-26 00:00:00.000')
END

GO

