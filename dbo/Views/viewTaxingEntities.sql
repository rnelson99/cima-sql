CREATE VIEW dbo.viewTaxingEntities AS

SELECT DISTINCT ProjectID, LEFT(ISNULL(TaxingEntities,''), LEN(ISNULL(TaxingEntities,''))-1) AS TaxingEntities
    FROM tblProjectSalesTax p1
   CROSS APPLY ( SELECT JurisdictionName + ', '
                     FROM tblProjectSalesTax p2
          WHERE (p2.ProjectID = p1.ProjectID)
				AND (p2.LocalCode <> '1')
				AND (NOT p2.LocalCode IS NULL)
                     ORDER BY JurisdictionName
                     FOR XML PATH('') )  D ( TaxingEntities )
	WHERE NOT TaxingEntities IS NULL

GO

