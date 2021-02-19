CREATE TABLE [dbo].[tblProject] (
    [ProjectID]               INT             IDENTITY (1, 1) NOT NULL,
    [ProjectNum]              NVARCHAR (50)   NULL,
    [CIMA_Bid]                MONEY           NULL,
    [CIMA_Cost]               MONEY           NULL,
    [CIMA_Status]             NVARCHAR (15)   NULL,
    [ClientID]                INT             NOT NULL,
    [CIMASup]                 INT             NULL,
    [CIMASales]               INT             NULL,
    [CIMAProjectManager]      INT             NULL,
    [CIMAChargingSalesTax]    BIT             CONSTRAINT [DF__tblProjec__CIMAC__693CA210] DEFAULT ((0)) NOT NULL,
    [TaxingEntity]            NVARCHAR (50)   NULL,
    [Architect]               VARCHAR (255)   NULL,
    [ArchitectDate]           DATETIME        NULL,
    [ArchitectDrawingSummary] VARCHAR (MAX)   NULL,
    [ProjectName]             VARCHAR (100)   NULL,
    [ProjectStreet]           VARCHAR (55)    NULL,
    [ProjectState]            VARCHAR (3)     NULL,
    [ProjectZip]              VARCHAR (10)    NULL,
    [ProjectStartDate]        DATETIME        NULL,
    [LastModified]            DATETIME        NULL,
    [ProjectCity]             NVARCHAR (45)   NULL,
    [ProjectCounty]           VARCHAR (50)    NULL,
    [ClientProjectNumber]     VARCHAR (50)    NULL,
    [ContractPath]            VARCHAR (255)   NULL,
    [ProjectStatus]           VARCHAR (50)    CONSTRAINT [DF__tblProjec__Proje__66EA454A] DEFAULT ('Active') NULL,
    [ProjectShortName]        VARCHAR (24)    NULL,
    [OddsOfWinning]           DECIMAL (18, 2) NULL,
    [BidDueDate]              DATETIME        NULL,
    [SuperintendentRequired]  INT             CONSTRAINT [DF__tblProjec__Super__269AB60B] DEFAULT ((1)) NOT NULL,
    [StatusChanged]           BIT             CONSTRAINT [DF__tblProjec__Statu__7B7B4DDC] DEFAULT ((0)) NOT NULL,
    [SubDueDate]              DATETIME        NULL,
    [BidDate]                 DATE            NULL,
    [OwnerPM]                 VARCHAR (100)   NULL,
    [ProjectDuration]         INT             NULL,
    [LatitudeLongitude]       VARCHAR (100)   NULL,
    [Lat]                     VARCHAR (50)    NULL,
    [Lng]                     VARCHAR (50)    NULL,
    [GooglePlaceID]           VARCHAR (100)   NULL,
    [incIos]                  INT             CONSTRAINT [DF_tblProject_incIos] DEFAULT ((1)) NULL,
    [IncludeInGPSMatch]       INT             CONSTRAINT [DF__tblProjec__Inclu__4AC307E8] DEFAULT ((1)) NULL,
    [AddID]                   INT             NULL,
    [ChangeID]                INT             NULL,
    [AddDate]                 DATETIME        NULL,
    [ChangeDate]              DATETIME        NULL,
    [smallProject]            INT             NULL,
    [ClientEntityID]          INT             NULL,
    [OurCompany]              VARCHAR (20)    NULL,
    [bidArea]                 INT             NULL,
    [gdLink]                  VARCHAR (1000)  NULL,
    [approver1]               INT             NULL,
    [approver2]               INT             NULL,
    [approver3]               INT             NULL,
    [ProjectDirectory]        VARCHAR (1000)  NULL,
    [projectGUID]             VARCHAR (50)    NULL,
    [weatherLink]             VARCHAR (1000)  NULL,
    [WeatherCityID]           VARCHAR (20)    NULL,
    [LastWeatherPull]         VARCHAR (10)    NULL,
    [ownerPO]                 VARCHAR (100)   NULL,
    [projectDesc]             VARCHAR (1000)  NULL,
    [ProjectNum2]             VARCHAR (5)     NULL,
    [ProjectYear]             VARCHAR (2)     NULL,
    [FeeType]                 INT             CONSTRAINT [DF__tblProjec__FeeTy__1B1EE1BE] DEFAULT ((0)) NULL,
    [projectPriority]         INT             NULL,
    [PropertyOwner]           VARCHAR (1000)  NULL,
    [lender]                  VARCHAR (1000)  NULL,
    [PercComplete]            FLOAT (53)      CONSTRAINT [DF__tblProjec__PercC__5DE0C954] DEFAULT ((0)) NULL,
    [parentProjectID]         INT             NULL,
    [requireConditional]      INT             DEFAULT ((0)) NULL,
    CONSTRAINT [aaaaatblProject_PK] PRIMARY KEY NONCLUSTERED ([ProjectID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [NonClusteredIndex-20200205-182723]
    ON [dbo].[tblProject]([ProjectID] ASC, [parentProjectID] ASC);


GO

--
--  Add UPDATE trigger to tblProject to update LastModified
CREATE TRIGGER [dbo].[bumpLastModified]
ON [dbo].[tblProject]
AFTER  UPDATE
AS 
BEGIN
	UPDATE dbo.tblProject SET LastModified = getdate() where projectid in (select projectid from inserted)
END;

GO

