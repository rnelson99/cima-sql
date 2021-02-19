
CREATE PROCEDURE dbo.SQLUpdateDatabase
	@sql varchar(max)
AS
BEGIN
	SET NOCOUNT ON;

	exec(@sql)
END

GO

