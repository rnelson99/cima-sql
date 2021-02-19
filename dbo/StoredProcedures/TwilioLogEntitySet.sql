-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TwilioLogEntitySet]

--exec [dbo].[TwilioLogEntitySet]
	
AS
BEGIN
	
	SET NOCOUNT ON;
	IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results

	select * 
	into #Results
	from tblTwilloLog
	where toentityid is null

	while exists (select twillologid from #Results) 
	begin
		declare @twillologid int = (select top 1 TwilloLogID from #Results)
		declare @ToNumber varchar(100) = (Select ToNumber from #Results where TwilloLogID = @twillologid)
		declare @FromNumber varchar(100) = (Select FromNumber from #Results where TwilloLogID = @twillologid)

		set @ToNumber = replace(@tonumber,'+','')
		set @ToNumber = replace(@tonumber,' ','')
		if len(@ToNumber) = 11 
		begin
			set @ToNumber = right(@tonumber,10)
		end
		declare @ToEntityID int = (select top 1 entityid from Contacts.Contact where Contact = @ToNumber and ContactStatus = 1 and DefaultContact = 1)

		set @FromNumber = replace(@FromNumber,'+','')
		set @FromNumber = replace(@FromNumber,' ','')
		if len(@FromNumber) = 11 
		begin
			set @FromNumber = right(@FromNumber,10)
		end
		declare @FromEntityID int = (select top 1 entityid from Contacts.Contact where Contact = @FromNumber and ContactStatus = 1 and DefaultContact = 1)

		Update tblTwilloLog set ToEntityID = @ToEntityID, FromEntityID = @FromEntityID, ToNumber = @ToNumber, FromNumber = @FromNumber
		where TwilloLogID = @twillologid

		delete from #Results where TwilloLogID = @twillologid
	end

	update tblTwilloLog set FromNumber = replace(fromnumber,'+','')
	update tblTwilloLog set FromNumber = replace(fromnumber,' ','')

	update tblTwilloLog set FromNumber = right(fromnumber,10)
	where len(fromnumber) = 11

	update l
	set l.fromentityid = n.assignedTo
	from tblTwilloLog l
	join users.twilioNumbers n on n.number = l.FromNumber and n.Status = 1
	where FromEntityID is null

	update l
	set l.assignedto = n.assignedto
	from tblTwilloLog l
	join users.twilioNumbers n on n.number = l.FromNumber and n.Status = 1
	where l.assignedto = 0
	
	update l
	set l.assignedto = n.assignedto
	from tblTwilloLog l
	join users.twilioNumbers n on n.number = l.ToNumber and l.Status = 1
	where l.assignedto = 0
END

GO

