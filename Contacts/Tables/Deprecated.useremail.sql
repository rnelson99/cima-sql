CREATE TABLE [Contacts].[Deprecated.useremail] (
    [ID]       INT            IDENTITY (1, 1) NOT NULL,
    [EntityID] INT            NULL,
    [code]     VARCHAR (1000) NULL,
    [token]    VARCHAR (1000) NULL,
    [addDate]  DATETIME       CONSTRAINT [DF_UserEmail_addDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_UserEmail_1] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

