CREATE FUNCTION [dbo].[BusinessTypeRemove]
(
    @String NVARCHAR(MAX)
    
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    set @String = replace(@string,'Inc','')
	set @String = replace(@string,' Co','')
	set @String = replace(@string,' LLC','')
	set @String = replace(@string,' LP','')
	set @String = replace(@string,' Inc','')
	set @String = replace(@string,' Ltd','')

    RETURN @String

END

GO

