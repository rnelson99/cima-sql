CREATE TABLE [Contacts].[BusinessEntity](
	[BusEntityID] [int] IDENTITY(1,1) NOT NULL,
	[BusEntityLong] [varchar](100) NULL,
	[BusEntityDBA] [varchar](50) NULL,
	[BusEntityNickname] [varchar](25) NULL,
	[BusEntityShort] [varchar](5) NULL,
	[BusEntityParent] [int] NULL,
	[BusEntityGroup] [int] NULL,
	[EntityPurpose] [varchar](max) NULL,
	[USTaxID] [int] NULL,
	[FiscalYearStart] [varchar](10) NULL,
	[BusEntityType] [int] NULL,
	[Address1] [varchar](100) NULL,
	[Address2] [varchar](100) NULL,
	[AddressCity] [varchar](50) NULL,
	[AddressState] [varchar](25) NULL,
	[AddressZip] [varchar](10) NULL,
	[BusinessEntityLogo1] [int] NULL,
	[BusinessEntityLogo2] [int] NULL,
	[BusEntityPermissionParent] [int] NULL,
	[CompanyEntityId] [int] NOT NULL,
 CONSTRAINT [PK_BusinessEntity] PRIMARY KEY CLUSTERED 
(
	[BusEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Contacts].[BusinessEntity] ADD  CONSTRAINT [DF_BusinessEntity_CompanyEntityId]  DEFAULT ((0)) FOR [CompanyEntityId]
GO
