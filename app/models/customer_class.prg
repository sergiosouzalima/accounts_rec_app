/*
    System.......: Accounts Receivable Application
    Program......: customer_class.prg
    Description..: Customer Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

CREATE CLASS Customer INHERIT CustomerDao
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

    HIDDEN:
        DATA oCustomerDao   AS Object   INIT NIL
        METHOD Validation()
        METHOD InsertValidation()
        METHOD UpdateValidation()
        METHOD DeleteValidation(cID)
        METHOD SetPropsToRecordhHash()

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS Customer
    ::oCustomerDao := ::Super:New( hb_defaultValue(cConnection, "ar_app.s3db") )
RETURN Self

METHOD Destroy() CLASS Customer
    Self := NIL
RETURN Self

METHOD CustomerName( cCustomerName ) CLASS Customer
    ::cCustomerName := cCustomerName IF hb_IsString(cCustomerName)
RETURN ::cCustomerName

METHOD GenderId( nGenderId ) CLASS Customer
    ::nGenderId := nGenderId IF hb_IsNumeric(nGenderId)
RETURN ::nGenderId

METHOD Gender( oGender ) CLASS Customer
    ::oGender := oGender IF hb_IsObject(oGender) .OR. oGender == NIL
RETURN ::oGender

METHOD AddressDescription( cAddressDescription ) CLASS Customer
    ::cAddressDescription := cAddressDescription IF hb_IsString(cAddressDescription)
RETURN ::cAddressDescription

METHOD CountryCodePhoneNumber( cCountryCodePhoneNumber ) CLASS Customer
    ::cCountryCodePhoneNumber := cCountryCodePhoneNumber IF hb_IsString(cCountryCodePhoneNumber)
RETURN ::cCountryCodePhoneNumber

METHOD AreaPhoneNumber( cAreaPhoneNumber ) CLASS Customer
    ::cAreaPhoneNumber := cAreaPhoneNumber IF hb_IsString(cAreaPhoneNumber)
RETURN ::cAreaPhoneNumber

METHOD PhoneNumber( cPhoneNumber ) CLASS Customer
    ::cPhoneNumber := cPhoneNumber IF hb_IsString(cPhoneNumber)
RETURN ::cPhoneNumber

METHOD CustomerEmail( cCustomerEmail ) CLASS Customer
    ::cCustomerEmail := cCustomerEmail IF hb_IsString(cCustomerEmail)
RETURN ::cCustomerEmail

METHOD BirthDate( cBirthDate ) CLASS Customer
    ::cBirthDate := cBirthDate IF hb_IsString(cBirthDate) // Sqlite3: Date Type is String
RETURN ::cBirthDate

METHOD DocumentNumber( cDocumentNumber ) CLASS Customer
    ::cDocumentNumber := cDocumentNumber IF hb_IsString(cDocumentNumber)
RETURN ::cDocumentNumber

METHOD ZipCodeNumber( cZipCodeNumber ) CLASS Customer
    ::cZipCodeNumber := cZipCodeNumber IF hb_IsString(cZipCodeNumber)
RETURN ::cZipCodeNumber

METHOD CityName( cCityName ) CLASS Customer
    ::cCityName := cCityName IF hb_IsString(cCityName)
RETURN ::cCityName

METHOD CityStateInitials( cCityStateInitials ) CLASS Customer
    ::cCityStateInitials := cCityStateInitials IF hb_IsString(cCityStateInitials)
RETURN ::cCityStateInitials

METHOD Insert() CLASS Customer
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::InsertValidation() IF ::Valid
        hRecord := ::SetPropsToRecordhHash(hRecord) IF ::Valid

        IF ::Valid
            ::oCustomerDao:CustomerDao:Insert(hRecord)
            ::Message := "Cliente cadastrado com sucesso!"
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Update(cID) CLASS Customer
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::UpdateValidation(cID) IF ::Valid
        hRecord := ::SetPropsToRecordhHash(hRecord) IF ::Valid

        IF ::Valid
            ::oCustomerDao:CustomerDao:Update(cID, hRecord)
            ::Message := "Cliente alterado com sucesso!"
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Delete(cID) CLASS Customer
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

METHOD Validation() CLASS Customer
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

METHOD InsertValidation() CLASS Customer
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

METHOD UpdateValidation(cID) CLASS Customer
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

METHOD DeleteValidation(cID) CLASS Customer
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

METHOD SetPropsToRecordhHash(hRecord) CLASS Customer
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

METHOD ResetProperties() CLASS Customer
    LOCAL oError := NIL, lOk := .F.

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
        ::NumberOfRecords       := 0
        lOk := .T.
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lOk .AND. oError == NIL

METHOD FeedProperties() CLASS Customer
    LOCAL oError := NIL, lOk := .F.
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
        ::NumberOfRecords       := oUtilities:getNumericValueFromHash(ahRecordSet, "NUMBER_OF_RECORDS")
        lOk := .T.
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lOk .AND. oError == NIL

METHOD ONERROR( xParam ) CLASS Customer
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