CREATE TABLE [dbo].[tblUserPayInfo] (
    [UserPayInfoID]        INT             IDENTITY (1, 1) NOT NULL,
    [UserSecurityID]       INT             NULL,
    [StartDate]            DATETIME        NULL,
    [CashPayRate]          MONEY           CONSTRAINT [DF__tblUserPa__CashP__00750D23] DEFAULT ((0)) NULL,
    [EmployerTaxes]        DECIMAL (10, 4) NULL,
    [HourlyBenefits]       MONEY           CONSTRAINT [DF__tblUserPa__Hourl__025D5595] DEFAULT ((0)) NULL,
    [BiWeeklyBenefits]     MONEY           CONSTRAINT [DF__tblUserPa__BiWee__035179CE] DEFAULT ((0)) NULL,
    [PercentBasedBenefits] DECIMAL (10, 4) CONSTRAINT [DF__tblUserPa__Perce__04459E07] DEFAULT ((0)) NULL,
    [PTO]                  DECIMAL (10, 2) CONSTRAINT [DF__tblUserPayI__PTO__0539C240] DEFAULT ((0)) NULL,
    [Utilization]          DECIMAL (10, 4) CONSTRAINT [DF__tblUserPa__Utili__062DE679] DEFAULT ((0)) NULL,
    [EmployeeTypeID]       INT             NULL,
    [Bonus]                DECIMAL (10, 4) CONSTRAINT [DF__tblUserPa__Bonus__07220AB2] DEFAULT ((0)) NULL,
    [SmallJobRate]         MONEY           CONSTRAINT [DF__tblUserPa__Small__08162EEB] DEFAULT ((0)) NULL,
    [EntityID]             INT             NULL,
    [AddID]                INT             NULL,
    [AddDate]              DATETIME        NULL,
    [ChangeID]             INT             NULL,
    [ChangeDate]           DATETIME        NULL,
    [EffectiveDate]        DATETIME        NULL,
    [EffectiveEndDate]     DATETIME        NULL,
    [isDelete]             INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblUserPayInfo] PRIMARY KEY CLUSTERED ([UserPayInfoID] ASC)
);


GO

