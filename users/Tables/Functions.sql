CREATE TABLE [users].[Functions] (
    [FunctionID]  INT            IDENTITY (1, 1) NOT NULL,
    [SecFunction] VARCHAR (50)   NULL,
    [Description] VARCHAR (1000) NULL,
    [Status]      INT            CONSTRAINT [DF_Functions_Status] DEFAULT ((1)) NULL,
    [MiscCode]    VARCHAR (20)   NULL,
    [showCRUD]    INT            DEFAULT ((1)) NULL,
    [showY]       INT            DEFAULT ((0)) NULL,
    [groupBy]     VARCHAR (50)   NULL,
    CONSTRAINT [PK_Functions] PRIMARY KEY CLUSTERED ([FunctionID] ASC)
);


GO

