CREATE TABLE [project].[relatedEntity] (
    [id]                  INT      IDENTITY (1, 1) NOT NULL,
    [projectid]           INT      NULL,
    [entityid]            INT      NULL,
    [RelatedEntityTypeID] INT      NULL,
    [Status]              INT      NULL,
    [AddID]               INT      NULL,
    [AddDate]             DATETIME CONSTRAINT [DF_relatedEntity_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]            INT      NULL,
    [ChangeDate]          DATETIME NULL,
    [isApprover]          INT      NULL,
    CONSTRAINT [PK_relatedEntity] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

