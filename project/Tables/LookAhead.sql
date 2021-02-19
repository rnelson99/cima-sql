CREATE TABLE [project].[LookAhead] (
    [AheadID]    INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]  INT           NULL,
    [EntityID]   INT           NULL,
    [Urgency]    INT           NULL,
    [Activity]   VARCHAR (100) NULL,
    [Working]    INT           NULL,
    [dDate]      DATETIME      NULL,
    [DivCodeID]  INT           NULL,
    [AddID]      INT           NULL,
    [AddDate]    DATETIME      NULL,
    [ChangeID]   INT           NULL,
    [ChangeDate] DATETIME      NULL,
    CONSTRAINT [PK_LookAhead] PRIMARY KEY CLUSTERED ([AheadID] ASC)
);


GO

