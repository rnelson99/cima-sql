CREATE TABLE [Contacts].[Deprecated.VendorWarnings] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [EntityID]     INT           NULL,
    [Warning]      VARCHAR (50)  NULL,
    [addDate]      DATETIME      CONSTRAINT [DF_VendorWarnings_addDate] DEFAULT (getdate()) NULL,
    [status]       INT           CONSTRAINT [DF_VendorWarnings_status] DEFAULT ((1)) NULL,
    [addid]        INT           CONSTRAINT [DF_VendorWarnings_addid] DEFAULT ((0)) NULL,
    [ProjectID]    INT           CONSTRAINT [DF_VendorWarnings_ProjectID] DEFAULT ((0)) NULL,
    [ClearedID]    INT           NULL,
    [ClearedDate]  DATETIME      NULL,
    [comments]     VARCHAR (MAX) NULL,
    [approvalID]   INT           NULL,
    [approvalDate] DATETIME      NULL,
    CONSTRAINT [PK_VendorWarnings] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

