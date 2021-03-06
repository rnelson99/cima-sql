CREATE TABLE [dbo].[tblPWALog] (
    [PWALogID]                  INT             IDENTITY (1, 1) NOT NULL,
    [ProjectID]                 INT             NOT NULL,
    [VendorID]                  INT             NOT NULL,
    [ClientID]                  INT             NOT NULL,
    [PWALogTypeID]              INT             NOT NULL,
    [PWALogNumber]              INT             NULL,
    [PWALogAmount]              DECIMAL (18, 2) NULL,
    [PWALogDateIssued]          DATETIME        NULL,
    [PWAStatusID]               INT             NULL,
    [PWALockStatus]             VARCHAR (25)    NULL,
    [ParentPWAID]               INT             NULL,
    [SubShallProvide]           INT             NULL,
    [PWALogLastModified]        DATETIME        NULL,
    [PWAObsolete]               BIT             DEFAULT ((0)) NOT NULL,
    [PWALogFullPathAndFileName] VARCHAR (255)   NULL,
    [PONumber]                  VARCHAR (50)    NULL,
    [EstimateOfCompletedWork]   DECIMAL (18, 2) NULL,
    [EstimateOfStoredMaterial]  DECIMAL (18, 2) NULL,
    [EstimateOfPercentComplete] DECIMAL (18, 2) NULL,
    [NextPayAppType]            VARCHAR (12)    NULL,
    [HoldRetainage]             BIT             DEFAULT ((0)) NULL,
    [RV]                        ROWVERSION      NOT NULL,
    [UseGlobalComplete]         BIT             DEFAULT ((0)) NOT NULL,
    [Payor]                     VARCHAR (25)    NULL,
    [ConstructionDivCode_INFO]  NVARCHAR (15)   NULL,
    [IsDeleted]                 VARCHAR (1)     DEFAULT ('N') NOT NULL,
    [EntityID]                  INT             NULL,
    [AddDate]                   DATETIME        CONSTRAINT [DF_tblPWALog_AddDate] DEFAULT (getdate()) NULL,
    [ChangeDate]                DATETIME        NULL,
    [AddID]                     INT             NULL,
    [ChangeID]                  INT             NULL,
    [whoPaysTax]                INT             NULL,
    [subco]                     VARCHAR (100)   NULL,
    [ChangeOrderID]             INT             DEFAULT ((0)) NULL,
    [CertDone]                  INT             DEFAULT ((0)) NULL,
    [SubcontactorContact]       INT             NULL,
    [revisionNumber]            INT             NULL,
    [FlagRevision]              INT             NULL,
    [InvoiceID]                 INT             NULL,
    [BillAmount]                MONEY           NULL,
    CONSTRAINT [PK_tblPWALog] PRIMARY KEY CLUSTERED ([PWALogID] ASC)
);


GO

