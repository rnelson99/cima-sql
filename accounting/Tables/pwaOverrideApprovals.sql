CREATE TABLE [accounting].[pwaOverrideApprovals] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [PWALogID]   INT           NULL,
    [type]       VARCHAR (100) NULL,
    [EntityID]   INT           NULL,
    [dtDateTime] DATETIME      NULL,
    [PX]         INT           NULL,
    [Accting]    INT           NULL,
    [Status]     INT           DEFAULT ((1)) NULL,
    CONSTRAINT [PK_pwaOverrideApprovals] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

