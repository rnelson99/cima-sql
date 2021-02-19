CREATE TABLE [Contacts].[Attributes] (
    [AttributeID]    INT            IDENTITY (1, 1) NOT NULL,
    [EntityID]       INT            NULL,
    [attribute]      VARCHAR (1000) NULL,
    [status]         INT            NULL,
    [attributetype]  VARCHAR (50)   NULL,
    [AddDate]        DATETIME       NULL,
    [ChangeDate]     DATETIME       NULL,
    [AddID]          INT            NULL,
    [ChangeID]       INT            NULL,
    [ReviewDate]     DATETIME       NULL,
    [Reason]         VARCHAR (1000) NULL,
    [UserAttribute]  INT            DEFAULT ((0)) NULL,
    [ExpirationDate] DATETIME       NULL,
    CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED ([AttributeID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190601-081611]
    ON [Contacts].[Attributes]([EntityID] ASC, [attribute] ASC)
    INCLUDE([AttributeID], [status]);


GO

