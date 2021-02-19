CREATE TABLE [Contacts].[NewLeadsDivision] (
    [ID]         INT      IDENTITY (1, 1) NOT NULL,
    [LeadID]     INT      NULL,
    [DivisionID] INT      NULL,
    [AddID]      INT      NULL,
    [AddDate]    DATETIME NULL,
    CONSTRAINT [PK_NewLeadsDivision] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

