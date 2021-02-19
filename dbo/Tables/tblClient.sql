CREATE TABLE [dbo].[tblClient] (
    [ClientID]                      INT             IDENTITY (1, 1) NOT NULL,
    [ClientShortname]               VARCHAR (65)    NOT NULL,
    [ClientName]                    VARCHAR (95)    NULL,
    [ClientFedId]                   VARCHAR (20)    NULL,
    [ClientSince]                   DATETIME        NULL,
    [ClientStatus]                  VARCHAR (15)    NOT NULL,
    [ClientLastUpdated]             DATETIME        NULL,
    [ClientWebsite]                 VARCHAR (255)   NULL,
    [WaiverThreshhold]              MONEY           NULL,
    [ClientFax]                     VARCHAR (25)    NULL,
    [PayAppRequirement]             VARCHAR (16)    NULL,
    [PayAppCustom]                  VARCHAR (6)     NULL,
    [PayAppCustomPath]              VARCHAR (255)   NULL,
    [WaiverRequiredforMaterialOnly] BIT             CONSTRAINT [DF_tblClient_WaiverRequiredforMaterialOnly] DEFAULT ((0)) NOT NULL,
    [clientPaymentTerms]            VARCHAR (25)    NULL,
    [clientRetainage]               DECIMAL (18, 2) NULL,
    [specialAccountingRequirements] VARCHAR (MAX)   NULL,
    [projectDesignator]             VARCHAR (25)    NULL,
    [RV]                            ROWVERSION      NOT NULL,
    [ClientLogo]                    VARCHAR (1000)  NULL,
    CONSTRAINT [tblClient_PK] PRIMARY KEY NONCLUSTERED ([ClientID] ASC)
);


GO

Create TRIGGER [dbo].[tblClientInsert]
   ON  [dbo].[tblClient]
   AFTER INSERT,Update, Delete
AS 
BEGIN
	declare @ClientID int = 0
	DECLARE @action  CHAR(6), @success BIT;
	SELECT @action  = 'DELETE', @success = 1;

  IF EXISTS (SELECT 1 FROM inserted)
  BEGIN
    IF EXISTS (SELECT 1 FROM deleted)
      SET @action = 'UPDATE';
    ELSE
      SET @action = 'INSERT';
  END

	if @action = 'insert'
		begin
			set @ClientID = (select top 1 ClientID FROM INSERTED)
			insert into Contacts.Entity (LastName, AddDate, AddID, Status, LegacyID, LegacyTable)
			select top 1 ClientName, getdate(), 0, 1, ClientID, 'tblClient'
			from tblClient
			where clientid = @ClientID
			order by ClientID desc
		end
	if @action = 'Delete'
		begin
			set @ClientID = (select ClientID FROM Deleted)
			Update Contacts.Entity set status = 0 where LegacyTable = 'tblClient' and LegacyID = @ClientID
		end
	if @action = 'update' 
		begin
			set @ClientID = (select top 1 ClientID FROM INSERTED)
			Update tblClient set ClientLastUpdated = getdate() where ClientID = @ClientID
			declare @ClientName varchar(1000) = (Select ClientName from tblClient where ClientID = @ClientID)
			declare @Status varchar(100) = (Select ClientStatus from tblClient where ClientID = @ClientID)
			declare @stat int = 0
			if @Status = 'Active'
				begin
					set @stat = 1
				end
			Update contacts.Entity 
			set LastName = @ClientName, Status = @stat , ChangeDate = getdate(), ChangeID = 0
			where LegacyTable = 'tblClient' and LegacyID = @ClientID
		end
END


SET ANSI_NULLS ON
GO
DISABLE TRIGGER [dbo].[tblClientInsert]
    ON [dbo].[tblClient];


GO

