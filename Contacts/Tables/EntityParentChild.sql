CREATE TABLE [Contacts].[EntityParentChild] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [ParentEntityID] INT           NULL,
    [ChildEntityID]  INT           NULL,
    [Type]           INT           NULL,
    [StartDate]      DATETIME      NULL,
    [EndDate]        DATETIME      NULL,
    [AddDate]        DATETIME      CONSTRAINT [DF_EntityParentChild_AddDate] DEFAULT (getdate()) NULL,
    [AddID]          INT           NULL,
    [ChangeDate]     DATETIME      NULL,
    [ChangeID]       INT           NULL,
    [JobTitle]       VARCHAR (100) NULL,
    [Status]         INT           DEFAULT ((1)) NULL,
    [MasterEntityID] INT           DEFAULT ((0)) NULL,
    [JobRole]        VARCHAR (100) NULL,
    [AddressID]      INT           NULL,
    [DivisionID]     INT           NULL,
    [distlist]       INT           NULL,
    CONSTRAINT [PK_EntityParentChild] PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20190601-081320]
    ON [Contacts].[EntityParentChild]([ParentEntityID] ASC, [ChildEntityID] ASC)
    INCLUDE([ID]);


GO


CREATE TRIGGER contacts.InsertUpdateEntityParentChildTable
   ON  contacts.EntityParentChild
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	exec dbo.MasterEntityParent

END

GO

