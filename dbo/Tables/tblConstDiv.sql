CREATE TABLE [dbo].[tblConstDiv] (
    [DivisionID]          INT           IDENTITY (1, 1) NOT NULL,
    [DivisionCode]        VARCHAR (2)   NOT NULL,
    [DivisionDescription] VARCHAR (100) NOT NULL,
    [BiddingShow]         BIT           DEFAULT ((0)) NULL,
    [BiddingDescription]  VARCHAR (100) NULL,
    [GroundUp]            INT           NULL,
    CONSTRAINT [PK_tblConstDiv] PRIMARY KEY CLUSTERED ([DivisionID] ASC),
    CONSTRAINT [UQ_tblConstDiv_Code] UNIQUE NONCLUSTERED ([DivisionCode] ASC)
);


GO

