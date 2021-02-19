CREATE TABLE [TimeSheet].[Approval] (
    [TimeSheetApprovalID] INT      IDENTITY (1, 1) NOT NULL,
    [TimeSheetID]         INT      NULL,
    [Approver]            INT      NULL,
    [AddDate]             DATETIME NULL,
    [AddID]               INT      NULL,
    [Status]              INT      NULL,
    [ApprovalLevel]       INT      NULL,
    CONSTRAINT [PK_Approval] PRIMARY KEY CLUSTERED ([TimeSheetApprovalID] ASC)
);


GO

