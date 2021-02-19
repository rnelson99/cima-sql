
CREATE FUNCTION dbo.ReturnLatLong
(
	-- Add the parameters for the function here
	@param1 varchar(1000),
	@param2 int 
)
RETURNS varchar(1000)
AS
BEGIN
	declare @return varchar(1000) = ''
	if len(isnull(@param1,'')) > 5 and @param2 = 1
	begin
		set @return = isnull(SUBSTRING(@param1, 1,Charindex(',',@param1)-1),'')
	end

	if len(isnull(@param1,'')) > 5 and @param2 = 2
	begin
		set @return = isnull(Substring(@param1, Charindex(',', @param1)+1, LEN(@param1)),'')
	end
	return @return
END

GO

