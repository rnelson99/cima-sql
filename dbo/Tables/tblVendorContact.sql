CREATE TABLE [dbo].[tblVendorContact] (
    [ContactId]               INT           IDENTITY (1, 1) NOT NULL,
    [VendorId]                INT           NOT NULL,
    [Salutation]              VARCHAR (4)   NULL,
    [FirstName]               VARCHAR (45)  NULL,
    [LastName]                VARCHAR (45)  NULL,
    [OfficePhone]             VARCHAR (25)  NULL,
    [MobilePhone]             VARCHAR (25)  NULL,
    [EMail]                   VARCHAR (150) NULL,
    [Title]                   VARCHAR (30)  NULL,
    [primaryContactContracts] BIT           DEFAULT ((0)) NOT NULL,
    [primaryContactJobsite]   BIT           DEFAULT ((0)) NOT NULL,
    [primaryContactPayApp]    BIT           DEFAULT ((0)) NOT NULL,
    [primaryContactWaivers]   BIT           DEFAULT ((0)) NOT NULL,
    [DivCodeOnly]             INT           NULL,
    [EntityID]                INT           NULL,
    CONSTRAINT [tblVendorContact_PK] PRIMARY KEY NONCLUSTERED ([ContactId] ASC)
);


GO


CREATE TRIGGER [dbo].[tblVendorContact_InsertTrigger] ON [dbo].[tblVendorContact]
 AFTER INSERT,Update, Delete
 AS

 

 DECLARE @action  CHAR(6), @success BIT;
	SELECT @action  = 'DELETE', @success = 1;

  IF EXISTS (SELECT 1 FROM inserted)
  BEGIN
    IF EXISTS (SELECT 1 FROM deleted)
      SET @action = 'UPDATE';
    ELSE
      SET @action = 'INSERT';
  END

  --select * from tblVendorContact

  if @action = 'insert'
		begin
			insert into Contacts.Entity (prefix, FirstName, LastName, AddDate, AddID, Status, LegacyID, LegacyTable)
			select top 1 Salutation, FirstName, LastName, getdate(), 0, 1, ContactID, 'tblVendorContact'
			from tblVendorContact
			where ContactID in (select ContactID FROM INSERTED)

			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 2, OfficePhone, 1, ContactID, 'tblVendorContact'
			from inserted

			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 4, MobilePhone, 1, ContactID, 'tblVendorContact'
			from inserted

			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 10, EMail, 1, ContactID, 'tblVendorContact'
			from inserted


		end
	if @action = 'Delete'
		begin
			Update Contacts.Entity set Status = 0 where LegacyID in (select ContactId FROM Deleted) and LegacyTable = 'tblVendorContact'
		end
	if @action = 'update' 
		begin
			Update e 
			set
			e.prefix = i.Salutation,
			e.firstname = i.FirstName,
			e.LastName = i.LastName
			from Contacts.Entity e
			join inserted i on i.ContactId = e.LegacyID and e.LegacyTable = 'tblVendorContact'


			if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and ContactType = 2 and LegacyTable = 'tblVendorContact')
				begin
					Update p
					set p.contact = i.OfficePhone
					from Contacts.Contact p
					join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblVendorContact' 
					where p.ContactType = 2
				end
			else 
				begin
					Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
					select 2, OfficePhone, 1, ContactID, 'tblVendorContact'
					from inserted
				end

			if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and contacttype = 4 and LegacyTable = 'tblVendorContact')
				begin
					Update p
					set p.contact = i.MobilePhone
					from Contacts.Contact p
					join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblVendorContact' 
					where p.ContactType = 4
				end
			else 
				begin
					Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
					select 4, MobilePhone, 1, ContactID, 'tblVendorContact'
					from inserted
				end

			if exists(select * from Contacts.Contact where legacyid in (Select contactid from inserted) and contacttype = 10 and LegacyTable = 'tblVendorContact')
				begin
					Update p
					set p.contact = i.EMail
					from Contacts.Contact p
					join inserted i on i.ContactId = p.LegacyID and p.LegacyTable = 'tblVendorContact' 
					where p.ContactType = 10
				end
			else 
				begin
					Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
					select 10, EMail, 1, ContactID, 'tblVendorContact'
					from inserted
				end

			

			


		end
GO
DISABLE TRIGGER [dbo].[tblVendorContact_InsertTrigger]
    ON [dbo].[tblVendorContact];


GO

