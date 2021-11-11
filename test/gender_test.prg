/*
    System.......: Accounts Receivable App
    Program......: gender_test.prg
    Description..: Gender class unit tests
    Author.......: Sergio Lima
    Updated at...: Oct, 2021

	How to compile:
	hbmk2 gender_test.hbp

	How to run:
	./gender_test

*/

#include "hbclass.ch"
#include "../../hbexpect/lib/hbexpect.ch"

#define DB_NAME "test.s3db"

FUNCTION Main()

	begin hbexpect
		LOCAL oGender, aIDs := {}

		hb_vfErase(DB_NAME)

		describe "Gender Class"

			oGender := GenderModel():New(DB_NAME)
			describe "When instantiate"
				describe "GenderModel():New( [cDataBaseName] ) --> oGender"
					context "and oGender's Class Name" expect(oGender) TO_BE_CLASS_NAME("GenderModel")
					context "and value of oGender" expect(oGender) NOT_TO_BE_NIL
					context "and value of oGender" expect(oGender) TO_BE_OBJECT_TYPE
				enddescribe
			enddescribe

			describe "oGender:CreateTable()"
				oGender:CreateTable()
				context "When getting ChangedRecords" expect (oGender:Error()) TO_BE_NIL
			enddescribe
			oGender := oGender:Destroy()

			describe "oGender:Insert()"
				oGender_Insert() WITH CONTEXT
			enddescribe

			describe "oGender:FindAll()"
				aIDs := oGender_FindAll() WITH CONTEXT
			enddescribe

			describe "FindBy Methods"
				oGender_FindBy() WITH CONTEXT
			enddescribe

			describe "oGender:Update( cId )"
				oGender_Update( aIDs ) WITH CONTEXT
			enddescribe

			describe "oGender:Delete( cId )"
				oGender_Delete( aIDs ) WITH CONTEXT
			enddescribe

			describe "oGender:CountAll()"
				oGender_CountAll() WITH CONTEXT
			enddescribe

		enddescribe

	endhbexpect

RETURN NIL

FUNCTION oGender_Insert() FROM CONTEXT
	LOCAL oGender := NIL

	oGender := GenderModel():New(DB_NAME)
	describe "When invalid data to insert"
		describe "GenderDescription"
			seed_gender_fields(oGender)
			oGender:GenderDescription := ""
			oGender:Insert()
			context "When getting Error" expect (oGender:Error) TO_BE_NIL
			context "When getting Valid status" expect (oGender:Valid) TO_BE_FALSY
			context "When getting Message" expect (oGender:Message) TO_BE("Descricao do Genero nao informada!")
		enddescribe
	enddescribe

	describe "When valid data to insert"
		seed_gender_fields(oGender)
		oGender:Insert()
		context "When getting Error" expect (oGender:Error) TO_BE_NIL
		context "When getting Valid status" expect (oGender:Valid) TO_BE_TRUTHY
		context "When getting Message" expect (oGender:Message) TO_BE("Genero cadastrado com sucesso!")
	enddescribe

	describe "When trying to insert existent GenderDescription"
		with object oGender
			:GenderDescription := "MASCULINO"
		endwith
		oGender:Insert()
		context "When getting Error" expect (oGender:Error) TO_BE_NIL
		context "When getting Valid status" expect (oGender:Valid) TO_BE_FALSY
		context "When getting Message" expect (oGender:Message) TO_BE("Genero ja cadastrado com esta descricao!")
	enddescribe

	oGender := oGender:Destroy()
RETURN NIL


FUNCTION oGender_FindBy() FROM CONTEXT
	LOCAL oGender := NIL, cGUID := ""

	oGender := GenderModel():New(DB_NAME)
	describe "oGender:FindFirst()"
		describe "oGender:FeedProperties()"
			oGender:FindFirst()
			oGender:FeedProperties()
			cGUID := oGender:Id
			check_properties( oGender ) WITH CONTEXT
		enddescribe
	enddescribe
	oGender := oGender:Destroy()

	oGender := GenderModel():New(DB_NAME)
	describe "oGender:FindById( cGUID )"
		describe "oGender:FeedProperties()"
			oGender:FindById( cGUID )
			oGender:FeedProperties()
			check_properties( oGender ) WITH CONTEXT
		enddescribe
	enddescribe
	oGender := oGender:Destroy()

	oGender := GenderModel():New(DB_NAME)
	describe "oGender:FindByGenderDescription( cGenderDescription )"
		describe "oGender:FeedProperties()"
			oGender:FindByGenderDescription( "MASCULINO" )
			oGender:FeedProperties()
			check_properties( oGender ) WITH CONTEXT
		enddescribe
	enddescribe
	oGender := oGender:Destroy()

	oGender := GenderModel():New(DB_NAME)
	describe "oGender:FindById( cID )"
		oGender:FindById( 999 )
		describe "When Id doesn't exist"
			context "and checking if it was found" expect (oGender:Found()) TO_BE_FALSY
		enddescribe
	enddescribe
	oGender := oGender:Destroy()

	oGender := GenderModel():New(DB_NAME)
	describe "oGender:FindByGenderDescription( cGenderDescription )"
		oGender:FindByGenderDescription( "Genero nao cadastrado" )
		describe "When Gender Name doesn't exist"
			context "and checking if it was found" expect (oGender:Found()) TO_BE_FALSY
			context "Id" expect (oGender:Id) TO_BE( "" )
		enddescribe
	enddescribe
	oGender := oGender:Destroy()
RETURN NIL

FUNCTION oGender_FindAll() FROM CONTEXT
	LOCAL oGender := NIL, aIDs := {}

	oGender := GenderModel():New(DB_NAME)
	seed_gender_fields(oGender)
	with object oGender
		:GenderDescription := "FEMININO"
	endwith
	oGender:Insert()
	describe "Find all Genders"
		oGender:FindAll()
		context "oGender RecordSetLength property" expect(oGender:RecordSetLength) TO_BE(2)
		context "oGender Found method" expect(oGender:Found) TO_BE_TRUTHY
		context "oGender FoundMany method" expect(oGender:FoundMany) TO_BE_TRUTHY

		describe "oGender:FeedProperties()"
			describe "oGender:RecordSet"
				context "GENDER_DESCRIPTION in oGender:RecorSet first record" expect(oGender:RecordSet[01]["GENDER_DESCRIPTION"]) 	NOT_TO_BE_NIL
				context "GENDER_DESCRIPTION in oGender:RecorSet second record" expect(oGender:RecordSet[02]["GENDER_DESCRIPTION"]) 	NOT_TO_BE_NIL
			enddescribe
		enddescribe
	enddescribe
	aIDs := { oGender:RecordSet[01]["ID"], oGender:RecordSet[02]["ID"] }
	oGender := oGender:Destroy()
RETURN aIDs

FUNCTION oGender_Update(aIDs) FROM CONTEXT
	LOCAL oGender := NIL, cID4 := ""

	oGender := GenderModel():New(DB_NAME)
	describe "When invalid data to update"
		seed_gender_fields(oGender)
		describe "GenderDescription"
			oGender:GenderDescription := ""
			oGender:Update( aIDs[1] )
			context "When getting Error" expect (oGender:Error) TO_BE_NIL
			context "When getting Valid status" expect (oGender:Valid) TO_BE_FALSY
			context "When getting Message" expect (oGender:Message) TO_BE("Descricao do Genero nao informada!")
		enddescribe
	enddescribe

	describe "When valid data to update"
		seed_gender_fields(oGender)
		with object oGender
			:GenderDescription := "MASCULINO MUDOU DE NOME"
		endwith
		oGender:Update( aIDs[1] )
		context "When getting Error" expect (oGender:Error) TO_BE_NIL
		context "When getting Valid status" expect (oGender:Valid) TO_BE_TRUTHY
		context "When getting Message" expect (oGender:Message) TO_BE("Genero alterado com sucesso!")
	enddescribe

	describe "When trying to update name to an existent GenderDescription"
		describe "Insert third Gender"
			seed_gender_fields(oGender)
			with object oGender
				:GenderDescription := "INDEFINIDO"
			endwith
			oGender:Insert()
		enddescribe
		with object oGender
			:GenderDescription := "INDEFINIDO"
		endwith
		oGender:Update( aIDs[1] )
		context "When getting Error" expect (oGender:Error) TO_BE_NIL
		context "When getting Valid status" expect (oGender:Valid) TO_BE_FALSY
		context "When getting Message" expect (oGender:Message) TO_BE("Genero ja cadastrado com esta descricao!")
	enddescribe

	describe "When updating any field, UPDATED_AT field must be updated"
		describe "Insert third Gender"
			seed_gender_fields(oGender)
			with object oGender
				:GenderDescription := "NAO INFORMADO"
			endwith
			oGender:Insert()
			oGender:FindByGenderDescription( "NAO INFORMADO" )
			oGender:FeedProperties()
			cID4 := oGender:Id
		enddescribe
		hb_idleSleep(1)
		describe "oGender:Update( cID4 )"
			with object oGender
				:GenderDescription := "NAO INFORMADO COM NOME ALTERADO"
			endwith
			oGender:Update( cID4 )
			context "When getting Error" expect (oGender:Error) TO_BE_NIL
			context "When getting Valid status" expect (oGender:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oGender:Message) TO_BE("Genero alterado com sucesso!")
		enddescribe
		describe "oGender:FindById( cID4 )" ; enddescribe
		describe "oGender:FeedProperties()"
			oGender:FindById( cID4 )
			oGender:FeedProperties()
			context "UpdateAt field must be diferent from CreatedAt" expect(oGender:CreatedAt) NOT_TO_BE(oGender:UpdatedAt)
		enddescribe
	enddescribe

	oGender := oGender:Destroy()
RETURN NIL

FUNCTION oGender_Delete(aIDs) FROM CONTEXT
	LOCAL oGender := NIL

	oGender := GenderModel():New(DB_NAME)
	describe "When invalid data to delete"
		describe "oGender:Delete( 9999 )"
			oGender:Delete( "9999" )
			context "When getting Error" expect (oGender:Error) TO_BE_NIL
			context "When getting Valid status" expect (oGender:Valid) TO_BE_FALSY
			context "When getting Message" expect (oGender:Message) TO_BE("Genero nao encontrado com Id: 9999")
		enddescribe
	enddescribe

	describe "When valid data to delete"
		describe "oGender:Delete( 1 )"
			oGender:Delete( aIDs[1] )
			context "When getting Error" expect (oGender:Error) TO_BE_NIL
			context "When getting Valid status" expect (oGender:Valid) TO_BE_TRUTHY
			context "When getting Message" expect (oGender:Message) TO_BE("Genero excluido com sucesso!")
		enddescribe
	enddescribe

	oGender := oGender:Destroy()
RETURN NIL

FUNCTION oGender_CountAll() FROM CONTEXT
	LOCAL oGender := NIL

	oGender := GenderModel():New(DB_NAME)
	describe "When counting all records"
		describe "oGender := GenderModel():New(DB_NAME)"
		enddescribe
		describe "oGender:CountAll() --> nNumberOfRecords"
			oGender:CountAll()
			context "oGender RecordSetLength property" expect(oGender:RecordSetLength) TO_BE(1)
			context "oGender Found method" expect(oGender:Found) TO_BE_TRUTHY
			context "oGender FoundMany method" expect(oGender:FoundMany) TO_BE_FALSY
		enddescribe

		describe "oGender:CountAll()"
			describe "oGender:FeedProperties()"
				oGender:CountAll()
				context "Table empty?" expect (oGender:TableEmpty()) TO_BE_FALSY
				context "Number Of Records: oGender:CountAll()" expect (oGender:CountAll()) TO_BE( 3 )
			enddescribe
		enddescribe
	enddescribe

	oGender := oGender:Destroy()
RETURN NIL

FUNCTION seed_gender_fields( oGender )
	with object oGender
		:GenderDescription := "MASCULINO"
	endwith
RETURN NIL

FUNCTION check_properties( oGender ) FROM CONTEXT
	context "and checking if it was found" expect (oGender:Found()) TO_BE_TRUTHY
	context "Id" expect (oGender:Id) NOT_TO_BE_NIL
	context "GenderDescription" expect (oGender:GenderDescription) TO_BE( "MASCULINO" )
	context "CreatedAt Length" expect (Len(oGender:CreatedAt)) TO_BE(23)
	context "UpdatedAt Length" expect (Len(oGender:UpdatedAt)) TO_BE(23)
RETURN NIL