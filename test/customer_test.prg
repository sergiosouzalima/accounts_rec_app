/*
    System.......: Accounts Receivable App
    Program......: customer_test.prg
    Description..: Customer class unit tests
    Author.......: Sergio Lima
    Updated at...: Oct, 2021

	How to compile:
	hbmk2 customer_test.hbp

	How to run:
	./customer_test

*/

#include "hbclass.ch"
#include "../../hbexpect/lib/hbexpect.ch"

FUNCTION Main()

	begin hbexpect
		LOCAL oCustomer, ahRecordSet := {}
		LOCAL oUtilities := Utilities():New()
		LOCAL aGUID := {oUtilities:GetGUID(), ;
			oUtilities:GetGUID(),	;
			oUtilities:GetGUID(), 	;
			oUtilities:GetGUID() 	;
		}

		hb_vfErase("ar_app.s3db")

		describe "Customer Class"

			oCustomer := Customer():New()
			describe "When instantiate"
				describe "Customer():New( [cDataBaseName] ) --> oCustomer"
					context "and oCustomer's Class Name" expect(oCustomer) TO_BE_CLASS_NAME("Customer")
					context "and value of oCustomer" expect(oCustomer) NOT_TO_BE_NIL
					context "and value of oCustomer" expect(oCustomer) TO_BE_OBJECT_TYPE
				enddescribe
			enddescribe

			describe "oCustomer:CreateTable()"
				oCustomer:CreateTable()
				context "When getting ChangedRecords" expect (oCustomer:Error()) TO_BE_NIL
			enddescribe
			oCustomer := oCustomer:Destroy()

			describe "oCustomer:Insert()"
				oCustomer_Insert(aGUID) WITH CONTEXT
			enddescribe

			describe "oCustomer:FindAll()"
				oCustomer_FindAll(aGUID) WITH CONTEXT
			enddescribe

			describe "FindBy Methods"
				oCustomer_FindBy(aGUID) WITH CONTEXT
			enddescribe

			describe "oCustomer:Update( cId )"
				oCustomer_Update(aGUID) WITH CONTEXT
			enddescribe

			describe "oCustomer:Delete( cId )"
				oCustomer_Delete(aGUID) WITH CONTEXT
			enddescribe

			describe "oCustomer:CountAll()"
				oCustomer_CountAll() WITH CONTEXT
			enddescribe

		enddescribe

	endhbexpect

RETURN NIL

FUNCTION oCustomer_Insert(aGUID) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	describe "When invalid data to insert"
		describe "CustomerName"
			seed_costumer_fields(oCustomer, aGUID[1])
			oCustomer:CustomerName := ""
			oCustomer:Insert()
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Nome do Cliente nao informado!")
		enddescribe

		describe "BirthDate"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := ""
			endwith
			oCustomer:Insert()
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Data de Nascimento do Cliente nao informada!")
		enddescribe

		describe "GenderId"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := "22/01/1980"
				:GenderId  := 0
			endwith
			oCustomer:Insert()
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Genero do Cliente nao informado!")
		enddescribe
	enddescribe

	describe "When valid data to insert"
		seed_costumer_fields(oCustomer, aGUID[1])
		oCustomer:Insert()
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente cadastrado com sucesso!")
	enddescribe

	describe "When trying to insert existent CustomerName"
		with object oCustomer
			:CustomerName := "PRIMEIRO CLIENTE"
		endwith
		oCustomer:Insert()
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente ja cadastrado com este nome!")
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL


FUNCTION oCustomer_FindBy(aGUID) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	describe "oCustomer:FindById( cId )"
		describe "oCustomer:FeedProperties()"
			oCustomer:FindById( aGUID[1] )
			oCustomer:FeedProperties()
			check_properties( oCustomer ) WITH CONTEXT
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := Customer():New()
	describe "oCustomer:FindByCustomerName( cCustomerName )"
		describe "oCustomer:FeedProperties()"
			oCustomer:FindByCustomerName( "PRIMEIRO CLIENTE" )
			oCustomer:FeedProperties()
			check_properties( oCustomer ) WITH CONTEXT
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := Customer():New()
	describe "oCustomer:FindById( cID )"
		oCustomer:FindById( 999 )
		describe "When Id doesn't exist"
			context "and checking if it was found" expect (oCustomer:Found()) TO_BE_FALSY
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := Customer():New()
	describe "oCustomer:FindByCustomerName( cCustomerName )"
		oCustomer:FindByCustomerName( "CLIENTE NAO CADASTRADO" )
		describe "When Customer Name doesn't exist"
			context "and checking if it was found" expect (oCustomer:Found()) TO_BE_FALSY
			context "Id" expect (oCustomer:Id) TO_BE( "" )
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_FindAll(aGUID) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	seed_costumer_fields(oCustomer, aGUID[2])
	with object oCustomer
		:CustomerName := "SEGUNDO CLIENTE"
	endwith
	oCustomer:Insert()
	describe "Find all customers"
		oCustomer:FindAll()
		context "oCustomer RecordSetLength property" expect(oCustomer:RecordSetLength) TO_BE(2)
		context "oCustomer Found method" expect(oCustomer:Found) TO_BE_TRUTHY
		context "oCustomer FoundMany method" expect(oCustomer:FoundMany) TO_BE_TRUTHY

		describe "oCustomer:FeedProperties()"
			describe "oCustomer:RecordSet"
				context "customer_name in oCustomer:RecorSet first record" expect(oCustomer:RecordSet[01]["CUSTOMER_NAME"]) 	NOT_TO_BE_NIL
				context "customer_name in oCustomer:RecorSet second record" expect(oCustomer:RecordSet[02]["CUSTOMER_NAME"]) 	NOT_TO_BE_NIL
			enddescribe
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_Update(aGUID) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	describe "When invalid data to update"
		seed_costumer_fields(oCustomer)
		describe "CustomerName"
			oCustomer:CustomerName := ""
			oCustomer:Update( aGUID[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Nome do Cliente nao informado!")
		enddescribe

		describe "BirthDate"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := ""
			endwith
			oCustomer:Update( aGUID[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Data de Nascimento do Cliente nao informada!")
		enddescribe

		describe "GenderId"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := "22/01/1980"
				:GenderId  := 0
			endwith
			oCustomer:Update( aGUID[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Genero do Cliente nao informado!")
		enddescribe
	enddescribe

	describe "When valid data to update"
		seed_costumer_fields(oCustomer, aGUID)
		with object oCustomer
			:CustomerName := "PRIMEIRO CLIENTE MUDOU DE NOME"
		endwith
		oCustomer:Update( aGUID[1] )
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente alterado com sucesso!")
	enddescribe

	describe "When trying to update name to an existent CustomerName"
		describe "Insert third customer"
			seed_costumer_fields(oCustomer)
			with object oCustomer
				:ID := aGUID[3]
				:CustomerName := "TERCEIRO CLIENTE"
			endwith
			oCustomer:Insert()
		enddescribe
		with object oCustomer
			:CustomerName := "TERCEIRO CLIENTE"
		endwith
		oCustomer:Update( aGUID[1] )
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente ja cadastrado com este nome!")
	enddescribe

	describe "When updating any field, UPDATED_AT field must be updated"
		describe "Insert third customer"
			seed_costumer_fields(oCustomer)
			with object oCustomer
				:ID := aGUID[4]
				:CustomerName := "QUARTO CLIENTE"
			endwith
			oCustomer:Insert()
		enddescribe
		with object oCustomer
			:CustomerName := "QUARTO CLIENTE COM NOME ALTERADO"
		endwith
		hb_idleSleep(1)
		describe "oCustomer:Update( 4 )"
			oCustomer:Update( aGUID[4] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente alterado com sucesso!")
		enddescribe
		describe "oCustomer:FindById( 4 )" ; enddescribe
		describe "oCustomer:FeedProperties()"
			oCustomer:FindById( aGUID[4] )
			oCustomer:FeedProperties()
			context "UpdateAt field must be diferent from CreatedAt" expect(oCustomer:CreatedAt) NOT_TO_BE(oCustomer:UpdatedAt)
		enddescribe
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_Delete(aGUID) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	describe "When invalid data to delete"
		describe "oCustomer:Delete( 9999 )"
			oCustomer:Delete( "9999" )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente nao encontrado com Id: 9999")
		enddescribe
	enddescribe

	describe "When valid data to delete"
		describe "oCustomer:Delete( 1 )"
			oCustomer:Delete( aGUID[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente excluido com sucesso!")
		enddescribe
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_CountAll() FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := Customer():New()
	describe "When counting all records"
		describe "oCustomer:CountAll()"
			oCustomer:CountAll()
			context "oCustomer RecordSetLength property" expect(oCustomer:RecordSetLength) TO_BE(1)
			context "oCustomer Found method" expect(oCustomer:Found) TO_BE_TRUTHY
			context "oCustomer FoundMany method" expect(oCustomer:FoundMany) TO_BE_FALSY
		enddescribe

		describe "oCustomer:CountAll()"
			describe "oCustomer:FeedProperties()"
				oCustomer:CountAll()
				oCustomer:FeedProperties()
				context "Number Of Records" expect (oCustomer:NumberOfRecords) TO_BE( 3 )
				context "Table empty?" expect (oCustomer:TableEmpty()) TO_BE_FALSY
			enddescribe
		enddescribe
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION seed_costumer_fields( oCustomer, cGUID )
	with object oCustomer
		:ID := cGUID
		:CustomerName := "PRIMEIRO CLIENTE"
		:BirthDate := "22/01/1980"
		:GenderId := 2
		:AddressDescription := "5th AV, 505"
		:CountryCodePhoneNumber := "55"
		:AreaPhoneNumber := "11"
		:PhoneNumber := "555-55555"
		:CustomerEmail := "nome-cliente@mail.com"
		:DocumentNumber := "99876999-99"
		:ZipCodeNumber := "04058-000"
		:CityName := "Sao Paulo"
		:CityStateInitials := "SP"
	endwith
RETURN NIL

FUNCTION check_properties( oCustomer ) FROM CONTEXT
	context "and checking if it was found" expect (oCustomer:Found()) TO_BE_TRUTHY
	context "Id" expect (oCustomer:Id) NOT_TO_BE_NIL
	context "CustomerName" expect (oCustomer:CustomerName) TO_BE( "PRIMEIRO CLIENTE" )
	context "BirthDate" expect (oCustomer:BirthDate) TO_BE( "22/01/1980" )
	context "GenderId" expect (oCustomer:GenderId) TO_BE( 2 )
	context "AddressDescription" expect (oCustomer:AddressDescription) TO_BE( "5th AV, 505" )
	context "CountryCodePhoneNumber" expect (oCustomer:CountryCodePhoneNumber) TO_BE( "55" )
	context "AreaPhoneNumber" expect (oCustomer:AreaPhoneNumber) TO_BE( "11" )
	context "PhoneNumber" expect (oCustomer:PhoneNumber) TO_BE( "555-55555" )
	context "CustomerEmail" expect (oCustomer:CustomerEmail) TO_BE( "nome-cliente@mail.com" )
	context "DocumentNumber" expect (oCustomer:DocumentNumber) TO_BE( "99876999-99" )
	context "ZipCodeNumber" expect (oCustomer:ZipCodeNumber) TO_BE( "04058-000" )
	context "CityName" expect (oCustomer:CityName) TO_BE( "Sao Paulo" )
	context "CityStateInitials" expect (oCustomer:CityStateInitials) TO_BE( "SP" )
	context "CreatedAt Length" expect (Len(oCustomer:CreatedAt)) TO_BE(23)
	context "UpdatedAt Length" expect (Len(oCustomer:UpdatedAt)) TO_BE(23)
RETURN NIL