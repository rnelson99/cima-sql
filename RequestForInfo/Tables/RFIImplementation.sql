CREATE TABLE [RequestForInfo].[RFIImplementation] (
    [RFIImplementationID] INT      IDENTITY (1, 1) NOT NULL,
    [RFIIssueID]          INT      NULL,
    [RequestForInfoID]    INT      NULL,
    [IsResponseAdequate]  INT      CONSTRAINT [DF_RFIImplementation_IsResponseAdequate] DEFAULT ((0)) NULL,
    [IsCostImpact]        INT      CONSTRAINT [DF_RFIImplementation_IsCostImpact] DEFAULT ((0)) NULL,
    [IsTimeImpact]        INT      CONSTRAINT [DF_RFIImplementation_IsTimeImpact] DEFAULT ((0)) NULL,
    [TimeImpactWorkDays]  INT      NULL,
    [AffectedDrawings]    INT      CONSTRAINT [DF_RFIImplementation_AffectedDrawings] DEFAULT ((0)) NULL,
    [AffectedSpecs]       INT      CONSTRAINT [DF_RFIImplementation_AffectedSpecs] DEFAULT ((0)) NULL,
    [AddID]               INT      NULL,
    [AddDate]             DATETIME CONSTRAINT [DF_RFIImplementation_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]            INT      NULL,
    [ChangeDate]          DATETIME NULL,
    CONSTRAINT [PK_RFIImplementation] PRIMARY KEY CLUSTERED ([RFIImplementationID] ASC)
);


GO

