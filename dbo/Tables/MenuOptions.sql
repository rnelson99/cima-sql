CREATE TABLE [dbo].[MenuOptions] (
    [MenuID]        INT           IDENTITY (1, 1) NOT NULL,
    [MenuName]      VARCHAR (50)  NULL,
    [MenuGroup]     VARCHAR (50)  NULL,
    [MenuClass]     VARCHAR (50)  NULL,
    [Sorter]        INT           NULL,
    [ParentID]      INT           NULL,
    [filterOption]  INT           DEFAULT ((0)) NULL,
    [DevCode]       INT           NULL,
    [hiddenField]   VARCHAR (25)  NULL,
    [DefaultValue]  VARCHAR (10)  NULL,
    [indentlvl]     INT           DEFAULT ((0)) NULL,
    [TriggerParent] INT           NULL,
    [hideClass]     VARCHAR (100) NULL,
    [showClass]     VARCHAR (100) NULL,
    CONSTRAINT [PK_MenuOptions] PRIMARY KEY CLUSTERED ([MenuID] ASC)
);


GO

