CREATE TABLE [project].[bidding] (
    [ProjectBidID]     INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]        INT            NULL,
    [EntityID]         INT            NULL,
    [EmployeeEntityID] INT            NULL,
    [DivisionID]       INT            NULL,
    [CodeID]           INT            NULL,
    [Blackboard]       VARCHAR (1000) NULL,
    [status]           INT            NULL,
    [isDelete]         INT            NULL,
    [biddingGUID]      VARCHAR (50)   NULL,
    [manualAdd]        INT            NULL,
    CONSTRAINT [PK_bidding] PRIMARY KEY CLUSTERED ([ProjectBidID] ASC)
);


GO

