CREATE TABLE [dbo].[tblExpenseAllocation] (
    [ExpenseAllocationID] INT            IDENTITY (1, 1) NOT NULL,
    [ExpenseID]           INT            NULL,
    [ProjectID]           INT            NULL,
    [CodeID]              INT            NULL,
    [PWALogID]            INT            NULL,
    [PayAppID]            INT            NULL,
    [Status]              INT            NULL,
    [AddID]               INT            NULL,
    [AddDate]             DATETIME       NULL,
    [ChangeID]            INT            NULL,
    [ChangeDate]          DATETIME       NULL,
    [amount]              MONEY          NULL,
    [purpose]             VARCHAR (1000) NULL,
    [SalesTaxID]          INT            NULL,
    [taxrate]             FLOAT (53)     NULL,
    [taxamount]           MONEY          NULL,
    CONSTRAINT [PK_tblExpenseAllocation] PRIMARY KEY CLUSTERED ([ExpenseAllocationID] ASC)
);


GO

