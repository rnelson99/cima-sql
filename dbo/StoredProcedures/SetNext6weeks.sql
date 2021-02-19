--exec dbo.SetNext6weeks
create PROCEDURE dbo.SetNext6weeks
	
AS
BEGIN
	
	SET NOCOUNT ON;
	--select * from proviewTemp.dbo.Dates
	truncate table proviewTemp.dbo.Dates

	declare @today datetime = getdate()
	declare @insertDate datetime = @today
	declare @sixweeks datetime = dateadd(WW,6,getdate())
	declare @loop int = 1

	while (@loop = 1)
		begin
			Insert into proviewTemp.dbo.Dates (dt)
			Select @insertDate

			set @insertDate = DATEADD(D,1,@insertdate)

			if @insertDate > @sixweeks
			begin
				set @loop = 0
			end
		end



END

GO

