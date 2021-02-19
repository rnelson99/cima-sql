CREATE TABLE [dbo].[TableListing] (
    [ColumnName]  [sysname] NULL,
    [TableName]   [sysname] NOT NULL,
    [SchemaName]  [sysname] NOT NULL,
    [EntityMerge] INT       DEFAULT ((0)) NULL,
    [newRecord]   INT       DEFAULT ((1)) NULL
);


GO

