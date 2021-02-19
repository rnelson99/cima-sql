
-- Author:		Lolt
-- Date: 20-Nov-2014
-- Description:	Build contact name from individual elements
-- =============================================
CREATE FUNCTION [dbo].[BuildContactName] 
(
	@salutation varchar(4),
	@fname varchar(45),
	@lname varchar(45)
)
RETURNS varchar(100)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result varchar(100)
	SET @Result = NULL
	IF @lname IS NOT NULL
		BEGIN
			IF @fname IS NOT NULL
				BEGIN
					IF @salutation IS NULL
						SET @result= @fname + ' ' + @lname
					ELSE
						SET @result = @salutation + ' ' +@fname + ' ' + @lname
				END
			ELSE
				IF @salutation IS NULL
					SET @result=@lname
				ELSE
					SET @result=@salutation + ' ' + @lname
		END
	-- If no last name, just use first name
	ELSE 
		IF @fname IS NOT NULL
			SET @Result=@fname	
	RETURN @result
END

GO

