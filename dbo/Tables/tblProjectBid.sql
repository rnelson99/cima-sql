CREATE TABLE [dbo].[tblProjectBid] (
    [ProjectSubID]         INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]            INT            NULL,
    [VendorID]             INT            NULL,
    [MasterConstDivCodeID] INT            NULL,
    [AddDate]              DATETIME       NULL,
    [AddID]                INT            NULL,
    [ChangeDate]           DATETIME       NULL,
    [ChangeID]             INT            NULL,
    [Status]               INT            NULL,
    [bidding]              TINYINT        CONSTRAINT [DF__tblProjec__biddi__40E497F3] DEFAULT ((0)) NULL,
    [bidrec]               TINYINT        CONSTRAINT [DF__tblProjec__bidre__41D8BC2C] DEFAULT ((0)) NULL,
    [qualified]            TINYINT        CONSTRAINT [DF__tblProjec__quali__42CCE065] DEFAULT ((0)) NULL,
    [drawings]             TINYINT        CONSTRAINT [DF__tblProjec__drawi__43C1049E] DEFAULT ((0)) NULL,
    [BiddingDate]          DATETIME       NULL,
    [BidRecDate]           DATETIME       NULL,
    [DrawingDate]          DATETIME       NULL,
    [QualifiedDate]        DATETIME       NULL,
    [BaseBid]              MONEY          NULL,
    [SalesTax]             MONEY          NULL,
    [Total]                MONEY          NULL,
    [BidType]              VARCHAR (1000) NULL,
    [SalesTaxInc]          BIT            NULL,
    [LaborInc]             BIT            NULL,
    [MaterialInc]          BIT            NULL,
    [PerPlansSpecs]        BIT            NULL,
    [IncludesAddenda]      BIT            NULL,
    [BidDueDate]           DATETIME       NULL,
    CONSTRAINT [PK_tblProjectBid] PRIMARY KEY CLUSTERED ([ProjectSubID] ASC)
);


GO

