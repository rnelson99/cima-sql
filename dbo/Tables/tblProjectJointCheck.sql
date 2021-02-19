CREATE TABLE [dbo].[tblProjectJointCheck] (
    [ProjectJointCheckID]  INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]            INT            NULL,
    [VendorID]             INT            NULL,
    [SupplierID]           INT            NULL,
    [UserSecurityID]       INT            NULL,
    [JointCheckAgreement]  NVARCHAR (255) NULL,
    [VendorEntityID]       INT            NULL,
    [SupplierEntityID]     INT            NULL,
    [AddID]                INT            NULL,
    [ChangeID]             INT            NULL,
    [AddDate]              DATETIME       NULL,
    [ChangeDate]           DATETIME       NULL,
    [StartDate]            DATETIME       NULL,
    [EndDate]              DATETIME       NULL,
    [Status]               INT            NULL,
    [SpecialTerms]         VARCHAR (100)  NULL,
    [tblProjectJointCheck] INT            NULL,
    [jointstatus]          INT            NULL,
    [SupplierContact]      INT            NULL,
    [VendorContact]        INT            NULL,
    [DraftedBy]            VARCHAR (15)   NULL,
    [CIMARep]              INT            NULL,
    CONSTRAINT [PK_tblProjectJointCheck] PRIMARY KEY CLUSTERED ([ProjectJointCheckID] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[tblProjectJointCheckTrigger]
   ON  dbo.tblProjectJointCheck
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	DECLARE @action  CHAR(6), @success BIT;
	SELECT @action  = 'DELETE', @success = 1;

	  IF EXISTS (SELECT 1 FROM inserted)
	  BEGIN
		IF EXISTS (SELECT 1 FROM deleted)
		  SET @action = 'UPDATE';
		ELSE
		  SET @action = 'INSERT';
	  END


	update c
		 set c.VendorEntityID = e.EntityID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.VendorID and e.LegacyTable = 'tblVendor'
	where c.vendorentityid is null

	update c
		 set c.VendorID = e.LegacyID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.VendorID and e.LegacyTable = 'tblVendor'
	where c.VendorID is null


	update c
		 set c.SupplierEntityID = e.EntityID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.SupplierID and e.LegacyTable = 'tblVendor'
	where c.SupplierEntityID is null

	update c
		 set c.SupplierID = e.LegacyID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.SupplierID and e.LegacyTable = 'tblVendor'
	where c.SupplierID is null


	update c
		 set c.AddID = e.EntityID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.UserSecurityID and e.LegacyTable = 'User'
	where c.AddID is null

	update c
		 set c.UserSecurityID = e.LegacyID
	from tblProjectJointCheck c
	join Contacts.Entity e on e.LegacyID = c.UserSecurityID and e.LegacyTable = 'User'
	where c.UserSecurityID is null
		
	 if @action = 'insert'
		begin
			Update tblProjectJointCheck set AddDate = getdate()
			where ProjectJointCheckID in (select ProjectJointCheckID FROM INSERTED) and AddDate is null
		end
	if @action = 'update' 
		begin
			Update tblProjectJointCheck set ChangeDate = getdate()
			where ProjectJointCheckID in (select ProjectJointCheckID FROM INSERTED) and ChangeDate is null
		end



END

GO

