-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.PhoneNumberFormat
(
	-- Add the parameters for the function here
	@stringIn varchar(1000)
)
RETURNS varchar(1000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ReturnVar varchar(1000)

	if len(@stringIn) = 10 and ISNUMERIC(@stringIn) = 1
	begin
		set @ReturnVar = SubString(@stringIn, 1, 3) + '.' + 
                  SUBSTRING(@stringIn, 4, 3) + '.' + 
                  SUBSTRING(@stringIn, 7, 4)
	end
	else 
	begin
		set @ReturnVar = @stringIn
	end

	-- Return the result of the function
	RETURN @ReturnVar

END

GO

