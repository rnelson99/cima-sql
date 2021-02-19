CREATE TABLE [Contacts].[NewLeads] (
    [leadID]      INT           IDENTITY (1, 1) NOT NULL,
    [leadType]    VARCHAR (50)  NULL,
    [CompanyName] VARCHAR (200) NULL,
    [Contact]     VARCHAR (200) NULL,
    [Phone]       VARCHAR (50)  NULL,
    [Notes]       VARCHAR (MAX) NULL,
    [AddID]       INT           NULL,
    [AddDate]     DATETIME      NULL,
    [EntityID]    INT           NULL,
    CONSTRAINT [PK_NewLeads] PRIMARY KEY CLUSTERED ([leadID] ASC)
);


GO

