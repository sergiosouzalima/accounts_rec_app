/*
    System.......: Accounts Receivable Application
    Program......: customer_class.prg
    Description..: Customer Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

CREATE CLASS CustomerModel FROM CustomerDao, Model

    EXPORTED:
		METHOD New( cConnection ) CONSTRUCTOR
        METHOD CustomerName( cCustomerName ) SETGET
        METHOD GenderId( nGenderId ) SETGET
        METHOD Gender( oGender ) SETGET
        METHOD AddressDescription( cAddressDescription ) SETGET
        METHOD CountryCodePhoneNumber( cCountryCodePhoneNumber ) SETGET
        METHOD AreaPhoneNumber( cAreaPhoneNumber ) SETGET
        METHOD PhoneNumber( cPhoneNumber ) SETGET
        METHOD CustomerEmail( cCustomerEmail ) SETGET
        METHOD BirthDate( cBirthDate ) SETGET
        METHOD DocumentNumber( cDocumentNumber ) SETGET
        METHOD ZipCodeNumber( cZipCodeNumber ) SETGET
        METHOD CityName( cCityName ) SETGET
        METHOD CityStateInitials( cCityStateInitials ) SETGET
        METHOD Destroy()
        METHOD Insert()
        METHOD Update( cID )
        METHOD Delete( cID )
        METHOD FeedProperties( ahRecordSet )
        METHOD ResetProperties()
        METHOD InsertFakeCustomer()
        METHOD BrowseDataPrepare()

    HIDDEN:
        DATA cCustomerName              AS STRING   INIT ""
        DATA nGenderId                  AS INTEGER  INIT 0
        DATA oGender                    AS Object   INIT NIL
        DATA cAddressDescription        AS STRING   INIT ""
        DATA cCountryCodePhoneNumber    AS STRING   INIT ""
        DATA cAreaPhoneNumber           AS STRING   INIT ""
        DATA cPhoneNumber               AS STRING   INIT ""
        DATA cCustomerEmail             AS STRING   INIT ""
        DATA cBirthDate                 AS STRING   INIT ""
        DATA cDocumentNumber            AS STRING   INIT ""
        DATA cZipCodeNumber             AS STRING   INIT ""
        DATA cCityName                  AS STRING   INIT ""
        DATA cCityStateInitials         AS STRING   INIT ""
        DATA oCustomerDao               AS Object   INIT NIL
        METHOD Validation()
        METHOD InsertValidation()
        METHOD UpdateValidation()
        METHOD DeleteValidation(cID)
        METHOD SetPropsToRecordHash()

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS CustomerModel
    ::oCustomerDao := ::CustomerDao:New( cConnection )
RETURN Self

METHOD Destroy() CLASS CustomerModel
    Self := NIL
RETURN Self

METHOD CustomerName( cCustomerName ) CLASS CustomerModel
    ::cCustomerName := cCustomerName IF hb_IsString(cCustomerName)
RETURN ::cCustomerName

METHOD GenderId( nGenderId ) CLASS CustomerModel
    ::nGenderId := nGenderId IF hb_IsNumeric(nGenderId)
RETURN ::nGenderId

METHOD Gender( oGender ) CLASS CustomerModel
    ::oGender := oGender IF hb_IsObject(oGender) .OR. oGender == NIL
RETURN ::oGender

METHOD AddressDescription( cAddressDescription ) CLASS CustomerModel
    ::cAddressDescription := cAddressDescription IF hb_IsString(cAddressDescription)
RETURN ::cAddressDescription

METHOD CountryCodePhoneNumber( cCountryCodePhoneNumber ) CLASS CustomerModel
    ::cCountryCodePhoneNumber := cCountryCodePhoneNumber IF hb_IsString(cCountryCodePhoneNumber)
RETURN ::cCountryCodePhoneNumber

METHOD AreaPhoneNumber( cAreaPhoneNumber ) CLASS CustomerModel
    ::cAreaPhoneNumber := cAreaPhoneNumber IF hb_IsString(cAreaPhoneNumber)
RETURN ::cAreaPhoneNumber

METHOD PhoneNumber( cPhoneNumber ) CLASS CustomerModel
    ::cPhoneNumber := cPhoneNumber IF hb_IsString(cPhoneNumber)
RETURN ::cPhoneNumber

METHOD CustomerEmail( cCustomerEmail ) CLASS CustomerModel
    ::cCustomerEmail := cCustomerEmail IF hb_IsString(cCustomerEmail)
RETURN ::cCustomerEmail

METHOD BirthDate( cBirthDate ) CLASS CustomerModel
    ::cBirthDate := cBirthDate IF hb_IsString(cBirthDate) // Sqlite3: Date Type is String
RETURN ::cBirthDate

METHOD DocumentNumber( cDocumentNumber ) CLASS CustomerModel
    ::cDocumentNumber := cDocumentNumber IF hb_IsString(cDocumentNumber)
RETURN ::cDocumentNumber

METHOD ZipCodeNumber( cZipCodeNumber ) CLASS CustomerModel
    ::cZipCodeNumber := cZipCodeNumber IF hb_IsString(cZipCodeNumber)
RETURN ::cZipCodeNumber

METHOD CityName( cCityName ) CLASS CustomerModel
    ::cCityName := cCityName IF hb_IsString(cCityName)
RETURN ::cCityName

METHOD CityStateInitials( cCityStateInitials ) CLASS CustomerModel
    ::cCityStateInitials := cCityStateInitials IF hb_IsString(cCityStateInitials)
RETURN ::cCityStateInitials

METHOD Insert() CLASS CustomerModel
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::InsertValidation() IF ::Valid
        hRecord := ::SetPropsToRecordHash(hRecord) IF ::Valid

        IF ::Valid
            ::oCustomerDao:CustomerDao:Insert(hRecord)
            ::Message := "Cliente cadastrado com sucesso!"
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Update(cID) CLASS CustomerModel
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::UpdateValidation(cID) IF ::Valid
        hRecord := ::SetPropsToRecordHash(hRecord) IF ::Valid

        IF ::Valid
            ::oCustomerDao:CustomerDao:Update(cID, hRecord)
            ::Message := "Cliente alterado com sucesso!"
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Delete(cID) CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        ::DeleteValidation(cID)

        IF ::Valid
            ::oCustomerDao:CustomerDao:Delete(cID)
            ::Message := "Cliente excluido com sucesso!"
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Validation() CLASS CustomerModel
    LOCAL oError := NIL, nI := 0, lCondition := .F., nConditions := 0
    LOCAL aValidation := { ;
            { {|| Empty(::CustomerName)}    , "Nome do Cliente nao informado!"}, ;
            { {|| Empty(::BirthDate)}       , "Data de Nascimento do Cliente nao informada!"}, ;
            { {|| Empty(::GenderId)}        , "Genero do Cliente nao informado!"} ;
        }

    TRY
        ::Valid := .F.
        nConditions := Len(aValidation)

        Repeat
            ::Message := aValidation[nI][2] IF (lCondition := Eval(aValidation[++nI][1]))
        Until nI >= nConditions .OR. lCondition

        ::Valid := !lCondition
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD InsertValidation() CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.
        ::oCustomerDao:CustomerDao:FindByCustomerName( ::CustomerName )
        IF ::oCustomerDao:CustomerDao:Found()
            ::Message := "Cliente ja cadastrado com este nome!"
        ELSE
            ::Valid := .T.
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD UpdateValidation(cID) CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.

        ::oCustomerDao:CustomerDao:FindById( cID )
        IF ::oCustomerDao:CustomerDao:NotFound()
            ::Message := "Cliente nao encontrado com Id: " + cID
        ELSE
            ::oCustomerDao:CustomerDao:FindCustomerAvoidDup( cID, ::CustomerName )
            IF ::oCustomerDao:CustomerDao:Found()
                ::Message := "Cliente ja cadastrado com este nome!"
            ELSE
                ::Valid := .T.
            ENDIF
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD DeleteValidation(cID) CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.

        ::oCustomerDao:CustomerDao:FindById( cID )
        IF ::oCustomerDao:CustomerDao:NotFound()
            ::Message := "Cliente nao encontrado com Id: " + cID
        ELSE
            ::Valid := .T.
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD SetPropsToRecordHash(hRecord) CLASS CustomerModel
    hRecord := { ;
        "#ID"                           =>  ::Id, ;
        "#CUSTOMER_NAME"                =>  ::CustomerName, ;
        "#BIRTH_DATE"                   =>  ::BirthDate, ;
        "#GENDER_ID"                    =>  Alltrim(Str(::GenderId)), ;
        "#ADDRESS_DESCRIPTION"          =>  ::AddressDescription, ;
        "#COUNTRY_CODE_PHONE_NUMBER"    =>  ::CountryCodePhoneNumber, ;
        "#AREA_PHONE_NUMBER"            =>  ::AreaPhoneNumber, ;
        "#PHONE_NUMBER"                 =>  ::PhoneNumber, ;
        "#CUSTOMER_EMAIL"               =>  ::CustomerEmail, ;
        "#DOCUMENT_NUMBER"              =>  ::DocumentNumber, ;
        "#ZIP_CODE_NUMBER"              =>  ::ZipCodeNumber, ;
        "#CITY_NAME"                    =>  ::CityName, ;
        "#CITY_STATE_INITIALS"          =>  ::CityStateInitials ;
    }
RETURN hRecord

METHOD ResetProperties() CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        ::Id                    := ""
        ::CustomerName          := ""
        ::BirthDate             := ""
        ::GenderId              := 0
        ::AddressDescription    := ""
        ::CountryCodePhoneNumber:= ""
        ::AreaPhoneNumber       := ""
        ::PhoneNumber           := ""
        ::CustomerEmail         := ""
        ::DocumentNumber        := ""
        ::ZipCodeNumber         := ""
        ::CityName              := ""
        ::CityStateInitials     := ""
        ::CreatedAt             := ""
        ::UpdatedAt             := ""
        //::NumberOfRecords       := 0
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD FeedProperties() CLASS CustomerModel
    LOCAL oError := NIL
    LOCAL ahRecordSet := NIL, oUtilities := Utilities():New()

    RETURN .F. IF ::oCustomerDao:CustomerDao:NotFound()

    TRY
        ahRecordSet := ::oCustomerDao:CustomerDao:RecordSet[01]
        ::Id                    := oUtilities:getStringValueFromHash (ahRecordSet, "ID")
        ::CustomerName          := oUtilities:getStringValueFromHash (ahRecordSet, "CUSTOMER_NAME")
        ::BirthDate             := oUtilities:getStringValueFromHash (ahRecordSet, "BIRTH_DATE")
        ::GenderId              := oUtilities:getNumericValueFromHash(ahRecordSet, "GENDER_ID")
        ::AddressDescription    := oUtilities:getStringValueFromHash (ahRecordSet, "ADDRESS_DESCRIPTION")
        ::CountryCodePhoneNumber:= oUtilities:getStringValueFromHash (ahRecordSet, "COUNTRY_CODE_PHONE_NUMBER")
        ::AreaPhoneNumber       := oUtilities:getStringValueFromHash (ahRecordSet, "AREA_PHONE_NUMBER")
        ::PhoneNumber           := oUtilities:getStringValueFromHash (ahRecordSet, "PHONE_NUMBER")
        ::CustomerEmail         := oUtilities:getStringValueFromHash (ahRecordSet, "CUSTOMER_EMAIL")
        ::DocumentNumber        := oUtilities:getStringValueFromHash (ahRecordSet, "DOCUMENT_NUMBER")
        ::ZipCodeNumber         := oUtilities:getStringValueFromHash (ahRecordSet, "ZIP_CODE_NUMBER")
        ::CityName              := oUtilities:getStringValueFromHash (ahRecordSet, "CITY_NAME")
        ::CityStateInitials     := oUtilities:getStringValueFromHash (ahRecordSet, "CITY_STATE_INITIALS")
        ::CreatedAt             := oUtilities:getStringValueFromHash (ahRecordSet, "CREATED_AT")
        ::UpdatedAt             := oUtilities:getStringValueFromHash (ahRecordSet, "UPDATED_AT")
        //::NumberOfRecords       := oUtilities:getNumericValueFromHash(ahRecordSet, "NUMBER_OF_RECORDS")
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD InsertFakeCustomer() CLASS CustomerModel
    LOCAL oError := NIL
    TRY
        WITH OBJECT Self
            :CustomerName := "JOAO DA SILVA."
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
        ENDWITH
        ::Insert()
        ::ResetProperties()
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD BrowseDataPrepare() CLASS CustomerModel
    LOCAL oBrowseData := NIL, nNumberOfRecords := 0
    LOCAL aColValues := {}, ahColValues := { => }
    LOCAL nCols := 0, i

    nNumberOfRecords := ::CountAll()
    //::FeedProperties()
    //nNumberOfRecords := ::NumberOfRecords

    ::FindAll()
    ::FeedProperties()

    ahColValues := ::RecordSet
    nCols := Len(ahColValues)

    FOR i := 1 TO nCols
        AADD( aColValues, { ;
                    ahColValues[i]["ID"], ;
                    ahColValues[i]["CUSTOMER_NAME"], ;
                    ahColValues[i]["BIRTH_DATE"] ,   ;
                    ahColValues[i]["GENDER_ID"], ;
                    ahColValues[i]["ADDRESS_DESCRIPTION"], ;
                    ahColValues[i]["COUNTRY_CODE_PHONE_NUMBER"], ;
                    ahColValues[i]["AREA_PHONE_NUMBER"], ;
                    ahColValues[i]["PHONE_NUMBER"], ;
                    ahColValues[i]["CUSTOMER_EMAIL"], ;
                    ahColValues[i]["DOCUMENT_NUMBER"], ;
                    ahColValues[i]["ZIP_CODE_NUMBER"], ;
                    ahColValues[i]["CITY_NAME"], ;
                    ahColValues[i]["CITY_STATE_INITIALS"], ;
                    ahColValues[i]["CREATED_AT"], ;
                    ahColValues[i]["UPDATED_AT"] ;
                } ;
            )
    NEXT

    oBrowseData := BrowseData():New( ::getBoxDimensions() )
    oBrowseData:Title := "Clientes"
    oBrowseData:ColHeadings := {"Id", "Nome Cliente", "Data Nasc" , ;
                                "Genero", "Endereco", "DDI", "DDD", "Telefone", ;
                                "Email", "Documento", "CEP",;
                                "Cidade", "Estado", "Registro em", "Alterado em"}
    oBrowseData:ColValues := { aColValues, 1 }
    oBrowseData:ColWidths := {  00, 40 , 10, ;
                                10, 40, 02, 03, 10, ;
                                40, 20, 09, ;
                                20, 02, 23, 23  }
    oBrowseData:NumOfRecords := nNumberOfRecords
RETURN oBrowseData

METHOD ONERROR( xParam ) CLASS CustomerModel
    LOCAL cCol := __GetMessage(), xResult

    IF Left( cCol, 1 ) == "_" // underscore means it's a variable
       cCol = Right( cCol, Len( cCol ) - 1 )
       IF ! __objHasData( Self, cCol )
          __objAddData( Self, cCol )
       ENDIF
       IF xParam == NIL
          xResult = __ObjSendMsg( Self, cCol )
       ELSE
          xResult = __ObjSendMsg( Self, "_" + cCol, xParam )
       ENDIF
    ELSE
       xResult := "Method not created " + cCol
    ENDIF
    ? "*** Error => ", xResult
RETURN xResult