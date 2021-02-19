CREATE TABLE [dbo].[Deprecated.tblEstimateCIMA] (
    [EstimateCIMAID]                  INT           IDENTITY (1, 1) NOT NULL,
    [ProjectID]                       INT           NOT NULL,
    [EstimateDate]                    DATETIME      NULL,
    [EstimateAmount]                  MONEY         DEFAULT ((0)) NOT NULL,
    [LastModifiedByUserInitials]      VARCHAR (50)  NULL,
    [EstimateLastModified]            DATETIME      DEFAULT (getdate()) NOT NULL,
    [EstimateType]                    VARCHAR (50)  DEFAULT ('Full') NOT NULL,
    [EstimateLinkFullPathAndFileName] VARCHAR (255) NULL,
    [EstimateLinkFileNameOnly]        VARCHAR (255) NULL,
    CONSTRAINT [PK_tblEstimateCIMA] PRIMARY KEY CLUSTERED ([EstimateCIMAID] ASC)
);


GO

