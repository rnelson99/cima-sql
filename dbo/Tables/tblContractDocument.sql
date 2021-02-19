CREATE TABLE [dbo].[tblContractDocument] (
    [ContractDocumentID]          INT            IDENTITY (1, 1) NOT NULL,
    [ContractDocumentName]        NVARCHAR (255) NULL,
    [ContractDocumentDescription] NVARCHAR (255) NULL,
    [ContractDocumentDate]        DATETIME       NULL,
    [ProjectID]                   INT            NULL,
    [Selected]                    BIT            DEFAULT ((0)) NOT NULL,
    [AddID]                       INT            NULL,
    [ChangeID]                    INT            NULL,
    [AddDate]                     DATETIME       NULL,
    [ChangeDate]                  DATETIME       NULL,
    [Status]                      INT            CONSTRAINT [DF__tblContra__Statu__54376389] DEFAULT ((1)) NULL,
    [Sorter]                      INT            NULL,
    CONSTRAINT [ContractDocumentID] PRIMARY KEY CLUSTERED ([ContractDocumentID] ASC)
);


GO

