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

#define DB_NAME "test.s3db"

FUNCTION Main()

	begin hbexpect
		LOCAL oCustomer, oGender := NIL, aIDs := {}

		hb_vfErase(DB_NAME)

		oGender := GenderModel():New(DB_NAME)
		oGender:CreateTable()
		oGender:InsertInitialGender()
		oGender := oGender:Destroy()

		describe "Customer Class"

			oCustomer := CustomerModel():New(DB_NAME)
			describe "When instantiate"
				describe "CustomerModel():New( [cDataBaseName] ) --> oCustomer"
					context "and oCustomer's Class Name" expect(oCustomer) TO_BE_CLASS_NAME("CustomerModel")
					context "and value of oCustomer" expect(oCustomer) NOT_TO_BE_NIL
					context "and value of oCustomer" expect(oCustomer) TO_BE_OBJECT_TYPE
				enddescribe
			enddescribe

			describe "oCustomer:CreateTable()"
				oCustomer:CreateTable()
				context "When getting ChangedRecords" expect (oCustomer:Error()) TO_BE_NIL
			enddescribe
			oCustomer := oCustomer:Destroy()

			describe "Find_All_When_Empty"
				Find_All_When_Empty() WITH CONTEXT
			enddescribe

			describe "oCustomer:Insert()"
				oCustomer_Insert() WITH CONTEXT
			enddescribe

			describe "oCustomer:FindAll()"
				aIDs := oCustomer_FindAll() WITH CONTEXT
			enddescribe

			describe "FindBy Methods"
				oCustomer_FindBy() WITH CONTEXT
			enddescribe

			describe "oCustomer:Update( cId )"
				oCustomer_Update( aIDs ) WITH CONTEXT
			enddescribe

			describe "oCustomer:Delete( cId )"
				oCustomer_Delete( aIDs ) WITH CONTEXT
			enddescribe

			describe "oCustomer:CountAll()"
				oCustomer_CountAll() WITH CONTEXT
			enddescribe

		enddescribe

	endhbexpect

RETURN NIL

FUNCTION Find_All_When_Empty() FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When no costumers in Table"
		describe "Find all customers"
			describe "oCustomer:FindAll()"
			enddescribe
			oCustomer:FindAll()
			context "oCustomer RecordSetLength property" expect(oCustomer:RecordSetLength) TO_BE_ZERO
			context "oCustomer Found method" expect(oCustomer:Found) TO_BE_FALSY
			context "oCustomer FoundMany method" expect(oCustomer:FoundMany) TO_BE_FALSY
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_Insert() FROM CONTEXT
	LOCAL oCustomer := NIL, cUID := ""

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When invalid data to insert"
		describe "CustomerName"
			seed_costumer_fields(oCustomer)
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
				:GenderId  := ""
			endwith
			oCustomer:Insert()
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Genero do Cliente nao informado!")
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	describe "When valid data to insert"
		oCustomer := CustomerModel():New(DB_NAME)
		seed_costumer_fields(oCustomer)
		cUID := oCustomer:Insert()
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
		context "When getting new GUID LENGTH" expect (Len(cUID)) TO_BE(36)
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente cadastrado com sucesso!")
		oCustomer := oCustomer:Destroy()
	enddescribe

	describe "When trying to insert existent CustomerName"
		oCustomer := CustomerModel():New(DB_NAME)
		seed_costumer_fields(oCustomer)
		oCustomer:CustomerName := "PRIMEIRO CLIENTE"
		oCustomer:Insert()
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente ja cadastrado com este nome!")
		oCustomer := oCustomer:Destroy()
	enddescribe

RETURN NIL


FUNCTION oCustomer_FindBy() FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := CustomerModel():New(DB_NAME)
	describe "oCustomer:FindFirst()"
		oCustomer:FindFirst()
		context "and checking if it was found" expect (oCustomer:Found()) TO_BE_TRUTHY
		context "Id" expect (oCustomer:Id) NOT_TO_BE_NIL
		context "CustomerName" expect (oCustomer:CustomerName) TO_BE( "PRIMEIRO CLIENTE" )
		context "BirthDate" expect (oCustomer:BirthDate) TO_BE( "22/01/1980" )
		context "GenderId" expect (oCustomer:GenderId) NOT_TO_BE_NIL
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
		context "and checking if it was found" expect (oCustomer:Found()) TO_BE_TRUTHY
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := CustomerModel():New(DB_NAME)
	describe "oCustomer:FindByCustomerName( 'PRIMEIRO CLIENTE' ):CustomerName --> 'PRIMEIRO CLIENTE'"
		context "FindByCustomerName" ;
			expect(oCustomer:FindByCustomerName( 'PRIMEIRO CLIENTE' ):CustomerName) ;
			TO_BE("PRIMEIRO CLIENTE")
		context "and checking if it was found" expect (oCustomer:Found()) TO_BE_TRUTHY
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := CustomerModel():New(DB_NAME)
	describe "oCustomer:FindById( cID )"
		oCustomer:FindById( "999" )
		describe "When Id doesn't exist"
			context "and checking if it was found" expect (oCustomer:Found()) TO_BE_FALSY
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := CustomerModel():New(DB_NAME)
	describe "oCustomer:FindByCustomerName( cCustomerName )"
		oCustomer:FindByCustomerName( "CLIENTE NAO CADASTRADO" )
		describe "When Customer Name doesn't exist"
			context "and checking if it was found" expect (oCustomer:Found()) TO_BE_FALSY
			context "Id" expect (oCustomer:Id) TO_BE( "" )
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_FindAll() FROM CONTEXT
	LOCAL oCustomer := NIL, aIDs := {}

	oCustomer := CustomerModel():New(DB_NAME)
	seed_costumer_fields(oCustomer)
	with object oCustomer
		:CustomerName := "SEGUNDO CLIENTE"
	endwith
	oCustomer:Insert()
	describe "Find all customers"
		oCustomer:FindAll()
		context "oCustomer RecordSetLength property" expect(oCustomer:RecordSetLength) TO_BE(2)
		context "oCustomer Found method" expect(oCustomer:Found) TO_BE_TRUTHY
		context "oCustomer FoundMany method" expect(oCustomer:FoundMany) TO_BE_TRUTHY
		describe "oCustomer:RecordSet"
			context "customer_name in oCustomer:RecorSet first record" expect(oCustomer:RecordSet[01]["CUSTOMER_NAME"])		TO_BE("PRIMEIRO CLIENTE")
			context "customer_name in oCustomer:RecorSet second record" expect(oCustomer:RecordSet[02]["CUSTOMER_NAME"]) 	TO_BE("SEGUNDO CLIENTE")
		enddescribe
	enddescribe
	aIDs := { oCustomer:RecordSet[01]["ID"], oCustomer:RecordSet[02]["ID"] }
	oCustomer := oCustomer:Destroy()
RETURN aIDs

FUNCTION oCustomer_Update(aIDs) FROM CONTEXT
	LOCAL oCustomer := NIL, cID4 := ""

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When invalid data to update"
		seed_costumer_fields(oCustomer)
		describe "CustomerName"
			oCustomer:CustomerName := ""
			oCustomer:Update( aIDs[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Nome do Cliente nao informado!")
		enddescribe

		describe "BirthDate"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := ""
			endwith
			oCustomer:Update( aIDs[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Data de Nascimento do Cliente nao informada!")
		enddescribe

		describe "GenderId"
			with object oCustomer
				:CustomerName := "PRIMEIRO CLIENTE"
				:BirthDate := "22/01/1980"
				:GenderId  := ""
			endwith
			oCustomer:Update( aIDs[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Genero do Cliente nao informado!")
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When valid data to update"
		seed_costumer_fields(oCustomer)
		with object oCustomer
			:CustomerName := "PRIMEIRO CLIENTE MUDOU DE NOME"
		endwith
		oCustomer:Update( aIDs[1] )
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente alterado com sucesso!")
	enddescribe
	oCustomer := oCustomer:Destroy()


	describe "When trying to update name to an existent CustomerName"
		describe "Insert 3# customer"
			oCustomer := CustomerModel():New(DB_NAME)
			seed_costumer_fields(oCustomer)
			oCustomer:CustomerName := "TERCEIRO CLIENTE"
			oCustomer:Insert()
			oCustomer := oCustomer:Destroy()
		enddescribe
		oCustomer := CustomerModel():New(DB_NAME)
		seed_costumer_fields(oCustomer)
		oCustomer:CustomerName := "TERCEIRO CLIENTE"
		oCustomer:Update( aIDs[1] )
		context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
		context "When getting Valid status" expect (oCustomer:Valid) TO_BE_FALSY
		context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente ja cadastrado com este nome!")
		oCustomer := oCustomer:Destroy()
	enddescribe

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When updating any field, UPDATED_AT field must be updated"
		describe "Insert 4# customer"
			seed_costumer_fields(oCustomer)
			with object oCustomer
				:CustomerName := "QUARTO CLIENTE"
			endwith
			oCustomer:Insert()
			oCustomer:FindByCustomerName( "QUARTO CLIENTE" )
			cID4 := oCustomer:Id
		enddescribe
		hb_idleSleep(1)
		describe "oCustomer:Update( cID4 )"
			with object oCustomer
				:CustomerName := "QUARTO CLIENTE COM NOME ALTERADO"
			endwith
			oCustomer:Update( cID4 )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente alterado com sucesso!")
		enddescribe
		describe "oCustomer:FindById( cID4 )" ; enddescribe
		describe "oCustomer:FeedProperties()"
			oCustomer:FindById( cID4 )
			context "UpdateAt field must be diferent from CreatedAt" expect(oCustomer:CreatedAt) NOT_TO_BE(oCustomer:UpdatedAt)
		enddescribe
	enddescribe
	oCustomer := oCustomer:Destroy()

RETURN NIL

FUNCTION oCustomer_Delete(aIDs) FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := CustomerModel():New(DB_NAME)
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
			oCustomer:Delete( aIDs[1] )
			context "When getting Error" expect (oCustomer:Error) TO_BE_NIL
			context "When getting Valid status" expect (oCustomer:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oCustomer:Message) TO_BE("Cliente excluido com sucesso!")
		enddescribe
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION oCustomer_CountAll() FROM CONTEXT
	LOCAL oCustomer := NIL

	oCustomer := CustomerModel():New(DB_NAME)
	describe "When counting all records"
		describe "oCustomer := CustomerModel():New(DB_NAME)"
		enddescribe
		describe "oCustomer:CountAll() --> nNumberOfRecords"
			oCustomer:CountAll()
			context "oCustomer RecordSetLength property" expect(oCustomer:RecordSetLength) TO_BE(1)
			context "oCustomer Found method" expect(oCustomer:Found) TO_BE_TRUTHY
			context "oCustomer FoundMany method" expect(oCustomer:FoundMany) TO_BE_FALSY
		enddescribe

		describe "oCustomer:CountAll()"
			describe "oCustomer:FeedProperties()"
				oCustomer:CountAll()
				context "Table empty?" expect (oCustomer:TableEmpty()) TO_BE_FALSY
				context "Number Of Records: oCustomer:CountAll()" expect (oCustomer:CountAll()) TO_BE( 3 )
			enddescribe
		enddescribe
	enddescribe

	oCustomer := oCustomer:Destroy()
RETURN NIL

FUNCTION seed_costumer_fields( oCustomer )
	LOCAL oGender := GenderModel():New(DB_NAME)

	oGender:FindFirst()
	oGender:FeedProperties()

	with object oCustomer
		:CustomerName := "PRIMEIRO CLIENTE"
		:BirthDate := "22/01/1980"
		:GenderId := oGender:Id
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
	context "GenderId" expect (oCustomer:GenderId) NOT_TO_BE_NIL
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