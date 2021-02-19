CREATE TABLE [accounting].[Deprecated.generalledger] (
    [generalLedgerID] INT          IDENTITY (1, 1) NOT NULL,
    [glGUID]          VARCHAR (50) CONSTRAINT [DF_generalledger_glGUID] DEFAULT (newid()) NULL,
    [glType]          INT          NULL,
    [projectID]       INT          NULL,
    [entityID]        INT          NULL,
    [SubPayAppId]     INT          NULL,
    [codeID]          INT          NULL,
    [amount]          MONEY        NULL,
    [budgetLineItem]  INT          CONSTRAINT [DF_generalledger_budgetLineItem] DEFAULT ((0)) NULL,
    [addID]           INT          NULL,
    [addDate]         DATETIME     NULL,
    [status]          INT          CONSTRAINT [DF_generalledger_status] DEFAULT ((1)) NULL,
    [changeID]        INT          NULL,
    [changeDate]      DATETIME     NULL,
    CONSTRAINT [PK_generalledger] PRIMARY KEY CLUSTERED ([generalLedgerID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'div code id', @level0type = N'SCHEMA', @level0name = N'accounting', @level1type = N'TABLE', @level1name = N'Deprecated.generalledger', @level2type = N'COLUMN', @level2name = N'codeID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Division or Overhead', @level0type = N'SCHEMA', @level0name = N'accounting', @level1type = N'TABLE', @level1name = N'Deprecated.generalledger', @level2type = N'COLUMN', @level2name = N'glType';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'VendorID, ClientID, etc', @level0type = N'SCHEMA', @level0name = N'accounting', @level1type = N'TABLE', @level1name = N'Deprecated.generalledger', @level2type = N'COLUMN', @level2name = N'entityID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SubPayAppId ', @level0type = N'SCHEMA', @level0name = N'accounting', @level1type = N'TABLE', @level1name = N'Deprecated.generalledger', @level2type = N'COLUMN', @level2name = N'SubPayAppId';


GO

