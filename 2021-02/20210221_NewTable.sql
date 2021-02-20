
USE [Proview]
GO

/****** Object:  Table [users].[projectfavorites]    Script Date: 2/5/2021 2:17:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [users].[projectfavorites](
	[favoriteProjectid] [int] IDENTITY(1,1) NOT NULL,
	[projectid] [int] NULL,
	[entityid] [int] NULL,
 CONSTRAINT [PK_projectfavorites] PRIMARY KEY CLUSTERED 
(
	[favoriteProjectid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
