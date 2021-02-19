CREATE FUNCTION [dbo].[fn_StripCharacters]
(
    @String NVARCHAR(MAX), 
    @MatchExpression VARCHAR(255)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    SET @MatchExpression =  '%['+@MatchExpression+']%'

    WHILE PatIndex(@MatchExpression, @String) > 0
        SET @String = Stuff(@String, PatIndex(@MatchExpression, @String), 1, '')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
		set @string = REPLACE(@string, '  ', ' ')
    RETURN @String

END

GO

