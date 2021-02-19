-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[FixContactPhoneEmails]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#tmpResult') IS NOT NULL DROP TABLE #tmpResult
	;with cte as (Select ContactType, Contact, EntityID, count(*) as ct, max(contactid) as maxID
	from Contacts.Contact
	where defaultcontact = 1
	group by ContactType, Contact, EntityID
	having count(*) > 1)



	select * into #tmpResult from cte

	select * from #tmpResult

	Update c 
	set c.defaultcontact = 0
	from Contacts.Contact c
	join #tmpResult r on r.Contact = c.contact and r.ContactType = c.contacttype and r.EntityID = c.EntityID and c.ContactID != r.maxID

	Update c 
	set c.defaultcontact = 1
	from Contacts.Contact c
	join #tmpResult r on r.Contact = c.contact and r.ContactType = c.contacttype and r.EntityID = c.EntityID and c.ContactID = r.maxID


END

GO

