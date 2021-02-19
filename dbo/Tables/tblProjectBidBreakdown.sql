CREATE TABLE [dbo].[tblProjectBidBreakdown] (
    [BidBreakdownID] INT            IDENTITY (1, 1) NOT NULL,
    [VendorID]       INT            NULL,
    [ProjectID]      INT            NULL,
    [CodeID]         INT            NULL,
    [Bid]            MONEY          NULL,
    [Carry]          MONEY          NULL,
    [Comments]       VARCHAR (1000) NULL,
    [AddID]          INT            NULL,
    [AddDate]        DATETIME       NULL,
    [ChangeID]       INT            NULL,
    [ChangeDate]     DATETIME       NULL,
    CONSTRAINT [PK_tblProjectBidBreakdown] PRIMARY KEY CLUSTERED ([BidBreakdownID] ASC)
);


GO

