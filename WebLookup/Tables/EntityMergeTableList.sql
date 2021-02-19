CREATE TABLE [WebLookup].[EntityMergeTableList] (
    [ColumnName]       [sysname]      NULL,
    [TableName]        [sysname]      NOT NULL,
    [is_identity]      BIT            NOT NULL,
    [name]             [sysname]      NOT NULL,
    [PrimaryKeyColumn] NVARCHAR (128) NULL
);


GO

