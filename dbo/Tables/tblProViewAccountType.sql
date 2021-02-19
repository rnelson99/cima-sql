CREATE TABLE [dbo].[tblProViewAccountType] (
    [ProViewAccountTypeID]   INT           IDENTITY (1, 1) NOT NULL,
    [ProViewAccountTypeName] VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_tblProViewAccountType] PRIMARY KEY CLUSTERED ([ProViewAccountTypeID] ASC),
    CONSTRAINT [UC_tblProViewAccountType_ProViewAccountTypeName] UNIQUE NONCLUSTERED ([ProViewAccountTypeName] ASC)
);


GO

