/*
	exec dbo.SalesTaxDetermination 796,26
*/
CREATE  PROCEDURE [dbo].[SalesTaxDetermination_20190401]
	@projectid int = 0,
	@addid int = 0

AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#TaxQuestions') IS NOT NULL DROP TABLE #TaxQuestions
	
	select * into #TaxQuestions from project.salesTaxQuestions where projectid = @projectid and taxQuestiongroup > 0 and taxQuestiongroup < 5 and status = 1
    
	declare @count int = (select count(*) from #TaxQuestions)

	if @count != 4
	begin
		Select @count as ct, 0 as rtncode, 'Missing Tax Questions' as rtnmessage
		return -1
	end
	
	--select * from #TaxQuestions

	alter table #taxquestions add processed int
	declare @group1Category int = 0
	declare @group2ProjectType int = 0
	declare @group3ContractType int = 0
	declare @group4Separated int = 0

	while exists (select top 1 * from #TaxQuestions where isnull(processed,0) = 0)
	begin
		declare @taxID int = (Select top 1 projecttaxid from #TaxQuestions where isnull(processed,0) = 0 order by taxQuestion)
		declare @question int = (select taxQuestion from #TaxQuestions where projectTaxID = @taxID)
		declare @answer int = (select taxAnswer from #TaxQuestions where projectTaxID = @taxID)
		--Select @taxID, @question, @answer
		if @question = 1 set @group1Category = @answer
		if @question = 2 set @group2ProjectType = @answer
		if @question = 3 set @group3ContractType = @answer
		if @question = 4 set @group4Separated = @answer

		Update #TaxQuestions set processed = 1 where projectTaxID = @taxID
	end

	--select @group1Category, @group2ProjectType, @group3ContractType, @group4Separated
	/*
		At this point I have all of my questions and answers needed  
	*/
	--	These Variables will be updated for the table in Sales Tax Determination
	--	select * from project.salesTaxDetermination

	--4
	declare @RentalEquipmentP int = 0
	declare @RentalEquipmentS int = 0

	--5
	declare @RealPropServicesP int = 0
	declare @RealPropServicesS int = 0

	--2
	declare @OutofstateMaterialP int = 0
	declare @OutofstateMaterialS int = 0

	--1
	declare @MaterialsP int = 0
	declare @MaterialsS int = 0

	--6
	declare @LaborP int = 0
	declare @LaborS int = 0

	--3
	declare @ConsumableP int = 0
	declare @ConsumableS int = 0
	
	if @group1Category != 3 --Not Goverment
	begin
		if @group2ProjectType in (1,2,3) or @group1Category = 1 -- New Construction **OR** RESIDENTIAL
		begin
			print 'New Construction Non Residential'
			if @group3ContractType = 1 --lump sum
			begin
				print 'Lump Sum New'
				set @MaterialsP = 1
				set @ConsumableP = 1
				set @RentalEquipmentP = 1
				set @OutofstateMaterialP = 1
				if @group1Category = 2 --nonResidential
				begin
					set @RealPropServicesP = 1
				end
			end
			if @group3ContractType in (2,3) -- Separted or Cost Plus
			begin
				print 'Separted or Cost Plus New'
				set @ConsumableP = 1
				set @RentalEquipmentP = 1
				set @OutofstateMaterialP = 1
				if @group1Category = 2 and @group3ContractType = 2 --nonResidential/Separated
				begin
					set @RealPropServicesP = 1
				end
				set @MaterialsS = 1 
			end -- end of Separted or Cost Plus
		end -- end of New Construction
		else--Start of Repair/Remodel
		begin
			print 'Non Residential NOT NEW'
			set @ConsumableP = 1
			
			--set @RealPropServicesP = 1 --Update 1/5/19
			set @RealPropServicesS = 1 --Update 1/5/19

			set @ConsumableS = 1
			set @RentalEquipmentS = 1
			set @RentalEquipmentP = 1
			set @OutofstateMaterialS = 1
			set @MaterialsS = 1
			set @LaborS = 1
		end
	end
	
	if @group1Category = 3 --Goverment
	begin
		if @group3ContractType = 1 --lump sum
		begin
			set @RentalEquipmentP = 1
		end
		if @group3ContractType = 2 -- Separated
		begin
			set @RentalEquipmentP = 1
		end
		if @group3ContractType = 3 -- Cost Plus
		begin
			print ''
		end
	end
	declare @dbguid varchar(100) = newid()
	
	update project.salesTaxDetermination 
	set status = 0,
		ChangeID = @addid,
		ChangeDate = getdate()
	where status = 1 and projectid = @projectid

	Insert into project.salesTaxDetermination (projectid, projecttaxquestion, purchaseTax, saleTax, status, addid, addDate, dbguid)
	Select @projectid, 1, @MaterialsP, @MaterialsS, 1, @addid, getdate(), @dbguid
	union Select @projectid, 2, @OutofstateMaterialP, @OutofstateMaterialS, 1, @addid, getdate(), @dbguid
	union Select @projectid, 3, @ConsumableP, @ConsumableS, 1, @addid, getdate(), @dbguid
	union Select @projectid, 4, @RentalEquipmentP, @RentalEquipmentS, 1, @addid, getdate(), @dbguid
	union Select @projectid, 5, @RealPropServicesP, @RealPropServicesS, 1, @addid, getdate(), @dbguid
	union Select @projectid, 6, @LaborP, @LaborS, 1, @addid, getdate(), @dbguid

END

GO

