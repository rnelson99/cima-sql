CREATE FUNCTION
	levenshtein ( @s NVARCHAR( MAX ), @t NVARCHAR( MAX ) )
RETURNS INT AS
	BEGIN
		DECLARE
			@d NVARCHAR( MAX ),
			@LD INT,
			@m INT,
			@n INT,
			@i INT,
			@j INT,
			@s_i NCHAR( 1 ),
			@t_j NCHAR( 1 ),
			@cost INT

		-- Step 1 --

		SET @n = LEN( @s )
		SET @m = LEN( @t )
		SET @d = REPLICATE( NCHAR( 0 ), ( @n + 1 ) * ( @m + 1 ) )
		IF ( @n = 0 )
			BEGIN
				SET @LD = @m
				GOTO done
			END
		IF ( @m = 0 )
			BEGIN
				SET @LD = @n
				GOTO done
			END

		-- Step 2 --

		SET @i = 0
		WHILE ( @i <= @n ) BEGIN
			SET @d = STUFF( @d, @i + 1, 1, NCHAR( @i ) )
			SET @i = @i + 1
		END

		SET @i = 0
		WHILE ( @i <= @m ) BEGIN
			SET @d = STUFF( @d, @i * ( @n + 1 ) + 1, 1, NCHAR( @i ) )
			SET @i = @i+1
		END

		-- Step 3 --

		SET @i = 1
		WHILE ( @i <= @n ) BEGIN
			SET @s_i = SUBSTRING( @s, @i, 1 )

			-- Step 4 --

			SET @j = 1
			WHILE ( @j <= @m ) BEGIN
				SET @t_j = SUBSTRING( @t, @j, 1 )

				-- Step 5 --

				IF ( @s_i = @t_j )
					SET @cost = 0
				ELSE
					SET @cost = 1

				-- Step 6 --

				SET @d = STUFF(
							@d,
							@j * ( @n + 1 ) + @i + 1,
							1,
							NCHAR(
								dbo.MIN3(
									UNICODE( SUBSTRING( @d, @j * ( @n + 1 ) + @i - 1 + 1, 1 ) ) + 1,
									UNICODE( SUBSTRING( @d, ( @j - 1 ) * ( @n + 1 ) + @i + 1, 1 ) ) + 1,
									UNICODE( SUBSTRING( @d, ( @j - 1 ) * ( @n + 1 ) + @i - 1 + 1, 1 ) ) + @cost )
								)
							)
				SET @j = @j + 1
			END
			SET @i = @i + 1
		END      

		-- Step 7 --

		SET @LD = UNICODE( SUBSTRING( @d, @n * ( @m + 1 ) + @m + 1, 1 ) )

		done:
			RETURN @LD
	END
;

GO

