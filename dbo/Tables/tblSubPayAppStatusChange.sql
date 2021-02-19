CREATE TABLE [dbo].[tblSubPayAppStatusChange] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [SubPayAppID]    INT            NULL,
    [OldStatus]      VARCHAR (50)   NULL,
    [NewStatus]      VARCHAR (50)   NULL,
    [AddDate]        DATETIME       NULL,
    [AddID]          INT            NULL,
    [ApprovalNeeded] INT            NULL,
    [ApprovalID]     INT            NULL,
    [ApprovalDate]   DATETIME       NULL,
    [ApprovalStatus] INT            NULL,
    [Reason]         VARCHAR (1000) NULL,
    CONSTRAINT [PK_tblSubPayAppStatusChange] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

