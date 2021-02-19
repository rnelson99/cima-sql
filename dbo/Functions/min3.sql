CREATE FUNCTION
	min3 ( @a INT, @b INT, @c INT )
RETURNS INT AS
	BEGIN
		DECLARE @min INT
		SET @min = @a
		IF ( @b < @min ) SET @min = @b
		IF ( @c < @min ) SET @min = @c
		RETURN @min
	END
;

GO

