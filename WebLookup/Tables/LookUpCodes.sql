CREATE TABLE [WebLookup].[LookUpCodes] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [Val]           VARCHAR (100)  NULL,
    [LookupType]    VARCHAR (100)  NULL,
    [DeveloperCode] INT            NULL,
    [Sorter]        INT            NULL,
    [Sorter2]       INT            NULL,
    [Email]         BIT            DEFAULT ((0)) NULL,
    [varFloat1]     FLOAT (53)     NULL,
    [varFloat2]     FLOAT (53)     NULL,
    [Status]        INT            NULL,
    [varVarChar1]   VARCHAR (1000) NULL,
    [isPhone]       INT            NULL,
    [varInt1]       INT            NULL,
    [Reminder]      INT            NULL,
    [StartDate]     INT            NULL,
    [endDate]       INT            NULL,
    [grp]           VARCHAR (100)  NULL,
    CONSTRAINT [PK_LookUpCodes] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

