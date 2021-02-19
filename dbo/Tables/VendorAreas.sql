CREATE TABLE [dbo].[VendorAreas] (
    [VendorAreaID] INT            IDENTITY (1, 1) NOT NULL,
    [VendorID]     INT            NULL,
    [AreaID]       INT            NULL,
    [EntityID]     INT            NULL,
    [Limitations]  VARCHAR (1000) NULL,
    [TempHold]     DATETIME       NULL,
    [Status]       INT            NULL,
    [AddID]        INT            NULL,
    [AddDate]      DATETIME       NULL,
    [ChangeID]     INT            NULL,
    [ChangeDate]   DATETIME       NULL,
    CONSTRAINT [PK_VendorAreas] PRIMARY KEY CLUSTERED ([VendorAreaID] ASC)
);


GO

CREATE NONCLUSTERED INDEX [entityid]
    ON [dbo].[VendorAreas]([EntityID] ASC, [AreaID] ASC);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.VendorAreaTrigger
   ON  dbo.VendorAreas
   AFTER Insert, Delete, Update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	exec dbo.VendorAreaPivot

END

GO

