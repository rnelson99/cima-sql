CREATE TABLE [dbo].[tblProViewAccount] (
    [ProViewAccountID]          INT           IDENTITY (1, 1) NOT NULL,
    [ProViewAccountName]        VARCHAR (100) NOT NULL,
    [BankID]                    VARCHAR (50)  NULL,
    [BankAccountID]             VARCHAR (50)  NULL,
    [ProViewAccountDescription] VARCHAR (255) NULL,
    [ProViewAccountTypeID]      INT           NULL,
    [ParentProViewAccountID]    INT           NULL,
    [TaxLineMap]                VARCHAR (255) NULL,
    [IsActive]                  VARCHAR (1)   CONSTRAINT [DF_tblAccount_IsActive] DEFAULT ('Y') NOT NULL,
    [MergeProViewAccountID]     INT           NULL,
    [IsShowOverhead]            VARCHAR (1)   CONSTRAINT [DF_tblAccount_IsShowOverhead] DEFAULT ('N') NOT NULL,
    [IsShowPayment]             VARCHAR (1)   CONSTRAINT [DF_tblAccount_IsShowPayment] DEFAULT ('N') NOT NULL,
    [IsShowCreditCard]          VARCHAR (1)   CONSTRAINT [DF_tblAccount_IsShowCreditCard] DEFAULT ('N') NOT NULL,
    [ExpenseListDesc]           VARCHAR (100) NULL,
    [divCodeNum]                VARCHAR (100) NULL,
    [CodeID]                    INT           NULL,
    CONSTRAINT [PK_tblProViewAccount] PRIMARY KEY CLUSTERED ([ProViewAccountID] ASC)
);


GO

