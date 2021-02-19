CREATE TABLE [project].[salesTaxDetermination] (
    [taxDet]             INT          IDENTITY (1, 1) NOT NULL,
    [projectID]          INT          NULL,
    [purchaseTax]        INT          NULL,
    [saleTax]            INT          NULL,
    [status]             INT          CONSTRAINT [DF_salesTaxDetermination_status] DEFAULT ((1)) NULL,
    [addid]              INT          NULL,
    [adddate]            DATETIME     CONSTRAINT [DF_salesTaxDetermination_adddate] DEFAULT (getdate()) NULL,
    [changeid]           INT          NULL,
    [changedate]         DATETIME     NULL,
    [ProjectTaxQuestion] INT          NULL,
    [dbguid]             VARCHAR (50) NULL,
    [approver1]          INT          NULL,
    [approver2]          INT          NULL,
    CONSTRAINT [PK_salesTaxDetermination] PRIMARY KEY CLUSTERED ([taxDet] ASC)
);


GO

