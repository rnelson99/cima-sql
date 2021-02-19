CREATE TABLE [project].[OwnerSupplies] (
    [OwnerSuppliesID] INT            IDENTITY (1, 1) NOT NULL,
    [ProjectID]       INT            NULL,
    [Div]             INT            NULL,
    [Materials]       VARCHAR (50)   NULL,
    [Company]         INT            NULL,
    [Contact]         INT            NULL,
    [LeadTime]        INT            NULL,
    [NextCordination] DATE           NULL,
    [StartDate]       DATE           NULL,
    [EndDate]         DATE           NULL,
    [PercentComplete] FLOAT (53)     NULL,
    [Comments]        VARCHAR (1000) NULL,
    [LastModified]    DATE           NULL,
    [AddID]           INT            NULL,
    [AddDate]         DATETIME       NULL,
    [ChangeID]        INT            NULL,
    [ChangeTime]      DATETIME       NULL,
    [isDelete]        INT            NULL,
    CONSTRAINT [PK_project.Owner-Supplies] PRIMARY KEY CLUSTERED ([OwnerSuppliesID] ASC)
);


GO

