-- View for sfrmProjectEdit_Milestones
CREATE VIEW sfrmProjectEdit_Milestones
AS
SELECT a.Id,a.ProjectId,a.MilestoneId, a.MilestoneDate,a.MilestoneCompleted,
b.Milestone
FROM dbo.tblMilestone a LEFT JOIN dbo.tlkpMilestones b ON a.MilestoneId=b.Id

GO

