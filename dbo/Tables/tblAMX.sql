CREATE TABLE [dbo].[tblAMX] (
    [amxid]    INT           IDENTITY (1, 1) NOT NULL,
    [name]     VARCHAR (100) NULL,
    [cardnum]  VARCHAR (100) NULL,
    [entityid] INT           NULL,
    CONSTRAINT [PK_tblAMX] PRIMARY KEY CLUSTERED ([amxid] ASC)
);


GO

