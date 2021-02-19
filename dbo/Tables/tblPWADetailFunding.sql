CREATE TABLE [dbo].[tblPWADetailFunding] (
    [PWADetailFundingID]           INT           IDENTITY (1, 1) NOT NULL,
    [PWALogID]                     INT           NOT NULL,
    [ProjectID]                    INT           NOT NULL,
    [VendorID]                     INT           NOT NULL,
    [ProjectWorkID]                INT           NULL,
    [MasterConstDivCodeID]         INT           NULL,
    [ConstructionDivCode_INFO]     NVARCHAR (15) NULL,
    [DivCodeAcctCat_INFO]          NVARCHAR (35) NULL,
    [DivCodeAcctItem_INFO]         NVARCHAR (35) NULL,
    [UncommittedAmount_INFO]       MONEY         DEFAULT ((0)) NOT NULL,
    [RequiredAmount]               MONEY         DEFAULT ((0)) NULL,
    [ShortfallAmount_CALC]         MONEY         DEFAULT ((0)) NOT NULL,
    [ShortfallReason]              VARCHAR (255) NULL,
    [PWADetailFundingStatus]       VARCHAR (50)  NULL,
    [PWADetailWorkDays_INFO]       INT           NULL,
    [PWADetailAvailWorkDays_INFO]  INT           NULL,
    [PWADetailStartDate_INFO]      DATETIME      NULL,
    [PWADetailEndDate_INFO]        DATETIME      NULL,
    [PWADetailFundingLastModified] DATETIME      NULL,
    [CommittedAllPWAs_INFO]        MONEY         DEFAULT ((0)) NOT NULL,
    [CommittedThisPWA_INFO]        MONEY         DEFAULT ((0)) NOT NULL,
    [RV]                           ROWVERSION    NOT NULL,
    [ShortfallCreatedUser]         VARCHAR (255) NULL,
    [ShortfallCreatedOn]           DATETIME      NULL,
    [AddID]                        INT           NULL,
    [ChangeID]                     INT           NULL,
    [AddDate]                      DATETIME      NULL,
    [ChangeDate]                   DATETIME      NULL,
    CONSTRAINT [PK_tblPWADetailFunding] PRIMARY KEY CLUSTERED ([PWADetailFundingID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190605-161043]
    ON [dbo].[tblPWADetailFunding]([PWALogID] ASC)
    INCLUDE([PWADetailFundingID]);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190605-161105]
    ON [dbo].[tblPWADetailFunding]([ProjectID] ASC)
    INCLUDE([PWADetailFundingID], [PWALogID]);


GO

