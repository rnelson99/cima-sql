CREATE TABLE [Contacts].[Address] (
    [AddressID]            INT            IDENTITY (1, 1) NOT NULL,
    [AddressType]          INT            NULL,
    [Address1]             VARCHAR (200)  NULL,
    [Address2]             VARCHAR (50)   NULL,
    [Address3]             VARCHAR (50)   NULL,
    [Zip]                  INT            NULL,
    [Country]              INT            NULL,
    [Latitude]             VARCHAR (25)   NULL,
    [Longitude]            VARCHAR (25)   NULL,
    [GPSVerified]          BIT            NULL,
    [AddDate]              DATETIME       NULL,
    [AddID]                INT            NULL,
    [ChangeDate]           DATETIME       NULL,
    [ChangeID]             INT            NULL,
    [AddStatus]            INT            NULL,
    [Postal]               VARCHAR (25)   NULL,
    [Providence]           VARCHAR (50)   NULL,
    [LegacyID]             INT            NULL,
    [LegacyTable]          VARCHAR (100)  NULL,
    [GooglePlaceID]        VARCHAR (1000) NULL,
    [MainPhone]            VARCHAR (20)   NULL,
    [MainFax]              VARCHAR (15)   NULL,
    [EntityID]             INT            NULL,
    [Nickname]             VARCHAR (100)  NULL,
    [FormalName]           VARCHAR (100)  NULL,
    [Pay]                  INT            NULL,
    [Tax]                  INT            NULL,
    [MainOffice]           INT            NULL,
    [contact]              INT            NULL,
    [city]                 VARCHAR (100)  NULL,
    [state]                VARCHAR (100)  NULL,
    [SyncModificationDate] DATETIME       DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED ([AddressID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190601-081448]
    ON [Contacts].[Address]([MainPhone] ASC);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190601-081520]
    ON [Contacts].[Address]([AddressType] ASC, [EntityID] ASC)
    INCLUDE([AddressID]);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Contacts].[AddressTrigger]
   ON  [Contacts].[Address]
   AFTER insert, update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Update e
	set e.SyncModificationDate = getdate()
	from Contacts.Address e
	join inserted i on i.EntityID = e.EntityID -- this is going to show me what we are updating to
	join deleted d on d.EntityID = e.EntityID -- going to see what we had before the update
	where i.SyncModificationDate = d.SyncModificationDate -- Will only update the new SyncModification if we didn't update in the call
    
	
	update a 
		set a.city = z.city
	from Contacts.Address a 
	join WebLookup.zipCodeLookup z on z.ZipCode = a.Zip
	where a.city is null 

	update a 
		set a.state = z.StateAbbr
	from Contacts.Address a 
	join WebLookup.zipCodeLookup z on z.ZipCode = a.Zip
	where a.state is null 


END

GO

