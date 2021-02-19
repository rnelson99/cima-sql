CREATE TABLE [Contacts].[Contact] (
    [ContactID]            INT           IDENTITY (1, 1) NOT NULL,
    [ContactType]          INT           NULL,
    [Contact]              VARCHAR (255) NULL,
    [AddDate]              DATETIME      NULL,
    [AddID]                INT           NULL,
    [ChangeDate]           DATETIME      NULL,
    [ChangeID]             INT           NULL,
    [ContactStatus]        INT           NULL,
    [Contact2]             VARCHAR (25)  NULL,
    [LegacyID]             INT           NULL,
    [LegacyTable]          VARCHAR (100) NULL,
    [tempEntityID]         INT           NULL,
    [haveLine]             BIT           NULL,
    [EntityID]             INT           NULL,
    [DefaultContact]       INT           CONSTRAINT [DF__Contact__Default__7C5A637C] DEFAULT ((1)) NULL,
    [ext]                  VARCHAR (10)  NULL,
    [SyncModificationDate] DATETIME      DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ContactID] PRIMARY KEY CLUSTERED ([ContactID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190530-174407]
    ON [Contacts].[Contact]([ContactType] ASC, [EntityID] ASC)
    INCLUDE([ContactID]);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [Contacts].[ContactTrigger]
   ON  [Contacts].[Contact]
   AFTER insert, update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Update e
	set e.SyncModificationDate = getdate()
	from Contacts.Contact e
	join inserted i on i.EntityID = e.EntityID -- this is going to show me what we are updating to
	join deleted d on d.EntityID = e.EntityID -- going to see what we had before the update
	where i.SyncModificationDate = d.SyncModificationDate -- Will only update the new SyncModification if we didn't update in the call
    
	update contacts.entitychange set modifieddate = getdate() where entityid in (Select entityid from inserted)

END

GO

