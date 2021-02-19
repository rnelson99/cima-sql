CREATE TABLE [dbo].[tblTwilloLog] (
    [TwilloLogID]      INT           IDENTITY (1, 1) NOT NULL,
    [Sid]              VARCHAR (100) NULL,
    [ToNumber]         VARCHAR (21)  NULL,
    [FromNumber]       VARCHAR (21)  NULL,
    [MessageServiceID] VARCHAR (50)  NULL,
    [Direction]        VARCHAR (50)  NULL,
    [Body]             VARCHAR (MAX) NULL,
    [Status]           VARCHAR (50)  NULL,
    [AddID]            INT           NULL,
    [AddDate]          DATETIME      NULL,
    [SentToProject]    BIT           CONSTRAINT [DF__tblTwillo__SentT__6FD49106] DEFAULT ((0)) NULL,
    [ProjectID]        INT           CONSTRAINT [DF__tblTwillo__Proje__70C8B53F] DEFAULT ((0)) NULL,
    [VendorID]         INT           CONSTRAINT [DF__tblTwillo__Vendo__71BCD978] DEFAULT ((0)) NULL,
    [CIMAEntityID]     INT           NULL,
    [EmployeeEntityID] INT           NULL,
    [ToEntityID]       INT           NULL,
    [FromEntityID]     INT           NULL,
    [isRead]           INT           DEFAULT ((0)) NULL,
    [AssignedTo]       INT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblTwilloLog] PRIMARY KEY CLUSTERED ([TwilloLogID] ASC)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER dbo.tblTwilloLogTrigger
   ON  dbo.tblTwilloLog
   AFTER Insert, Update
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	exec [dbo].[TwilioLogEntitySet]

END

GO

