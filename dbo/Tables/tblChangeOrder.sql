CREATE TABLE [dbo].[tblChangeOrder] (
    [ChangeOrderID]          INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]              INT            NULL,
    [BillingStatus]          NVARCHAR (50)  NULL,
    [dDate]                  DATETIME       NULL,
    [ChangeNum]              INT            NULL,
    [Desc]                   NVARCHAR (150) NULL,
    [GCOHPPercent]           DECIMAL (18)   NULL,
    [ApprovalType]           NVARCHAR (50)  NULL,
    [COStatus]               NVARCHAR (25)  NULL,
    [AffSch]                 NVARCHAR (1)   NULL,
    [CrtUser]                INT            NULL,
    [CrtDateTime]            DATETIME       CONSTRAINT [DF__tblChange__CrtDa__367C1819] DEFAULT (getdate()) NULL,
    [GCOHP]                  BIT            CONSTRAINT [GCOHP_def] DEFAULT ((1)) NOT NULL,
    [ModifiedByInitials]     INT            NULL,
    [ModifiedByDateTime]     DATETIME       NULL,
    [RV]                     ROWVERSION     NOT NULL,
    [ChangeNumRev]           VARCHAR (7)    NULL,
    [IsDeleted]              VARCHAR (1)    CONSTRAINT [DF__tblChange__IsDel__06ED0088] DEFAULT ('N') NOT NULL,
    [ChangeOrderNumRevision] INT            CONSTRAINT [DF__tblChange__Chang__07E124C1] DEFAULT ((0)) NOT NULL,
    [AddID]                  INT            NULL,
    [ChangeID]               INT            NULL,
    [AddDate]                DATETIME       NULL,
    [ChangeDate]             DATETIME       NULL,
    [miscnote]               VARCHAR (1000) NULL,
    [Status]                 INT            CONSTRAINT [DF__tblChange__Statu__75985754] DEFAULT ((1)) NULL,
    [atRisk]                 INT            CONSTRAINT [DF__tblChange__atRis__77809FC6] DEFAULT ((0)) NULL,
    [COTotal]                MONEY          NULL,
    [GCOHPAmount]            MONEY          NULL,
    [SalesTax]               MONEY          NULL,
    CONSTRAINT [aaaaatblProjectChangeOrder_PK] PRIMARY KEY NONCLUSTERED ([ChangeOrderID] ASC)
);


GO

/****** Object:  Trigger [dbo].[tblChangeOrderModifiedByDateTime]    Script Date: 11/7/2014 4:56:37 PM ******/

--  Create T-SQL Trigger dbo.tblChangeOrderModifiedByDateTime
--  Update ClientLastUpdated
--======================================
CREATE TRIGGER [dbo].[tblChangeOrderModifiedByDateTime]
   ON  dbo.tblChangeOrder
   AFTER UPDATE
AS 
BEGIN
	UPDATE dbo.tblChangeOrder SET ModifiedByDateTime = getdate()
	where ChangeOrderID in (select ChangeOrderID from inserted)

	update tblChangeOrder set status = 1 where IsDeleted = 'N' and status = 0
	update tblChangeOrder set status = 0 where IsDeleted = 'Y' and status = 1

	update d
	set d.vendorEntityID = e.entityid
	from tblChangeOrderDetail d 
	join Contacts.Entity e on e.LegacyID = d.SubcontractorId and e.LegacyTable = 'tblVendor'
	where d.vendorEntityID is null

	update c
	set c.addid = isnull(a.EntityID,0),
		c.changeid = isnull(ch.EntityID,0)
	from tblChangeOrder c
	left join Contacts.Entity a on a.LegacyID = c.CrtUser and a.LegacyTable = 'User'
	left join Contacts.Entity ch on ch.LegacyID = c.ModifiedByInitials and ch.LegacyTable = 'User'
	where c.AddID is null or c.ChangeID is null

	update tblChangeOrder set AddDate = CrtDateTime where AddDate is null
	update tblChangeOrder set ChangeDate = ModifiedByDateTime where ChangeDate is null
END

GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.tblChangeOrderDetailTrigger
   ON  dbo.tblChangeOrder
   AFTER Insert, update
AS 
BEGIN
	update tblChangeOrderDetail 
		set UnitPrice = isnull(UnitPrice,0),
		CIMACost = isnull(CIMACost,0),
		Qty = isnull(Qty,0)

END

GO

