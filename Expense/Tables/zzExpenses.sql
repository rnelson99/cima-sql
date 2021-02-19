CREATE TABLE [Expense].[zzExpenses] (
    [ExpenseID]         INT           IDENTITY (1, 1) NOT NULL,
    [ExpenseDate]       DATETIME      NULL,
    [ExpenseGUID]       VARCHAR (50)  NULL,
    [UserEntityID]      INT           NULL,
    [AddID]             INT           NULL,
    [AddDate]           DATETIME      NULL,
    [ChangeID]          INT           NULL,
    [ChangeDate]        DATETIME      NULL,
    [Status]            INT           NULL,
    [VendorEntityID]    INT           NULL,
    [AccountID]         INT           NULL,
    [CCReference]       VARCHAR (50)  NULL,
    [Source]            INT           NULL,
    [SalesTaxID]        INT           NULL,
    [Amount]            FLOAT (53)    NULL,
    [CCDescription]     VARCHAR (200) NULL,
    [ExpReason]         VARCHAR (200) NULL,
    [ReceiptMatch]      INT           DEFAULT ((0)) NULL,
    [SalesTax]          INT           NULL,
    [CCDate]            DATETIME      NULL,
    [LegacyID]          INT           NULL,
    [MultipleDetails]   INT           NULL,
    [AllowPhoneChanges] INT           DEFAULT ((0)) NULL,
    [CreditCardID]      INT           NULL,
    CONSTRAINT [PK_Expenses] PRIMARY KEY CLUSTERED ([ExpenseID] ASC)
);


GO

