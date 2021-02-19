CREATE TABLE [dbo].[tblExpense] (
    [ExpenseID]                INT            IDENTITY (1, 1) NOT NULL,
    [TransactionDate]          DATETIME       NOT NULL,
    [ExpenseReportID]          INT            NULL,
    [CCAmount]                 MONEY          CONSTRAINT [DF_tblExpense_CCAmount] DEFAULT ((0)) NULL,
    [ProjectID]                INT            NULL,
    [PWALogID]                 INT            NULL,
    [CodeID]                   INT            NULL,
    [ExpReason]                VARCHAR (255)  NULL,
    [VendorCC]                 VARCHAR (255)  NULL,
    [VendorID]                 INT            NULL,
    [SalesTaxID]               INT            NULL,
    [ReceiptPath]              VARCHAR (255)  NULL,
    [SentUser]                 DATETIME       NULL,
    [IsUserCreated]            VARCHAR (1)    NULL,
    [CreatedOn]                DATETIME       CONSTRAINT [DF_tblExpense_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]              VARCHAR (255)  NULL,
    [ModifiedLast]             DATETIME       NULL,
    [UpdatedUser]              VARCHAR (255)  NULL,
    [IsDeleted]                VARCHAR (1)    CONSTRAINT [DF_tblExpense_IsDeleted] DEFAULT ('N') NULL,
    [CCReferenceNumber]        VARCHAR (50)   NULL,
    [SalesTax]                 MONEY          DEFAULT ((0)) NULL,
    [ProViewAccountID]         INT            NULL,
    [OverheadProViewAccountID] INT            NULL,
    [VendorEntityID]           INT            NULL,
    [SourceType]               INT            DEFAULT ((0)) NULL,
    [SubPayAppId]              INT            NULL,
    [AddID]                    INT            NULL,
    [ChangeID]                 INT            NULL,
    [AddDate]                  DATETIME       CONSTRAINT [DF_tblExpense_AddDate] DEFAULT (getdate()) NULL,
    [ChangeDate]               DATETIME       NULL,
    [receiptmatch]             INT            DEFAULT ((0)) NULL,
    [ExpenseUser]              INT            NULL,
    [CreditCardID]             INT            NULL,
    [ExpenseGUID]              VARCHAR (50)   NULL,
    [partialMatch]             INT            NULL,
    [verifyProject]            INT            NULL,
    [verifySalesTax]           INT            DEFAULT ((0)) NULL,
    [verifyCostCode]           INT            DEFAULT ((0)) NULL,
    [verifyOverhead]           INT            DEFAULT ((0)) NULL,
    [ccMemo]                   VARCHAR (1000) NULL,
    [parentExpenseID]          INT            DEFAULT ((0)) NULL,
    [ReceiptMatchID]           INT            NULL,
    [InvoiceID]                INT            NULL,
    [InvoiceDesc]              VARCHAR (100)  NULL,
    [billAmount]               MONEY          NULL,
    [mileageID]                INT            NULL,
    [IsBillable]               BIT            DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblExpense] PRIMARY KEY CLUSTERED ([ExpenseID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190607-100145]
    ON [dbo].[tblExpense]([ProViewAccountID] ASC, [OverheadProViewAccountID] ASC)
    INCLUDE([ExpenseID]);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.ExpenseTrigger
   ON  dbo.tblExpense
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	
	SET NOCOUNT ON;

		update x
	set x.VendorEntityID = e.EntityID
	from tblExpense x
	join Contacts.Entity e on e.legacyid = x.VendorID and e.LegacyTable = 'tblVendor'
	where x.VendorEntityID is null


	update x
	set x.UserEntityID = e.EntityID
	from tblExpenseReport x
	join Contacts.Entity e on e.legacyid = x.UserSecurityID and e.LegacyTable = 'User'
	where x.UserEntityID is null

END

GO

