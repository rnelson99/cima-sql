
CREATE PROCEDURE dbo.ReceiptMatch
	@ExpGUID varchar(50), @ExpenseTotal money, @Purpose varchar(100), @ProjectID int, @DivCode int, @PhotoID varchar(100), @LongDescription varchar(max), @ChangeDateUTC datetime, @AddID int
AS
BEGIN
	
	SET NOCOUNT ON;

	if not exists (Select * from accounting.receipt where ExpenseGUID = @ExpGUID)
		begin
			Insert into accounting.receipt (ExpenseGUID, ExpenseTotal, Purpose, ProjectID, DivCode, PhotoID, AddDate, AddID, ChangeDate, ChangeID, LongDescription, ChangeDateUTC)
			select @ExpGUID, @ExpenseTotal, @Purpose, @ProjectID, @DivCode, @PhotoID, getdate(), @AddID, null, null, @LongDescription, @ChangeDateUTC
		end
    
	
END

GO

