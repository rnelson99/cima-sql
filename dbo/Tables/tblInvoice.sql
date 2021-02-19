CREATE TABLE [dbo].[tblInvoice] (
    [InvoiceID]                 INT             IDENTITY (1, 1) NOT NULL,
    [InvoiceNumber]             INT             NULL,
    [OwnerPayAppNumber]         VARCHAR (100)   NULL,
    [InvoiceDate]               DATETIME        NULL,
    [ProjectID]                 INT             NULL,
    [IgnoreInvoiceWarning]      BIT             DEFAULT ((0)) NOT NULL,
    [InvoiceDueDate]            DATETIME        NULL,
    [InvoiceStatus]             NVARCHAR (50)   NULL,
    [RetainagePercentage]       DECIMAL (18, 5) DEFAULT ((0.0)) NOT NULL,
    [Status]                    NVARCHAR (50)   NOT NULL,
    [BillingStartDate]          DATETIME        NULL,
    [BillingEndDate]            DATETIME        NULL,
    [ApprovedOCOPrior_Positive] MONEY           NULL,
    [ApprovedOCOPrior_Negative] MONEY           NULL,
    [ApprovedOCONew_Positive]   MONEY           NULL,
    [ApprovedOCONew_Negative]   MONEY           NULL,
    [WorkTotalPrior]            MONEY           NULL,
    [WorkTotalNew]              MONEY           NULL,
    [StoredPrior]               MONEY           NULL,
    [StoredNew]                 MONEY           NULL,
    [PriorPayments]             MONEY           NULL,
    [PercentCompletePrior]      DECIMAL (18, 5) NULL,
    [PercentComplete]           DECIMAL (18, 5) NULL,
    [RetainagePrior]            MONEY           NULL,
    [Retainage]                 MONEY           NULL,
    [RemainingUnbilled]         MONEY           NULL,
    [InvoiceGross]              MONEY           NULL,
    [ContactId]                 INT             NULL,
    [AddressId]                 INT             NULL,
    [LastModifiedDate]          DATETIME        NULL,
    [LastModifiedBy]            INT             NULL,
    [DisabileOverdueWarning]    BIT             CONSTRAINT [DF_tblInvoice_DisabileOverdueWarning] DEFAULT ((0)) NOT NULL,
    [OverrideLienAmount]        MONEY           NULL,
    [contactEntityID]           INT             NULL,
    [contactAddressID]          INT             NULL,
    [clientPO]                  VARCHAR (100)   NULL,
    [ServicesInvoice]           INT             DEFAULT ((0)) NULL,
    [totalServiceAmount]        MONEY           NULL,
    [totalExpenseAmount]        MONEY           NULL,
    [totalServiceTax]           MONEY           NULL,
    [totalExpenseTax]           MONEY           NULL,
    [cimaGC]                    MONEY           NULL,
    [cimaOHP]                   MONEY           NULL,
    [totalInvoiceGross]         MONEY           NULL,
    CONSTRAINT [InvoiceID] PRIMARY KEY CLUSTERED ([InvoiceID] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Overhead and profit. It is used on cost plus projects.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'cimaOHP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This defaults to the last day of the closest month. Aug16-Sept15 = August 31. Sept16-Oct15=Sept30, etc. User entry, they can override. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'BillingEndDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Visible date that is diplayed on invoice.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'InvoiceDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stored materials. Rarely used.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'StoredNew';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is total amount before subtracting retainage.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'totalInvoiceGross';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Field to be deprecated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'ApprovedOCOPrior_Positive';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'FK: dbo.Tbl.project. This is the used by the system for linking. User cannot edit.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'ProjectID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Database only ID. Not editable by user', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'InvoiceID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Change to integer; 1: Void, 0 - Draft, 1-Locked (Locked can be unlocked, but unlocking it will create a duplicate, and void the prior version)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'Status';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Gross new work.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'WorkTotalNew';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Autogenerated ID (sequential systemwide), but user can change. Not normally changed.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'InvoiceNumber';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Markup in general conditions. Sometimes used for cost plus. Generally not used.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'cimaGC';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This defaults to the project milestones start date. If there is a prior invoice, it defaults to prior invoice end date +1 day.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'BillingStartDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Autogenerated. Sequential to project. User can and often does change to match owner''s ID numbers.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'OwnerPayAppNumber';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stored materials. Rarely used.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'StoredPrior';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'In new table, change to integer: 1:Interim. 2:Final (Should change to invoiceType. It is not a status)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'InvoiceStatus';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total Tax on fees.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'totalServiceTax';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Field to be deprecated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'ApprovedOCONew_Negative';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sept 2020 - Current Invoice Table - Planned to be replaced', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typical difference from gross invoice to net invoice. Where used, it is normally 10% (entered as 0.10)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'RetainagePercentage';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dollar amount of taxes paid on expenses. Sometimes zero. Sometimes calculated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'totalExpenseTax';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Field to be deprecated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'WorkTotalPrior';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Total amount of services where hours are billed x billing rate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'totalServiceAmount';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Not in use.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'IgnoreInvoiceWarning';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Field to be deprecated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'ApprovedOCOPrior_Negative';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Itemized expenses plus subcontractor fees that are filled to client.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'totalExpenseAmount';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'This is typically net 15 or net 30. User can change.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'InvoiceDueDate';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Field to be deprecated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'tblInvoice', @level2type = N'COLUMN', @level2name = N'ApprovedOCONew_Positive';


GO

