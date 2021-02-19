CREATE TABLE [users].[projectfavorites](
	[favoriteProjectid] [int] IDENTITY(1,1) NOT NULL,
	[projectid] [int] NULL,
	[entityid] [int] NULL,
 CONSTRAINT [PK_projectfavorites] PRIMARY KEY CLUSTERED 
(
	[favoriteProjectid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]