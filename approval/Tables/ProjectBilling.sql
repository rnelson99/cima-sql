CREATE TABLE [approval].[ProjectBilling](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProjectId] [int] NOT NULL,
	[IsFinal] [bit] NOT NULL,
	[IsBillAmountDollar] [bit] NOT NULL,
	[IsUrgencyHigh] [bit] NOT NULL,
	[dueDate] [datetime2](7) NULL,
	[BillAmount] [decimal](18, 2) NOT NULL,
	[BillPercentage] [decimal](18, 2) NOT NULL,
	[Comments] [varchar](max) NOT NULL,
	[AddDate] [datetime2](7) NOT NULL,
	[AddID] [int] NOT NULL,
	[ChangeDate] [datetime2](7) NULL,
	[ChangeID] [int] NULL,
 CONSTRAINT [PK_ProjectBilling] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Index [IX_ProjectBilling]    Script Date: 4/18/2021 8:04:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_ProjectBilling] ON [approval].[ProjectBilling]
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_IsFinal]  DEFAULT ((0)) FOR [IsFinal]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_IsBillAmountDollar]  DEFAULT ((0)) FOR [IsBillAmountDollar]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_IsUrgencyHigh]  DEFAULT ((0)) FOR [IsUrgencyHigh]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_BillAmount]  DEFAULT ((0)) FOR [BillAmount]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_Table_1_BillPercent]  DEFAULT ((0)) FOR [BillPercentage]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_Comments]  DEFAULT ('') FOR [Comments]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_AddDate]  DEFAULT (sysdatetime()) FOR [AddDate]
GO

ALTER TABLE [approval].[ProjectBilling] ADD  CONSTRAINT [DF_ProjectBilling_AddID]  DEFAULT ((1)) FOR [AddID]
GO


