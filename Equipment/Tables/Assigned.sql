CREATE TABLE [Equipment].[Assigned] (
    [EquipmentAssignedID] INT           IDENTITY (1, 1) NOT NULL,
    [EquipmentID]         INT           NOT NULL,
    [Assignee]            VARCHAR (50)  NULL,
    [Location]            VARCHAR (100) NULL,
    [DateFrom]            DATETIME      NULL,
    [DateTo]              DATETIME      NULL,
    [AddID]               INT           NULL,
    [AddDate]             DATETIME      DEFAULT (getdate()) NULL,
    [ChangeID]            INT           NULL,
    [ChangeDate]          DATETIME      NULL,
    [AssignedID]          INT           NULL,
    [AssignStatus]        INT           DEFAULT ((1)) NULL,
    CONSTRAINT [PK_EquipmentAssigned] PRIMARY KEY CLUSTERED ([EquipmentAssignedID] ASC)
);


GO

