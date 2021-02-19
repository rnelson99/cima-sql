CREATE TABLE [WebLookup].[HelpTable] (
    [helpID]    INT            IDENTITY (1, 1) NOT NULL,
    [RefID]     INT            NULL,
    [HelpTitle] VARCHAR (100)  NULL,
    [HelpDesc]  VARCHAR (1000) NULL,
    CONSTRAINT [PK_HelpTable] PRIMARY KEY CLUSTERED ([helpID] ASC)
);


GO

