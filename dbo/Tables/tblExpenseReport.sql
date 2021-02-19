CREATE TABLE [dbo].[tblExpenseReport] (
    [ExpenseReportID]     INT           IDENTITY (1, 1) NOT NULL,
    [UserSecurityID]      INT           NOT NULL,
    [ExpenseReportYear]   INT           NOT NULL,
    [ExpenseReportWeek]   INT           NOT NULL,
    [IsDeleted]           VARCHAR (1)   CONSTRAINT [DF_tblExpenseReport_IsDeleted] DEFAULT ('N') NULL,
    [CreatedOn]           DATETIME      CONSTRAINT [DF_tblExpenseReport_CreatedOn] DEFAULT (getdate()) NULL,
    [CreatedUser]         VARCHAR (255) NULL,
    [ModifiedLast]        DATETIME      NULL,
    [UpdatedUser]         VARCHAR (255) NULL,
    [ExpenseReportStatus] VARCHAR (50)  CONSTRAINT [DF_tblExpenseReport_ExpenseReportStatus] DEFAULT ('Incomplete') NULL,
    [SubmitDateTime]      DATETIME      NULL,
    [Approver]            VARCHAR (50)  NULL,
    [ApproveDateTime]     DATETIME      NULL,
    [UserEntityID]        INT           NULL,
    [PayPeriodPaid]       DATETIME      NULL,
    [expenseguid]         VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblExpenseReport] PRIMARY KEY CLUSTERED ([ExpenseReportID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190607-100051]
    ON [dbo].[tblExpenseReport]([UserEntityID] ASC)
    INCLUDE([ExpenseReportID]);


GO

