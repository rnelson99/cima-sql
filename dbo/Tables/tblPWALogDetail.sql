CREATE TABLE [dbo].[tblPWALogDetail] (
    [PWALogDetailID]          INT           IDENTITY (1, 1) NOT NULL,
    [PWALogDetailNumber]      INT           NULL,
    [PWALogDetailDescription] VARCHAR (MAX) NULL,
    [PWALogDetailType]        NVARCHAR (50) NULL,
    [PWALogID]                INT           NOT NULL,
    [RV]                      ROWVERSION    NOT NULL,
    [QuickSpecNumber]         INT           NULL,
    [status]                  INT           NULL,
    [isEdited]                INT           NULL,
    [AddID]                   INT           NULL,
    [ChangeID]                INT           NULL,
    [AddDate]                 DATETIME      NULL,
    [ChangeDate]              DATETIME      NULL,
    [sorter]                  INT           NULL,
    CONSTRAINT [PK_tblPWALogDetail] PRIMARY KEY CLUSTERED ([PWALogDetailID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190607-095923]
    ON [dbo].[tblPWALogDetail]([PWALogID] ASC)
    INCLUDE([PWALogDetailID], [PWALogDetailNumber], [PWALogDetailType]);


GO

