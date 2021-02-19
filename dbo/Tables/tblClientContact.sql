CREATE TABLE [dbo].[tblClientContact] (
    [ContactId]               INT           IDENTITY (1, 1) NOT NULL,
    [ClientId]                INT           NOT NULL,
    [Salutation]              VARCHAR (4)   NULL,
    [FirstName]               VARCHAR (45)  NULL,
    [LastName]                VARCHAR (45)  NULL,
    [OfficePhone]             VARCHAR (25)  NULL,
    [MobilePhone]             VARCHAR (25)  NULL,
    [EMail]                   VARCHAR (150) NULL,
    [Title]                   VARCHAR (130) NULL,
    [primaryContactBid]       BIT           CONSTRAINT [DF__tblClient__prima__1273C1CD] DEFAULT ((0)) NOT NULL,
    [primaryContactContracts] BIT           CONSTRAINT [DF__tblClient__prima__1367E606] DEFAULT ((0)) NOT NULL,
    [primaryContactBilling]   BIT           CONSTRAINT [DF__tblClient__prima__145C0A3F] DEFAULT ((0)) NOT NULL,
    [primaryContactWaivers]   BIT           CONSTRAINT [DF__tblClient__prima__15502E78] DEFAULT ((0)) NOT NULL,
    [FullName]                AS            ([dbo].[BuildContactName]([Salutation],[FirstName],[LastName])),
    CONSTRAINT [tblClientContact_PK] PRIMARY KEY NONCLUSTERED ([ContactId] ASC)
);


GO

CREATE TRIGGER [dbo].[tblClientContactTrigger]
   ON  dbo.tblClientContact
   AFTER INSERT,Update, Delete
AS 
BEGIN
	declare @ContactID int = 0
	DECLARE @action  CHAR(6), @success BIT;
	SELECT @action  = 'DELETE', @success = 1;

  IF EXISTS (SELECT 1 FROM inserted)
  BEGIN
    IF EXISTS (SELECT 1 FROM deleted)
      SET @action = 'UPDATE';
    ELSE
      SET @action = 'INSERT';
  END

  if @action = 'Update'
	begin
		--set @ContactID = (select top 1 ContactId FROM INSERTED)
		Update e
			set e.Prefix = c.Salutation,
				e.FirstName = c.FirstName,
				e.LastName = c.LastName,
				e.ChangeDate = getdate(),
				e.ChangeID = 0
			from Contacts.Entity e
			join tblClientContact c on c.ContactId = e.LegacyID
			Where e.LegacyID in (select ContactId FROM INSERTED) and e.LegacyTable = 'tblClientContact'
		


		if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and contacttype = 2  and LegacyTable = 'tblClientContact')
			begin
				Update p
				set p.contact = i.OfficePhone
				from Contacts.Contact p
				join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblClientContact' 
				where p.ContactType = 2
			end
		else 
			begin
				Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
				select 2, OfficePhone, 1, ContactID, 'tblClientContact'
				from inserted
			end

		if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and contacttype = 4  and LegacyTable = 'tblClientContact')
			begin
				Update p
				set p.contact = i.MobilePhone
				from Contacts.Contact p
				join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblClientContact' 
				where p.ContactType = 4
			end
		else 
			begin
				Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
				select 4, MobilePhone, 1, ContactID, 'tblClientContact'
				from inserted
			end

		if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and contacttype = 10  and LegacyTable = 'tblClientContact')
			begin
				Update p
				set p.contact = i.EMail
				from Contacts.Contact p
				join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblClientContact' 
				where p.ContactType = 10
			end
		else 
			begin
				Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
				select 10, EMail, 1, ContactID, 'tblClientContact'
				from inserted
			end
	

	end
	
	if @action = 'INSERT'
	begin
		--set @ContactID = (select ContactId FROM INSERTED)
		insert into Contacts.Entity (Prefix, FirstName, LastName, adddate, AddID, LegacyID, LegacyTable)
		select Salutation, FirstName, LastName, getdate(), 0, contactid, 'tblClientContact'
		from tblClientContact
		where ContactID in (select  ContactId FROM INSERTED)

		Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
		select 2, OfficePhone, 1, ContactID, 'tblClientContact'
		from inserted

		Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
		select 4, MobilePhone, 1, ContactID, 'tblClientContact'
		from inserted

		Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
		select 10, EMail, 1, ContactID, 'tblClientContact'
		from inserted

	end

	if @action = 'DELETE'
	begin
		--set @ContactID = (select ContactId FROM Deleted)
		update Contacts.Entity set status = 0 Where LegacyID in (select  ContactId FROM Deleted) and LegacyTable = 'tblClientContact' 
	end

END
GO
DISABLE TRIGGER [dbo].[tblClientContactTrigger]
    ON [dbo].[tblClientContact];


GO

