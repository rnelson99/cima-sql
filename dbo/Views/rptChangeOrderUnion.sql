CREATE VIEW rptChangeOrderUnion AS

	SELECT     *
	FROM         rptChangeOrder
	UNION
	SELECT     *
	FROM         rptChangeOrderGCOHP
	UNION
	SELECT     *
	FROM         rptChangeOrderSalesTax

GO

