CREATE TABLE [accounting].[SubPayApp] (
    [SubPayAppID]        INT            IDENTITY (1, 1) NOT NULL,
    [PayAmount]          MONEY          NULL,
    [RetainagePercent]   FLOAT (53)     NULL,
    [RetainageAmount]    MONEY          NULL,
    [RetainagePayOut]    MONEY          CONSTRAINT [DF_SubPayApp_RetainagePayOut] DEFAULT ((0)) NULL,
    [ProjectID]          INT            NULL,
    [EntityID]           INT            NULL,
    [PWALogNumber]       INT            NULL,
    [ContactEntityID]    INT            NULL,
    [ContactAddressID]   INT            NULL,
    [revisionNumber]     INT            NULL,
    [FlagRevisions]      INT            NULL,
    [ownerPayAppNumber]  FLOAT (53)     NULL,
    [ucond]              INT            NULL,
    [cond]               INT            NULL,
    [dateDue]            DATETIME       NULL,
    [SubPayAppDate]      DATETIME       CONSTRAINT [DF_SubPayApp_SubPayAppDate] DEFAULT (getdate()) NULL,
    [startDate]          DATETIME       NULL,
    [endDue]             DATETIME       NULL,
    [addid]              INT            NULL,
    [adddate]            DATETIME       NULL,
    [changeid]           INT            NULL,
    [changedate]         DATETIME       NULL,
    [PWALogID]           INT            NULL,
    [SubPayAppSeq]       FLOAT (53)     NULL,
    [StoredMaterial]     MONEY          NULL,
    [PayAppStatusID]     INT            CONSTRAINT [DF_SubPayApp_PayAppStatusID] DEFAULT ((1)) NULL,
    [apptype]            INT            CONSTRAINT [DF_SubPayApp_apptype] DEFAULT ((1)) NULL,
    [vendorinvoiceno]    VARCHAR (100)  NULL,
    [HaveStoredMaterial] INT            NULL,
    [InvoiceID]          INT            NULL,
    [OPAComments]        VARCHAR (1000) NULL,
    [modifiedNet]        MONEY          NULL,
    CONSTRAINT [PK_SubPayApp] PRIMARY KEY CLUSTERED ([SubPayAppID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [ProjectID_INDEX]
    ON [accounting].[SubPayApp]([ProjectID] ASC, [EntityID] ASC)
    INCLUDE([SubPayAppID]);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1', @level0type = N'SCHEMA', @level0name = N'accounting', @level1type = N'TABLE', @level1name = N'SubPayApp', @level2type = N'COLUMN', @level2name = N'apptype';


GO

