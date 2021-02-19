CREATE TABLE [WebLookup].[RelatedEntities] (
    [id]         INT          IDENTITY (1, 1) NOT NULL,
    [Category]   VARCHAR (50) NULL,
    [Type]       VARCHAR (50) NULL,
    [Status]     INT          CONSTRAINT [DF_RelatedEntities_Status] DEFAULT ((1)) NULL,
    [AddID]      INT          NULL,
    [AddDate]    DATETIME     CONSTRAINT [DF_RelatedEntities_AddDate] DEFAULT (getdate()) NULL,
    [ChangeID]   INT          NULL,
    [ChangeDate] DATETIME     NULL,
    [IsApprover] INT          CONSTRAINT [DF_RelatedEntities_IsApprover] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_RelatedEntities] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO

