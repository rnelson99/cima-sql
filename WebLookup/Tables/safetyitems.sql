CREATE TABLE [WebLookup].[safetyitems] (
    [id]     INT            IDENTITY (1, 1) NOT NULL,
    [grp]    VARCHAR (100)  NULL,
    [itm]    VARCHAR (1000) NULL,
    [status] INT            NULL,
    [sorter] INT            NULL,
    CONSTRAINT [PK_safetyitems] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

