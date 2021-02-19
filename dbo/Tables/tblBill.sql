CREATE TABLE [dbo].[tblBill] (
    [BillID]              INT           IDENTITY (1, 1) NOT NULL,
    [BillAmount]          MONEY         NULL,
    [DueDate]             DATETIME      NULL,
    [ProjectID]           INT           NULL,
    [PWALogID]            INT           NULL,
    [InvoiceNumber]       VARCHAR (20)  NULL,
    [VendorID]            INT           NULL,
    [IsRecurring]         VARCHAR (1)   CONSTRAINT [DF_tblBill_IsRecurring] DEFAULT ('N') NOT NULL,
    [ParentBillID]        INT           NULL,
    [RecurringDueDate]    DATETIME      NULL,
    [Frequency]           INT           NULL,
    [FrequencyUnit]       VARCHAR (10)  NULL,
    [RecurringAmount]     MONEY         NULL,
    [RecurringAmountType] VARCHAR (10)  NULL,
    [RecurringSequence]   INT           NULL,
    [CreatedOn]           DATETIME      CONSTRAINT [DF_tblBill_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedUser]         VARCHAR (255) NULL,
    [ModifiedLast]        DATETIME      NULL,
    [UpdatedUser]         VARCHAR (255) NULL,
    [IsDeleted]           VARCHAR (1)   CONSTRAINT [DF_tblBill_IsDeleted] DEFAULT ('N') NOT NULL,
    [ProViewAccountID]    INT           NULL,
    [JointPayeeVendorID]  INT           NULL,
    [IsEnded]             VARCHAR (1)   CONSTRAINT [DF_tblBill_IsEnded] DEFAULT ('N') NOT NULL,
    CONSTRAINT [PK_tblBill] PRIMARY KEY CLUSTERED ([BillID] ASC),
    CONSTRAINT [FK_tblBill_tblBill_Parent] FOREIGN KEY ([ParentBillID]) REFERENCES [dbo].[tblBill] ([BillID]),
    CONSTRAINT [FK_tblBill_tblProViewAccount] FOREIGN KEY ([ProViewAccountID]) REFERENCES [dbo].[tblProViewAccount] ([ProViewAccountID]),
    CONSTRAINT [FK_tblBill_tblPWALog] FOREIGN KEY ([PWALogID]) REFERENCES [dbo].[tblPWALog] ([PWALogID]),
    CONSTRAINT [FK_tblBill_tblVendor] FOREIGN KEY ([VendorID]) REFERENCES [dbo].[tblVendor] ([VendorID]),
    CONSTRAINT [FK_tblBill_tblVendor_JointPayee] FOREIGN KEY ([JointPayeeVendorID]) REFERENCES [dbo].[tblVendor] ([VendorID])
);


GO

