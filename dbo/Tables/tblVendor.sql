CREATE TABLE [dbo].[tblVendor] (
    [VendorID]                         INT            IDENTITY (1, 1) NOT NULL,
    [Vendor]                           NVARCHAR (100) NULL,
    [VendorOfficePhone]                NVARCHAR (15)  NULL,
    [ApprovedVendor]                   VARCHAR (25)   NULL,
    [GLInsurance]                      VARCHAR (25)   NULL,
    [GLInsuranceExpiration]            DATETIME       NULL,
    [W9]                               VARCHAR (25)   NULL,
    [SubContAgreement]                 VARCHAR (25)   NULL,
    [Form85]                           VARCHAR (25)   NULL,
    [Form83Signed]                     VARCHAR (25)   NULL,
    [Form83FiledState]                 VARCHAR (25)   NULL,
    [Email]                            VARCHAR (200)  NULL,
    [VendorStatus]                     VARCHAR (25)   NULL,
    [VendorAddress1]                   VARCHAR (200)  NULL,
    [GLLimitsPerOcc]                   MONEY          NULL,
    [CIMAAdditionalInsured]            VARCHAR (25)   NULL,
    [WaiverSubrogation]                VARCHAR (25)   NULL,
    [WorkersCompensation]              VARCHAR (25)   NULL,
    [ExemptPayee]                      VARCHAR (25)   NULL,
    [TaxClass]                         VARCHAR (100)  NULL,
    [Form83DateSigned]                 DATETIME       NULL,
    [EIN]                              VARCHAR (25)   NULL,
    [RecentWork]                       VARCHAR (255)  NULL,
    [SupplierOnly]                     BIT            DEFAULT ((0)) NOT NULL,
    [VendorNumberOfEmployees]          INT            NULL,
    [VendorFileGLInsurance]            VARCHAR (255)  NULL,
    [VendorFileSubContAgreement]       VARCHAR (255)  NULL,
    [VendorFileW9]                     VARCHAR (255)  NULL,
    [VendorFileForm83]                 VARCHAR (255)  NULL,
    [VendorFileForm85]                 VARCHAR (255)  NULL,
    [PreferredBusinessName]            VARCHAR (255)  NULL,
    [BusinessNameOnTaxReturn]          VARCHAR (255)  NULL,
    [AlternateBusinessNameOnTaxReturn] VARCHAR (255)  NULL,
    [VendorAddress2]                   VARCHAR (255)  NULL,
    [VendorCity]                       VARCHAR (255)  NULL,
    [VendorState]                      VARCHAR (255)  NULL,
    [VendorZip]                        VARCHAR (255)  NULL,
    [VendorAddressFull_Calc]           VARCHAR (255)  NULL,
    [VendorNotes]                      VARCHAR (2000) NULL,
    [VendorQuality]                    VARCHAR (255)  NULL,
    [VendorPricing]                    VARCHAR (255)  NULL,
    [VendorUseAgain]                   VARCHAR (255)  NULL,
    [VendorFavorite]                   BIT            DEFAULT ((0)) NOT NULL,
    [OtherRetailer]                    BIT            DEFAULT ((0)) NOT NULL,
    [LastUpdated]                      DATETIME       NULL,
    [VendorSince]                      DATETIME       NULL,
    [VendorWebsite]                    VARCHAR (75)   NULL,
    [ChecksPayableTo]                  VARCHAR (255)  NULL,
    [ShowOnLienTracker]                VARCHAR (8)    NULL,
    [TwoMonthApprovalOverride]         BIT            DEFAULT ((0)) NOT NULL,
    [TwoMonthApprovalOverrideDate]     DATETIME       NULL,
    [MergedVendorID]                   INT            NULL,
    [FromCCTransactions]               BIT            DEFAULT ((0)) NOT NULL,
    [VendorShortName]                  VARCHAR (16)   NULL,
    [IsStopPay]                        VARCHAR (1)    DEFAULT ('N') NOT NULL,
    [StopPayUser]                      VARCHAR (255)  NULL,
    [StopPayOn]                        DATETIME       NULL,
    [SalesTaxID]                       INT            CONSTRAINT [DF_tblVendor_SalesTaxID] DEFAULT ((1)) NULL,
    [VendorType]                       INT            NULL,
    CONSTRAINT [PKtblVendor] PRIMARY KEY NONCLUSTERED ([VendorID] ASC)
);


GO


CREATE TRIGGER [dbo].[tblVendor_InsertTrigger] ON [dbo].[tblVendor]
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

  --select * from tblVendor

  if @action = 'insert'
		begin
			insert into Contacts.Entity (LastName, AddDate, AddID, Status, LegacyID, LegacyTable)
			select  Vendor, getdate(), 0, 1, VendorID, 'tblVendor'
			from tblVendor
			where VendorID in (select VendorID FROM INSERTED)
		end
	if @action = 'Delete'
		begin
			Update Contacts.Entity set Status = 0 where LegacyID in (select VendorID FROM Deleted) and LegacyTable = 'tblVendor'
		end
	if @action = 'update' 
		begin
			Update e 
			set e.Status = case when i.VendorStatus = 'Active' then 1 else 0 end,
			e.LastName = i.Vendor
			from Contacts.Entity e
			join inserted i on i.VendorID = e.LegacyID and e.LegacyTable = 'tblVendor'

			UPDATE tblVendor
			SET VendorShortName=RTRIM(LTRIM(LEFT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(tblVendor.Vendor,'?',''),'\',''),'/',''),'<',''),'>',''),':',''),'|',''),'*',''),'"',''), 16)))
			FROM INSERTED JOIN tblVendor ON INSERTED.VendorID=tblVendor.VendorID
			WHERE tblVendor.VendorShortName IS NULL OR LTRIM(RTRIM(tblVendor.VendorShortName))=''
		end
GO
DISABLE TRIGGER [dbo].[tblVendor_InsertTrigger]
    ON [dbo].[tblVendor];


GO

