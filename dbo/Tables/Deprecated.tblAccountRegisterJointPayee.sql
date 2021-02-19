CREATE TABLE [dbo].[Deprecated.tblAccountRegisterJointPayee] (
    [ID]                     INT      IDENTITY (1, 1) NOT NULL,
    [AccountRegisterLocalID] INT      NULL,
    [JointPayeeEntityID]     INT      NULL,
    [AddID]                  INT      NULL,
    [AddDate]                DATETIME NULL,
    [ChangeID]               INT      NULL,
    [ChangeDate]             DATETIME NULL,
    [Status]                 INT      NULL,
    CONSTRAINT [PK_tblAccountRegisterJointPayee] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

