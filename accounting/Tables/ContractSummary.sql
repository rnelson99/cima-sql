CREATE TABLE [accounting].[ContractSummary] (
    [ID]                INT   IDENTITY (1, 1) NOT NULL,
    [subpayappid]       INT   NULL,
    [totalapp]          MONEY NULL,
    [base]              MONEY NULL,
    [approved]          MONEY NULL,
    [pending]           MONEY NULL,
    [totalcomplete]     MONEY NULL,
    [workcomplete]      MONEY NULL,
    [storedmaterial]    MONEY NULL,
    [remainingcontact]  MONEY NULL,
    [remainingwork]     MONEY NULL,
    [retainage]         MONEY NULL,
    [projectid]         INT   NULL,
    [entityid]          INT   NULL,
    [pwalogid]          INT   NULL,
    [subpayappsequence] INT   NULL,
    [locked]            INT   NULL,
    CONSTRAINT [PK_ContractSummary] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

