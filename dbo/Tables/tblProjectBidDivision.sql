CREATE TABLE [dbo].[tblProjectBidDivision] (
    [ProjectDivID]  INT      IDENTITY (1, 1) NOT NULL,
    [ProjectID]     INT      NULL,
    [DivisonCodeID] INT      NULL,
    [AddDate]       DATETIME NULL,
    [AddID]         INT      NULL,
    [ChangeDate]    DATETIME NULL,
    [ChangeID]      INT      NULL,
    [Status]        INT      NULL,
    [CodeID]        INT      NULL,
    CONSTRAINT [PK_tblProjectBidDivision] PRIMARY KEY CLUSTERED ([ProjectDivID] ASC)
);


GO

