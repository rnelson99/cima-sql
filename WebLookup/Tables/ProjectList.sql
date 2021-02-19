CREATE TABLE [WebLookup].[ProjectList] (
    [ProjectID]       INT           NOT NULL,
    [ProjectName]     VARCHAR (100) NULL,
    [CIMA_Status]     NVARCHAR (15) NULL,
    [ProjectNum]      NVARCHAR (50) NULL,
    [ShowActive]      INT           NULL,
    [ShowInactive]    INT           NULL,
    [ShowBidding]     INT           NULL,
    [ShowCloseout]    INT           NULL,
    [ShowCIMA]        INT           NULL,
    [ShowNJ]          INT           NULL,
    [rnk]             BIGINT        NULL,
    [projectnamenum]  VARCHAR (200) NULL,
    [parentProjectID] INT           NULL
);


GO

