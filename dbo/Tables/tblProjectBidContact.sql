CREATE TABLE [dbo].[tblProjectBidContact] (
    [ProjectSubContactID] INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]           INT           NULL,
    [VendorID]            INT           NULL,
    [ContactType]         INT           NULL,
    [ContactResult]       INT           NULL,
    [AddDate]             DATETIME      NULL,
    [AddID]               INT           NULL,
    [Comments]            VARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblProjectBidContact] PRIMARY KEY CLUSTERED ([ProjectSubContactID] ASC)
);


GO

