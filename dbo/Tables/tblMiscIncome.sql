CREATE TABLE [dbo].[tblMiscIncome] (
    [MiscIncomeID]            INT           IDENTITY (1, 1) NOT NULL,
    [VendorID]                INT           NULL,
    [MiscIncomeDate]          DATETIME      CONSTRAINT [DF_tblMiscIncome_MiscIncomeDate] DEFAULT (getdate()) NULL,
    [ProViewAccountID]        INT           NULL,
    [DepositProViewAccountID] INT           NULL,
    [MiscIncomeAmount]        MONEY         DEFAULT ((0)) NULL,
    [Reason]                  VARCHAR (MAX) NULL,
    [CreatedOn]               DATETIME      CONSTRAINT [DF_tblMiscIncome_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]             VARCHAR (255) NULL,
    [ModifiedLast]            DATETIME      NULL,
    [UpdatedUser]             VARCHAR (255) NULL,
    [IsDeleted]               VARCHAR (1)   CONSTRAINT [DF_tblMiscIncome_IsDeleted] DEFAULT ('N') NOT NULL,
    [PaymentTypeID]           INT           NULL,
    [CheckNumber]             VARCHAR (50)  NULL,
    [IsPartOfOtherPayment]    VARCHAR (1)   CONSTRAINT [DF_tblMiscIncome_IsPartOfOtherPayment] DEFAULT ('N') NOT NULL,
    [IsSalesTaxPayable]       VARCHAR (1)   CONSTRAINT [DF_tblMiscIncome_IsSalesTaxPayable] DEFAULT ('N') NOT NULL,
    CONSTRAINT [PK_tblMiscIncome] PRIMARY KEY CLUSTERED ([MiscIncomeID] ASC)
);


GO

