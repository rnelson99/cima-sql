CREATE TABLE [dbo].[tvalUserSecurity] (
    [UserSecurityID]                     INT             IDENTITY (1, 1) NOT NULL,
    [UserWindowsLoginID]                 VARCHAR (50)    NOT NULL,
    [UserFirstName]                      VARCHAR (50)    NULL,
    [UserInitials]                       VARCHAR (3)     NULL,
    [UserRole]                           VARCHAR (50)    NULL,
    [AccessToAccountingMenu]             VARCHAR (10)    CONSTRAINT [DF_tvalUserS_AccessToAccountingMenu] DEFAULT ('None') NOT NULL,
    [AccessToVendorForm]                 VARCHAR (10)    CONSTRAINT [DF_tvalUserS_AccessToVendorForm] DEFAULT ('None') NOT NULL,
    [AccessToAccountingCommissionReport] VARCHAR (10)    CONSTRAINT [DF_tvalUserS_AccessToAccountingCommissionReport] DEFAULT ('None') NOT NULL,
    [AccessToAdminMenu]                  VARCHAR (10)    CONSTRAINT [DF_tvalUserS_AccessToAdminMenu] DEFAULT ('None') NOT NULL,
    [UserOutlookAutoSignature]           VARCHAR (255)   NULL,
    [UserOnSIPAddress]                   VARCHAR (255)   NULL,
    [UserLastName]                       VARCHAR (255)   NULL,
    [AccessToBudgetMenu]                 VARCHAR (10)    DEFAULT ('None') NOT NULL,
    [UserCellPhone]                      VARCHAR (50)    NULL,
    [UserDirectLine]                     VARCHAR (50)    NULL,
    [UserEmail]                          VARCHAR (255)   NULL,
    [UserExtension]                      VARCHAR (4)     NULL,
    [UserHomePhone]                      VARCHAR (50)    NULL,
    [BillRate]                           DECIMAL (18, 2) NULL,
    [EmployeeType]                       VARCHAR (12)    NULL,
    [PayTypeFrequency]                   VARCHAR (2)     NULL,
    [Active]                             VARCHAR (3)     DEFAULT ('Y') NULL,
    [UserTitle]                          VARCHAR (50)    NULL,
    [EmergContactName]                   VARCHAR (50)    NULL,
    [EmergContactRelationship]           VARCHAR (50)    NULL,
    [EmergContactNumber]                 VARCHAR (50)    NULL,
    [UserEmailSecond]                    VARCHAR (255)   NULL,
    [AccessToProjectMenu]                VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuMainTab]         VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuSubcontracts]    VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuDetails]         VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuBudgetTab]       VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuOwnProjects]     VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuAccounting]      VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProjectMenuJointCheck]      VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToClientMenu]                 VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToEstimatingMenu]             VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenu]                   VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuGlobalSchedule]     VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuTimesheetOthers]    VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuTimesheetOwn]       VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuExpenseOthers]      VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuExpenseOwn]         VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToMiscMenuDirectory]          VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToAdminMenuOpenTables]        VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToAdminMenuSecurity]          VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [AccessToProViewFolders]             VARCHAR (10)    DEFAULT ('Edit') NOT NULL,
    [Salt]                               VARCHAR (50)    NULL,
    [WebPwd]                             VARCHAR (MAX)   NULL,
    [MobileApp]                          BIT             DEFAULT ((0)) NULL,
    [MobileCode]                         VARCHAR (10)    NULL,
    [MobileVerified]                     BIT             DEFAULT ((0)) NULL,
    [EmergCellPh]                        VARCHAR (20)    NULL,
    [EmergWorkPh]                        VARCHAR (20)    NULL,
    [EmergWorkExt]                       VARCHAR (20)    NULL,
    CONSTRAINT [PK_tblUserSecurity] PRIMARY KEY CLUSTERED ([UserSecurityID] ASC)
);


GO


CREATE TRIGGER [dbo].[tvalUserSecurity_InsertTrigger] ON [dbo].[tvalUserSecurity]
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

  --select * from tvalUserSecurity
  --select * from WebLookup.LookUpCodes

  if @action = 'insert'
		begin
			insert into Contacts.Entity (prefix, FirstName, LastName, AddDate, AddID, Status, LegacyID, LegacyTable, WebLogin, PasswordCycle, EntityType)
			select top 1 '', UserFirstName, UserLastName, getdate(), 0, 1, UserSecurityID, 'User', UserWindowsLoginID, 365, 1
			from tvalUserSecurity
			where UserSecurityID in (select UserSecurityID FROM INSERTED)


			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 2, UserDirectLine, 1, UserSecurityID, 'User'
			from inserted

			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 10, UserCellPhone, 1, UserSecurityID, 'User'
			from inserted

			Insert into Contacts.Contact (ContactType, Contact, ContactStatus, LegacyID, LegacyTable)
			select 13, UserEmail, 1, UserSecurityID, 'User'
			from inserted



		end
	if @action = 'Delete'
		begin
			Update Contacts.Entity set Status = 0 where LegacyID in (select UserSecurityID FROM Deleted) and LegacyTable = 'User'
		end
	if @action = 'update' 
		begin
			Update e 
			set
			e.firstname = i.UserFirstName,
			e.LastName = i.UserLastName,
			e.status = Case when i.Active = 'Y' then 1 else 0 end,
			e.WebLogin = i.UserWindowsLoginID
			from Contacts.Entity e
			join inserted i on i.UserSecurityID = e.LegacyID and e.LegacyTable = 'User'

			Update p
			set p.contact = i.UserDirectLine
			from Contacts.Contact p
			join inserted i on i.UserSecurityID = p.LegacyID and p.LegacyTable = 'User' 
			where p.ContactType = 2

			Update p
			set p.contact = i.UserCellPhone
			from Contacts.Contact p
			join inserted i on i.UserSecurityID = p.LegacyID and p.LegacyTable = 'User' 
			where p.ContactType = 10

			Update p
			set p.contact = i.UserEmail
			from Contacts.Contact p
			join inserted i on i.UserSecurityID = p.LegacyID and p.LegacyTable = 'User' 
			where p.ContactType = 13



		end
GO
DISABLE TRIGGER [dbo].[tvalUserSecurity_InsertTrigger]
    ON [dbo].[tvalUserSecurity];


GO

