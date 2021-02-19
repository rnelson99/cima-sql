CREATE TABLE [Contacts].[Insurance] (
    [InsuranceID]   INT        IDENTITY (1, 1) NOT NULL,
    [EntityID]      INT        NULL,
    [InsuranceType] INT        NULL,
    [Amount]        FLOAT (53) NULL,
    [Expiration]    DATE       NULL,
    [Approval]      INT        NULL,
    [AddID]         INT        NULL,
    [AddDate]       DATETIME   NULL,
    [ChangeID]      INT        NULL,
    [ChangeDate]    DATETIME   NULL,
    [ApprovalID]    INT        NULL,
    [ApprovalDate]  DATETIME   NULL,
    [Status]        INT        NULL,
    [wasSuspended]  INT        NULL,
    [documentID]    INT        NULL,
    CONSTRAINT [PK_Insurance] PRIMARY KEY CLUSTERED ([InsuranceID] ASC)
);


GO

