CREATE TABLE [dbo].[Deprecated.Lookups] (
    [LookupID]    INT          NULL,
    [Description] VARCHAR (50) NULL,
    [Active]      BIT          CONSTRAINT [DF_Lookups_Active] DEFAULT ((1)) NULL,
    [AddID]       INT          NULL,
    [AddDate]     DATETIME     NULL,
    [ChangeID]    INT          NULL,
    [ChangeDate]  DATETIME     NULL,
    [LookupType]  VARCHAR (50) NULL
);


GO

