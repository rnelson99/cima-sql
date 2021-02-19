CREATE TABLE [Contacts].[ContactLog] (
    [ContactLogID]    INT            IDENTITY (1, 1) NOT NULL,
    [EntityID]        INT            NULL,
    [ContactType]     INT            NULL,
    [Comments]        VARCHAR (1000) NULL,
    [AddID]           INT            NULL,
    [AddDate]         DATETIME       NULL,
    [Status]          INT            NULL,
    [ContactInfo]     VARCHAR (200)  NULL,
    [contactvariable] INT            NULL,
    CONSTRAINT [PK_ContactLog] PRIMARY KEY CLUSTERED ([ContactLogID] ASC)
);


GO

