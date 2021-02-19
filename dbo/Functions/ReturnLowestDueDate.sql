-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[ReturnLowestDueDate]
(
	@date1 datetime,
	@date2 datetime,
	@date3 datetime
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	declare @retDateTime datetime = null

	if @date1 is not null and @date2 is not null
	begin
		if @date1 < @date2
		begin
			set @retDateTime = @date1
		end
		else
		begin
			set @retDateTime = @date2
		end
	end
	else
	begin
		if @date1 is not null set @retDateTime = @date1
		if @date2 is not null set @retDateTime = @date2
	end

	if @date3 is not null and @retDateTime is null set @retDateTime = @date3

	if @date3 is not null and @retDateTime is not null and @date3 < @retDateTime set @retDateTime = @date3

	-- Return the result of the function
	RETURN @retDateTime

END

GO

