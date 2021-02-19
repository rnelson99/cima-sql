CREATE TABLE [dbo].[tblConstDivCodes] (
    [CodeID]              INT           IDENTITY (1, 1) NOT NULL,
    [ConstructionDivCode] NVARCHAR (15) NOT NULL,
    [AcctItem]            VARCHAR (100) NULL,
    [ShowAvailFunding]    VARCHAR (1)   DEFAULT ('Y') NOT NULL,
    [AcctItemDescription] VARCHAR (100) NULL,
    [DivisionID]          INT           NULL,
    [DivisionGroupID]     INT           NULL,
    [ConstDivSortOrder]   INT           NULL,
    [IsActive]            VARCHAR (1)   DEFAULT ('Y') NOT NULL,
    [ProViewAccountID]    INT           NULL,
    [MergeWithCodeID]     INT           NULL,
    [biddingshow]         BIT           DEFAULT ((0)) NULL,
    [FavStatus]           BIT           DEFAULT ((0)) NULL,
    [OverheadProject]     TINYINT       DEFAULT ((0)) NULL,
    [noVendor]            INT           DEFAULT ((0)) NULL,
    [incomeLine]          INT           DEFAULT ((0)) NULL,
    [allowBudgetRemove]   INT           NULL,
    [CTCAvailableZero]    INT           DEFAULT ((0)) NULL,
    CONSTRAINT [PK_tblConstDivCodes] PRIMARY KEY CLUSTERED ([CodeID] ASC),
    CONSTRAINT [uc_ConstructionDivCode] UNIQUE NONCLUSTERED ([ConstructionDivCode] ASC)
);


GO


CREATE TRIGGER dbo.tblConstDivCodesInsertUpdate
    ON dbo.tblConstDivCodes
    AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON
	
	DECLARE @CodeID INT
	DECLARE @DivisionID AS INT
	DECLARE @DivisionCode AS VARCHAR(2)
	
	SELECT @CodeID=CodeID, @DivisionCode=LEFT(ConstructionDivCode,2)
	FROM INSERTED
	
	SELECT @DivisionID=DivisionID
	FROM dbo.tblConstDiv
	WHERE DivisionCode=@DivisionCode

	UPDATE dbo.tblConstDivCodes
	SET DivisionID=@DivisionID
	WHERE CodeID=@CodeID
		
	--UPDATE cdc
	--SET cdc.DivisionID=cd.DivisionID
	--FROM dbo.tblConstDiv cd
	--	INNER JOIN dbo.tblConstDivCodes cdc ON cd.DivisionCode=LEFT(cdc.ConstructionDivCode,2)
	--WHERE cdc.CodeID=@CodeID
END

GO

