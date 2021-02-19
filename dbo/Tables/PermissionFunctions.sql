CREATE TABLE [dbo].[PermissionFunctions] (
    [FunctionID] INT          IDENTITY (1, 1) NOT NULL,
    [Func]       VARCHAR (50) NULL,
    CONSTRAINT [PK_PermissionFunctions] PRIMARY KEY CLUSTERED ([FunctionID] ASC)
);


GO

