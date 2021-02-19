CREATE TABLE [dbo].[AreaList] (
    [AreaID]          INT          IDENTITY (1, 1) NOT NULL,
    [Area]            VARCHAR (50) NULL,
    [stateabbr]       VARCHAR (2)  NULL,
    [AirportCode]     VARCHAR (10) NULL,
    [StateFull]       VARCHAR (25) NULL,
    [PreferredNumber] VARCHAR (25) NULL,
    [AddID]           INT          NULL,
    [AddDate]         DATETIME     NULL,
    [ChangeID]        INT          NULL,
    [ChangeDate]      DATETIME     NULL,
    CONSTRAINT [PK_AreaList] PRIMARY KEY CLUSTERED ([AreaID] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.AreaTrigger
   ON  dbo.AreaList
   AFTER Insert, Delete, Update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec dbo.VendorAreaPivot

END

GO

