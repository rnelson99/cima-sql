CREATE TABLE [dbo].[tlkpPWAQuickSpecAllPWAs] (
    [QuickSpecID]          INT           IDENTITY (1, 1) NOT NULL,
    [QuickSpecNumber]      INT           NULL,
    [QuickSpecName]        VARCHAR (255) NULL,
    [QuickSpecDescription] VARCHAR (MAX) NULL,
    [QuickSpecType]        NVARCHAR (50) NULL,
    [Status]               INT           DEFAULT ((1)) NULL,
    [AddID]                INT           NULL,
    [ChangeID]             INT           NULL,
    [AddDate]              DATETIME      NULL,
    [ChangeDate]           DATETIME      NULL,
    [ProjectID]            INT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tlkpPWAQuickSpecAllPWAs] PRIMARY KEY CLUSTERED ([QuickSpecID] ASC)
);


GO

