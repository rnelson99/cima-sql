CREATE TABLE [accounting].[pwaApprovedUSComments] (
    [id]       INT           IDENTITY (1, 1) NOT NULL,
    [PWALogID] INT           NULL,
    [comments] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_pwaApprovedUSComments] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

