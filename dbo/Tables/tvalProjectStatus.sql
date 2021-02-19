CREATE TABLE [dbo].[tvalProjectStatus] (
    [StatusId]         INT           IDENTITY (1, 1) NOT NULL,
    [CIMA_Status]      NVARCHAR (15) NOT NULL,
    [StatusSortOrder]  INT           NULL,
    [locked]           INT           NULL,
    [ShowActive]       INT           NULL,
    [ShowInactive]     INT           NULL,
    [ShowCloseout]     INT           NULL,
    [ShowBidding]      INT           NULL,
    [ShowCIMA]         INT           NULL,
    [ShowNJ]           INT           NULL,
    [NJCurrentJobList] INT           DEFAULT ((0)) NULL,
    [showOnHold]       INT           NULL,
    [rnk]              INT           NULL,
    CONSTRAINT [PK_tvalProjectStatus] PRIMARY KEY CLUSTERED ([StatusId] ASC),
    CONSTRAINT [uc_CIMA_Status] UNIQUE NONCLUSTERED ([CIMA_Status] ASC)
);


GO

