CREATE VIEW [dbo].[viewProjectOcoGroupTotals]
  AS with cte as (
            select 'Verbally Approved' as zbillingstatus, 0 as zatRisk, 3 as sorter
            union select 'Pending', 0 as atRisk, 5 as sorter
            union select 'Approved', 0 as atRisk, 1 as sorter
            union select 'Declined', 0 as atRisk, 7 as sorter
            union select 'Verbally Approved', 1 as atRisk, 4 as atRisk
            union select 'Pending', 1 as atRisk, 6 as sorter
            union select 'Approved', 1 as atRisk, 2 as sorter
            union select 'Declined', 1 as atRisk, 8 as sorter
            )
			,chargesSalesTax as (
				select projectId
					,count(*) as salesTaxRows
				from [Proview].[project].[salesTaxDetermination]
				where saletax=1 and status =1
				group by projectid
			)
			,ocoTotals as (
            select v.projectId, z.zbillingstatus as BillingStatus, z.zatrisk as atRisk, count(*) as ct, isnull(sum(v.itemAmounts),0) as grouptotal, z.sorter,
                v.GCOHP, v.GCOHPPercent
            from cte z
				left join (
                        select sum(isnull(UnitPrice,0) * isnull(qty,0)) as itemAmounts, c.ProjectID, c.BillingStatus,
                            case when ol.OCOSCOLinkID is null then 1 else 0 end as atRisk, c.GCOHP, c.GCOHPPercent
                        from tblChangeOrderDetail d
							inner join tblChangeOrder c on c.changeorderid = d.changeorderid and c.Status = 1
							left join OCOSCOLink ol on ol.ChangeOrderDetailID = d.ChangeOrderDetailID
                        where 
							d.Qty is not null 
							and d.UnitPrice is not null 
                        group by c.ProjectID
							, c.BillingStatus
							, case when ol.OCOSCOLinkID is null then 1 else 0 end
							, c.GCOHP
							, c.GCOHPPercent
                    ) v on v.BillingStatus = z.zbillingstatus and v.atRisk = z.zatRisk
            group by v.projectId,z.zBillingStatus, z.zatrisk, z.sorter, v.GCOHP, v.GCOHPPercent)
			select o.projectId, o.BillingStatus, o.atRisk, o.ct, o.groupTotal, o.sorter, o.GCOHP, o.GCOHPPercent, c.SalesTaxRows, case when o.GCOHP > 0 and o.GCOHPPercent > 0 then
					o.grouptotal + (o.grouptotal * (o.GCOHPPercent/100.00))
				else
					o.grouptotal
				end as IncludingGcohPercent
				, case when o.GCOHP > 0 and o.GCOHPPercent > 0 then
					o.grouptotal + (o.grouptotal * (o.GCOHPPercent/100.00))
				else
					o.grouptotal
				end + (case when o.GCOHP > 0 and o.GCOHPPercent > 0 then
							o.grouptotal + (o.grouptotal * (o.GCOHPPercent/100.00))
						else
							o.grouptotal
						end * (case when isnull(c.salesTaxRows,0) > 0 then
								isnull(t.sumOfSalesTaxRate, 0)
							else
								0
							end)) as TotalAfterTax
			from ocoTotals o
				left join chargesSalesTax c on c.projectID = o.ProjectID
				left join dbo.[viewProjectSalesTax] t on t.ProjectID = c.projectID


