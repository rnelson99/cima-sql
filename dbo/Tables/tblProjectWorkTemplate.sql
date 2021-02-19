CREATE TABLE [dbo].[tblProjectWorkTemplate] (
    [ProjectWorkTemplateID]        INT             IDENTITY (1, 1) NOT NULL,
    [TemplateName]                 VARCHAR (255)   NULL,
    [TemplateItemNumber]           INT             NULL,
    [WorkItemName]                 VARCHAR (255)   NULL,
    [VendorID]                     INT             NULL,
    [WorkDays]                     DECIMAL (16, 2) NOT NULL,
    [TypicalLeadTimeDays]          INT             NOT NULL,
    [AvailWorkDays]                INT             NOT NULL,
    [LagWorkDays]                  INT             NOT NULL,
    [PrecedingTemplateItemNumber1] INT             NULL,
    [PrecedingTemplateItemNumber2] INT             NULL,
    [PrecedingTemplateItemNumber3] INT             NULL,
    [InteriorAccess]               NVARCHAR (3)    NULL,
    [AffectedProject]              NVARCHAR (3)    NULL,
    [CIMASupHrs]                   INT             NULL,
    [CIMALabor1]                   NVARCHAR (15)   NULL,
    [CIMALabor1Hrs]                INT             NULL,
    [CIMALabor2]                   NVARCHAR (15)   NULL,
    [CIMALabor2Hrs]                INT             NULL,
    [CIMASalesHrs]                 INT             NULL,
    [ConstructionDivCode]          NVARCHAR (15)   NULL,
    [TemplateAddedTimestamp]       DATETIME        NOT NULL,
    [ShowCustomer]                 BIT             NOT NULL,
    [FluffWorkDays]                INT             NULL,
    CONSTRAINT [PKtblProjectWorkTemplate] PRIMARY KEY CLUSTERED ([ProjectWorkTemplateID] ASC)
);


GO

