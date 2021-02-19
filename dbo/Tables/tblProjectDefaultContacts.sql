CREATE TABLE [dbo].[tblProjectDefaultContacts] (
    [Id]              INT          IDENTITY (1, 1) NOT NULL,
    [ProjectId]       INT          NOT NULL,
    [Role]            VARCHAR (50) NOT NULL,
    [ClientContactId] INT          NULL,
    CONSTRAINT [PK_tblProjectDefaultContacts] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

