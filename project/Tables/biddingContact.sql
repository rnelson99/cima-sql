CREATE TABLE [project].[biddingContact] (
    [id]         INT            IDENTITY (1, 1) NOT NULL,
    [projectid]  INT            NULL,
    [entityid]   INT            NULL,
    [employeeid] INT            NULL,
    [addid]      INT            NULL,
    [adddate]    DATETIME       NULL,
    [method]     INT            NULL,
    [notes]      VARCHAR (1000) NULL,
    [contact]    VARCHAR (100)  NULL,
    [outcome]    INT            NULL,
    CONSTRAINT [PK_biddingContact] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

