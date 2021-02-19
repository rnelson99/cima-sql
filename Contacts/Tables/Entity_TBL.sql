CREATE TABLE [Contacts].[Entity_TBL] (
    [EntityID]             INT            IDENTITY (1, 1) NOT NULL,
    [Prefix]               VARCHAR (5)    NULL,
    [FirstName]            VARCHAR (200)  NULL,
    [MiddleName]           VARCHAR (50)   NULL,
    [LastName]             VARCHAR (200)  NULL,
    [Suffix]               VARCHAR (100)  NULL,
    [EntityType]           INT            NULL,
    [AddDate]              DATETIME       NULL,
    [AddID]                INT            NULL,
    [ChangeDate]           DATETIME       NULL,
    [ChangeID]             INT            NULL,
    [Salt]                 VARCHAR (100)  NULL,
    [WebPwd]               VARCHAR (1000) NULL,
    [MobileApp]            BIT            NULL,
    [AccountExpiration]    DATETIME       NULL,
    [PasswordExpiration]   DATETIME       NULL,
    [PasswordCycle]        INT            NULL,
    [Status]               INT            NULL,
    [PassAttempts]         INT            NULL,
    [LegacyID]             INT            NULL,
    [WebLogin]             VARCHAR (50)   NULL,
    [LegacyTable]          VARCHAR (100)  NULL,
    [Heirarchy]            INT            CONSTRAINT [DF__Entity__Heirarch__0B47A151] DEFAULT ((0)) NULL,
    [VendorID]             INT            NULL,
    [ClientID]             INT            NULL,
    [VendorEntityID]       INT            NULL,
    [ClientEntityID]       INT            NULL,
    [UserPin]              VARCHAR (6)    NULL,
    [CatchAll]             VARCHAR (100)  NULL,
    [NickName]             VARCHAR (100)  NULL,
    [FullName]             VARCHAR (200)  NULL,
    [ShortName]            VARCHAR (200)  NULL,
    [PreferredName]        VARCHAR (200)  NULL,
    [CheckPayableTo]       VARCHAR (200)  NULL,
    [UserEmailRegistered]  INT            NULL,
    [RequireDualFactor]    INT            NULL,
    [Chalkboard]           VARCHAR (1000) NULL,
    [legalFirst]           VARCHAR (100)  NULL,
    [nameNoSpecial]        VARCHAR (200)  NULL,
    [merged]               INT            CONSTRAINT [DF_Entity_merged] DEFAULT ((0)) NULL,
    [SyncModificationDate] DATETIME       DEFAULT (getdate()) NULL,
    [EntityGUID]           VARCHAR (50)   NULL,
    [CimaPwd]              VARCHAR (1000) NULL,
    CONSTRAINT [PK_Entity] PRIMARY KEY CLUSTERED ([EntityID] ASC)
);


GO

-- =============================================
-- Author:		Chris Hubbard
-- Create date: 7/25/2019
-- Description:	This is going to capture changes 
-- =============================================
CREATE TRIGGER [Contacts].[EntityTableUpdateTrigger]
   ON  [Contacts].[Entity_TBL]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	Update e
	set e.SyncModificationDate = getdate()
	from Contacts.Entity_TBL e
	join inserted i on i.EntityID = e.EntityID -- this is going to show me what we are updating to
	join deleted d on d.EntityID = e.EntityID -- going to see what we had before the update
	where i.SyncModificationDate = d.SyncModificationDate -- Will only update the new SyncModification if we didn't update in the call
    
	update contacts.entitychange set modifieddate = getdate() where entityid in (Select entityid from inserted)
END

GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Contacts].EnityTableTriggerInsert
   ON  Contacts.Entity_TBL
   AFTER Insert
AS 
BEGIN
	
	SET NOCOUNT ON;

	Insert into contacts.entitychange (EntityID,modifieddate)
	Select EntityID, getdate()
	from inserted
	
END

GO

