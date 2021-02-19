CREATE VIEW dbo.viewConstDivCodes AS

	SELECT	CodeID
			, ConstructionDivCode
			, (LEFT(ConstructionDivCode,2) + ' ' + SUBSTRING(ConstructionDivCode,3,2) + ' ' + SUBSTRING(ConstructionDivCode,5,11)) AS ConstructionDivCodeFormatted	
			, AcctItem
			, ShowAvailFunding
			, AcctItemDescription
			, ConstDivSortOrder
			, IsActive, ProViewAccountID, MergeWithCodeID
			, (LEFT(ConstructionDivCode,2) + ' ' + SUBSTRING(ConstructionDivCode,3,2) + ' ' + SUBSTRING(ConstructionDivCode,5,11)
				+ '-' + ISNULL(DivisionDescription,'') + '-' + ISNULL(tblConstDivCodes.AcctItemDescription,'')) AS ConstructionAllCodes
			, (ConstructionDivCode + '-' + ISNULL(DivisionDescription,'') + '-' + ISNULL(tblConstDivCodes.AcctItemDescription,'')) AS ConstructionAllCodesOld
			, tblConstDivCodes.DivisionID
			, DivisionCode
			, DivisionDescription
			, tblConstDivCodes.DivisionGroupID
			, DivisionGroupCode
			, DivisionGroupDescription
			, DivisionGroupSortOrder
	FROM	tblConstDivCodes
			LEFT JOIN tblConstDiv ON tblConstDivCodes.DivisionID=tblConstDiv.DivisionID
			LEFT JOIN tblConstDivGroup ON tblConstDivCodes.DivisionGroupID=tblConstDivGroup.DivisionGroupID

GO

