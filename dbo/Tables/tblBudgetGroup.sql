CREATE TABLE [dbo].[tblBudgetGroup] (
    [BudgetGroupID] INT      IDENTITY (1, 1) NOT NULL,
    [ProjectID]     INT      NULL,
    [addDate]       DATETIME CONSTRAINT [DF_tblBudgetGUID_addDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_tblBudgetGUID] PRIMARY KEY CLUSTERED ([BudgetGroupID] ASC)
);


GO

