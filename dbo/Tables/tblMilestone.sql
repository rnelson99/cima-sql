CREATE TABLE [dbo].[tblMilestone] (
    [Id]                 INT      IDENTITY (1, 1) NOT NULL,
    [ProjectId]          INT      NOT NULL,
    [MilestoneId]        INT      NOT NULL,
    [MilestoneDate]      DATETIME NULL,
    [MilestoneCompleted] CHAR (1) DEFAULT ('N') NOT NULL,
    CONSTRAINT [PK_tblMilestone] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.tblMilestoneTrigger
   ON  dbo.tblMilestone
   AFTER Insert, Update, Delete
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Update p
	set p.ProjectStartDate = m.MilestoneDate
	from tblProject p 
	join tblMilestone m on m.ProjectId = p.ProjectID and m.MilestoneId = 2 
	where (m.MilestoneDate != p.ProjectStartDate)
	or 
	(p.ProjectStartDate is null and m.MilestoneDate is not null)

END

GO

