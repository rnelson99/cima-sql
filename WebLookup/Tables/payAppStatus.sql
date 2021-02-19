CREATE TABLE [WebLookup].[payAppStatus] (
    [PayAppStatusID]    INT          NULL,
    [PayAppStatus]      VARCHAR (50) NULL,
    [locked]            INT          NULL,
    [sorter]            INT          NULL,
    [status]            INT          NULL,
    [NoTotal]           INT          NULL,
    [acctingPermission] INT          DEFAULT ((1)) NULL,
    [inProcess]         INT          DEFAULT ((0)) NULL
);


GO

