CREATE TABLE [users].[MobileNotifications] (
    [entityid]      INT            NULL,
    [sTitle]        VARCHAR (100)  NULL,
    [ssubtitle]     VARCHAR (100)  NULL,
    [smessage]      VARCHAR (1000) NULL,
    [referenceID]   INT            NULL,
    [ReferenceType] INT            NULL,
    [AddDate]       DATETIME       CONSTRAINT [DF_MobileNotifications_AddDate] DEFAULT (getdate()) NULL,
    [dbguid]        VARCHAR (50)   CONSTRAINT [DF_MobileNotifications_dbguid] DEFAULT (newid()) NULL,
    [status]        INT            NULL
);


GO

