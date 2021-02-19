CREATE TABLE [Contacts].[Deprecated.leads] (
    [leadid]       INT            IDENTITY (1, 1) NOT NULL,
    [leadtype]     INT            NULL,
    [leadquality]  INT            NULL,
    [name]         VARCHAR (100)  NULL,
    [company]      VARCHAR (100)  NULL,
    [email]        VARCHAR (200)  NULL,
    [phone]        VARCHAR (25)   NULL,
    [ourcompany]   VARCHAR (10)   NULL,
    [comment]      VARCHAR (1000) NULL,
    [leadguid]     VARCHAR (50)   NULL,
    [followupdate] DATETIME       NULL,
    [divisions]    VARCHAR (100)  NULL,
    [addid]        INT            NULL,
    [adddate]      DATETIME       NULL,
    [EntityID]     INT            NULL,
    CONSTRAINT [PK_leads] PRIMARY KEY CLUSTERED ([leadid] ASC)
);


GO

