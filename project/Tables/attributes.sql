CREATE TABLE [project].[attributes] (
    [id]            INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]     INT           NULL,
    [attribute]     VARCHAR (MAX) NULL,
    [attributetype] VARCHAR (50)  NULL,
    [adddate]       DATETIME      NULL,
    [changedate]    DATETIME      NULL,
    [addid]         INT           NULL,
    [ChangeID]      INT           NULL,
    [Status]        INT           NULL,
    CONSTRAINT [PK_attributes_2] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

