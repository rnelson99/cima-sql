CREATE TABLE [dbo].[tblBudget] (
    [BudgetID]                          INT      IDENTITY (1, 1) NOT NULL,
    [ProjectID]                         INT      NOT NULL,
    [MasterConstDivCodeID]              INT      NOT NULL,
    [BaseBudgetAmount]                  MONEY    DEFAULT ((0)) NOT NULL,
    [BudgetWithChangeOrdersAmount_CALC] MONEY    DEFAULT ((0)) NOT NULL,
    [ApprovedAmount_CALC]               MONEY    DEFAULT ((0)) NOT NULL,
    [VarianceAmount_CALC]               MONEY    DEFAULT ((0)) NOT NULL,
    [CommittedAmount_INFO]              MONEY    DEFAULT ((0)) NOT NULL,
    [SpentAmount_INFO]                  MONEY    DEFAULT ((0)) NOT NULL,
    [BudgetLastModified]                DATETIME NULL,
    [ProjectedAmount]                   MONEY    DEFAULT ((0)) NOT NULL,
    [CostToComplete]                    MONEY    NULL,
    [removeBy]                          INT      NULL,
    [removeDate]                        DATETIME NULL,
    [addid]                             INT      NULL,
    [adddate]                           DATETIME NULL,
    [BudgetGroupID]                     INT      NULL,
    [status]                            INT      DEFAULT ((1)) NULL,
    CONSTRAINT [PK_tblBudget] PRIMARY KEY CLUSTERED ([BudgetID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [IX_tblBudgetDivCode]
    ON [dbo].[tblBudget]([ProjectID] ASC, [MasterConstDivCodeID] ASC);


GO

