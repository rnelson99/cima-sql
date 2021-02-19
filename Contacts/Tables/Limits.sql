CREATE TABLE [Contacts].[Limits] (
    [LimitID]     INT            IDENTITY (1, 1) NOT NULL,
    [EntityID]    INT            NULL,
    [Changes]     VARCHAR (1000) NULL,
    [Severity]    INT            NULL,
    [Limitations] VARCHAR (100)  NULL,
    [AddID]       INT            NULL,
    [AddDate]     DATETIME       NULL,
    [ChangeID]    INT            NULL,
    [ChangeDate]  DATETIME       NULL,
    [Status]      INT            NULL,
    CONSTRAINT [PK_Limits] PRIMARY KEY CLUSTERED ([LimitID] ASC)
);


GO

