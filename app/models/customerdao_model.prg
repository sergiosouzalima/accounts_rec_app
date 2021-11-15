/*
    System.......: DAO
    Program......: customerdao_model.prg
    Description..: Belongs to Model DAO to allow access to a datasource named Customer.
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

#define SQL_CREATE_TABLE ;
    "CREATE TABLE IF NOT EXISTS CUSTOMER(" + ;
    " ID VARCHAR2(36) NOT NULL PRIMARY KEY," +;
    " CUSTOMER_NAME VARCHAR2(40) NOT NULL," +;
    " BIRTH_DATE CHAR(10) NOT NULL," +;
    " GENDER_ID VARCHAR2(36) NOT NULL," +;
    " ADDRESS_DESCRIPTION VARCHAR2(40)," +;
    " COUNTRY_CODE_PHONE_NUMBER CHAR(02)," +;
    " AREA_PHONE_NUMBER CHAR(03)," +;
    " PHONE_NUMBER VARCHAR2(10)," +;
    " CUSTOMER_EMAIL VARCHAR2(40)," +;
    " DOCUMENT_NUMBER VARCHAR2(20)," +;
    " ZIP_CODE_NUMBER CHAR(09)," +;
    " CITY_NAME VARCHAR2(20)," +;
    " CITY_STATE_INITIALS CHAR(02)," +;
    " CREATED_AT VARCHAR2(23)," +;
    " UPDATED_AT VARCHAR2(23));"

#define SQL_CREATE_INDEX_I01 ;
    "CREATE UNIQUE INDEX I01_CUSTOMER ON CUSTOMER(CUSTOMER_NAME);"

#define SQL_CREATE_INDEX_I02 ;
    "CREATE INDEX I02_CUSTOMER ON CUSTOMER(CREATED_AT);"

#define SQL_INSERT ;
    "INSERT INTO CUSTOMER(" +;
    " ID, CUSTOMER_NAME, GENDER_ID, ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER, AREA_PHONE_NUMBER, PHONE_NUMBER," +;
    " CUSTOMER_EMAIL, BIRTH_DATE, DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER, CITY_NAME, CITY_STATE_INITIALS," +;
    " CREATED_AT, UPDATED_AT) VALUES(" +;
    " '#ID', '#CUSTOMER_NAME', '#GENDER_ID', '#ADDRESS_DESCRIPTION'," +;
    " '#COUNTRY_CODE_PHONE_NUMBER', '#AREA_PHONE_NUMBER', '#PHONE_NUMBER'," +;
    " '#CUSTOMER_EMAIL', '#BIRTH_DATE', '#DOCUMENT_NUMBER'," +;
    " '#ZIP_CODE_NUMBER', '#CITY_NAME', '#CITY_STATE_INITIALS'," +;
    " '#CREATED_AT', '#UPDATED_AT' );"

#define SQL_UPDATE ;
    "UPDATE CUSTOMER SET" +;
    " CUSTOMER_NAME = '#CUSTOMER_NAME', ADDRESS_DESCRIPTION = '#ADDRESS_DESCRIPTION'," +;
    " GENDER_ID = '#GENDER_ID'," +;
    " COUNTRY_CODE_PHONE_NUMBER = '#COUNTRY_CODE_PHONE_NUMBER'," +;
    " AREA_PHONE_NUMBER = '#AREA_PHONE_NUMBER', PHONE_NUMBER = '#PHONE_NUMBER'," +;
    " CUSTOMER_EMAIL = '#CUSTOMER_EMAIL', BIRTH_DATE = '#BIRTH_DATE', DOCUMENT_NUMBER = '#DOCUMENT_NUMBER'," +;
    " ZIP_CODE_NUMBER = '#ZIP_CODE_NUMBER', CITY_NAME = '#CITY_NAME', CITY_STATE_INITIALS = '#CITY_STATE_INITIALS'," +;
    " UPDATED_AT = '#UPDATED_AT'"+;
    " WHERE ID = '#ID';"

#define SQL_DELETE ;
    "DELETE FROM CUSTOMER WHERE ID = '#ID';"

#define SQL_FIND_BY_ID ;
    "SELECT" +;
    " ID," +;
    " CUSTOMER_NAME," +;
    " BIRTH_DATE," +;
    " GENDER_ID," +;
    " ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER," +;
    " AREA_PHONE_NUMBER," +;
    " PHONE_NUMBER," +;
    " CUSTOMER_EMAIL," +;
    " DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER," +;
    " CITY_NAME," +;
    " CITY_STATE_INITIALS," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM CUSTOMER" +;
    " WHERE ID = '#ID';"

#define SQL_FIND_BY_CUSTOMER_NAME ;
    "SELECT" +;
    " ID," +;
    " CUSTOMER_NAME," +;
    " BIRTH_DATE," +;
    " GENDER_ID," +;
    " ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER," +;
    " AREA_PHONE_NUMBER," +;
    " PHONE_NUMBER," +;
    " CUSTOMER_EMAIL," +;
    " DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER," +;
    " CITY_NAME," +;
    " CITY_STATE_INITIALS," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM CUSTOMER" +;
    " WHERE CUSTOMER_NAME = '#CUSTOMER_NAME';"

#define SQL_AVOID_DUP ;
    "SELECT" +;
    " ID," +;
    " CUSTOMER_NAME," +;
    " BIRTH_DATE," +;
    " GENDER_ID," +;
    " ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER," +;
    " AREA_PHONE_NUMBER," +;
    " PHONE_NUMBER," +;
    " CUSTOMER_EMAIL," +;
    " DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER," +;
    " CITY_NAME," +;
    " CITY_STATE_INITIALS," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM CUSTOMER" +;
    " WHERE CUSTOMER_NAME = '#CUSTOMER_NAME' AND ID <> '#ID';"

#define SQL_ALL ;
    "SELECT" +;
    " ID," +;
    " CUSTOMER_NAME," +;
    " BIRTH_DATE," +;
    " GENDER_ID," +;
    " ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER," +;
    " AREA_PHONE_NUMBER," +;
    " PHONE_NUMBER," +;
    " CUSTOMER_EMAIL," +;
    " DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER," +;
    " CITY_NAME," +;
    " CITY_STATE_INITIALS," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM CUSTOMER" +;
    " ORDER BY CREATED_AT;"

#define SQL_COUNT_ALL ;
    "SELECT COUNT(*) AS NUMBER_OF_RECORDS FROM CUSTOMER;"

#define SQL_FIRST ;
    "SELECT" +;
    " ID," +;
    " CUSTOMER_NAME," +;
    " BIRTH_DATE," +;
    " GENDER_ID," +;
    " ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER," +;
    " AREA_PHONE_NUMBER," +;
    " PHONE_NUMBER," +;
    " CUSTOMER_EMAIL," +;
    " DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER," +;
    " CITY_NAME," +;
    " CITY_STATE_INITIALS," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM CUSTOMER" +;
    " ORDER BY CREATED_AT" +;
    " LIMIT 1;"

#define SQL_GENDER_BY_ID ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " WHERE ID = '#ID';"

CREATE CLASS CustomerDao INHERIT PersistenceDao

    EXPORTED:
        METHOD CustomerName( cCustomerName ) SETGET
        METHOD GenderId( cGenderId ) SETGET
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

    HIDDEN:
        DATA cCustomerName              AS STRING   INIT ""
        DATA cGenderId                  AS STRING   INIT ""
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
        METHOD  New( cConnection ) CONSTRUCTOR
        METHOD  Destroy()
        METHOD  FeedProperties( ahRecordSet )
        METHOD  ResetProperties()
        METHOD  CreateTable()
        METHOD  Insert( hRecord )
        METHOD  Update( cID, hRecord )
        METHOD  Delete( cID )
        METHOD  FindById( cID )
        METHOD  FindByCustomerName( cCustomerName )
        METHOD  FindCustomerAvoidDup( cID, cCustomerName )
        METHOD  FindAll()
        METHOD  CountAll()
        METHOD  FindFirst()
        METHOD  TableEmpty()

    EXPORTED:
        DATA    cSqlFindById            AS STRING   INIT SQL_FIND_BY_ID
        DATA    cSqlAvoidDup            AS STRING   INIT SQL_AVOID_DUP
        DATA    cSqlFindByCustomerName  AS STRING   INIT SQL_FIND_BY_CUSTOMER_NAME

    HIDDEN:
        DATA    oPersistenceDao AS Object   INIT NIL

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS CustomerDao
    ::oPersistenceDao := ::Super:New( hb_defaultValue(cConnection, "database.s3db") )
    ::InitStatusIndicators()
RETURN Self

METHOD Destroy() CLASS CustomerDao
    Self := NIL
RETURN Self
//-------------------

METHOD CustomerName( cCustomerName ) CLASS CustomerDao
    ::cCustomerName := cCustomerName IF hb_IsString(cCustomerName)
RETURN ::cCustomerName

METHOD GenderId( cGenderId ) CLASS CustomerDao
    LOCAL lValid := hb_IsString(cGenderId), oGender := NIL

    IF lValid
        ::cGenderId := cGenderId
        oGender := GenderModel():New( ::oPersistenceDao:pConnection )
        oGender:FindById( ::cGenderId )
        ::oGender := oGender IF oGender:Found()
    ENDIF
RETURN ::cGenderId

METHOD Gender( oGender ) CLASS CustomerDao
    LOCAL lValid := hb_IsObject(oGender) .AND. oGender:ClassName() == "GENDERMODEL"
    IF lValid
        ::oGender := oGender
        ::cGenderId := ::oGender:Id
    ENDIF
RETURN ::oGender

METHOD AddressDescription( cAddressDescription ) CLASS CustomerDao
    ::cAddressDescription := cAddressDescription IF hb_IsString(cAddressDescription)
RETURN ::cAddressDescription

METHOD CountryCodePhoneNumber( cCountryCodePhoneNumber ) CLASS CustomerDao
    ::cCountryCodePhoneNumber := cCountryCodePhoneNumber IF hb_IsString(cCountryCodePhoneNumber)
RETURN ::cCountryCodePhoneNumber

METHOD AreaPhoneNumber( cAreaPhoneNumber ) CLASS CustomerDao
    ::cAreaPhoneNumber := cAreaPhoneNumber IF hb_IsString(cAreaPhoneNumber)
RETURN ::cAreaPhoneNumber

METHOD PhoneNumber( cPhoneNumber ) CLASS CustomerDao
    ::cPhoneNumber := cPhoneNumber IF hb_IsString(cPhoneNumber)
RETURN ::cPhoneNumber

METHOD CustomerEmail( cCustomerEmail ) CLASS CustomerDao
    ::cCustomerEmail := cCustomerEmail IF hb_IsString(cCustomerEmail)
RETURN ::cCustomerEmail

METHOD BirthDate( cBirthDate ) CLASS CustomerDao
    ::cBirthDate := cBirthDate IF hb_IsString(cBirthDate) // Sqlite3: Date Type is String
RETURN ::cBirthDate

METHOD DocumentNumber( cDocumentNumber ) CLASS CustomerDao
    ::cDocumentNumber := cDocumentNumber IF hb_IsString(cDocumentNumber)
RETURN ::cDocumentNumber

METHOD ZipCodeNumber( cZipCodeNumber ) CLASS CustomerDao
    ::cZipCodeNumber := cZipCodeNumber IF hb_IsString(cZipCodeNumber)
RETURN ::cZipCodeNumber

METHOD CityName( cCityName ) CLASS CustomerDao
    ::cCityName := cCityName IF hb_IsString(cCityName)
RETURN ::cCityName

METHOD CityStateInitials( cCityStateInitials ) CLASS CustomerDao
    ::cCityStateInitials := cCityStateInitials IF hb_IsString(cCityStateInitials)
RETURN ::cCityStateInitials
//--------------------

METHOD ResetProperties() CLASS CustomerDao
    LOCAL oError := NIL

    TRY
        ::Id                    := ""
        ::CustomerName          := ""
        ::BirthDate             := ""
        ::GenderId              := ""
        ::oGender               := NIL
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
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FeedProperties() CLASS CustomerDao
    LOCAL oError := NIL
    LOCAL ahRecordSet := NIL, oUtilities := Utilities():New()
    LOCAL lFound := .F.

    RETURN .F. IF ::NotFound()
    TRY
        ahRecordSet := ::RecordSet[01]
        ::Id                    := oUtilities:getStringValueFromHash (ahRecordSet, "ID")
        ::CustomerName          := oUtilities:getStringValueFromHash (ahRecordSet, "CUSTOMER_NAME")
        ::BirthDate             := oUtilities:getStringValueFromHash (ahRecordSet, "BIRTH_DATE")
        ::GenderId              := oUtilities:getStringValueFromHash (ahRecordSet, "GENDER_ID")
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
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL
//----------------------

METHOD CreateTable() CLASS CustomerDao
    LOCAL oError := NIL
    TRY
        ::ExecuteCommand( SQL_CREATE_TABLE )
        ::ExecuteCommand( SQL_CREATE_INDEX_I01 )
        ::ExecuteCommand( SQL_CREATE_INDEX_I02 )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD Insert( hRecord ) CLASS CustomerDao
    LOCAL oError := NIL, oUtilities := Utilities():New()
    LOCAL cGUID := ""
    TRY
        BREAK IF Empty(hRecord)
        hRecord["#ID"] := ( cGUID := oUtilities:GetGUID() )
        hRecord["#CREATED_AT"] := oUtilities:GetTimeStamp()
        hRecord["#UPDATED_AT"] := hRecord["#CREATED_AT"]
        ::ExecuteCommand( hb_StrReplace( SQL_INSERT, hRecord ) )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN cGUID

METHOD Update( cID, hRecord ) CLASS CustomerDao
    LOCAL oError := NIL

    TRY
        BREAK IF Empty(hRecord) .OR. Empty(cID)
        hRecord["#ID"] := cID
        hRecord["#UPDATED_AT"] := Utilities():New():GetTimeStamp()
        ::ExecuteCommand( hb_StrReplace( SQL_UPDATE, hRecord ) )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD Delete( cID ) CLASS CustomerDao
    LOCAL oError := NIL, hRecord := { => }

    TRY
        BREAK IF Empty(cID)
        hRecord["#ID"] := cID
        ::ExecuteCommand( hb_StrReplace( SQL_DELETE, hRecord ) )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD CountAll() CLASS CustomerDao
    LOCAL oError := NIL, hRecord := { => }
    LOCAL ahRecordSet := NIL, oUtilities := Utilities():New(), nNumberOfRecords := 0

    TRY
        ::FindBy( hRecord, SQL_COUNT_ALL )
        ahRecordSet := ::RecordSet[01]
        nNumberOfRecords := oUtilities:getNumericValueFromHash(ahRecordSet, "NUMBER_OF_RECORDS")
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN nNumberOfRecords

METHOD TableEmpty() CLASS CustomerDao
    LOCAL oError := NIL, nNumberOfRecords := 0
    TRY
        nNumberOfRecords := ::CountAll()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN nNumberOfRecords == 0

METHOD FindById( cID ) CLASS CustomerDao
    LOCAL oError := NIL, hRecord := { => }

    TRY
        BREAK IF Empty(cID)
        hRecord["#ID"] := cID
        ::FindBy( hRecord, SQL_FIND_BY_ID )
        ::FeedProperties()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN Self

METHOD FindByCustomerName( cCustomerName ) CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        BREAK IF Empty(cCustomerName)
        hRecord["#CUSTOMER_NAME"] := cCustomerName
        ::FindBy( hRecord, SQL_FIND_BY_CUSTOMER_NAME )
        ::FeedProperties()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN Self

METHOD FindCustomerAvoidDup( cID, cCustomerName ) CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        BREAK IF Empty(cID) .or. Empty(cCustomerName)
        hRecord["#ID"] := cID
        hRecord["#CUSTOMER_NAME"] := cCustomerName
        ::FindBy( hRecord, SQL_AVOID_DUP )
        ::FeedProperties()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN Self

METHOD FindAll() CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::FindBy( hRecord, SQL_ALL )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindFirst() CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::FindBy( hRecord, SQL_FIRST )
        ::FeedProperties()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN Self

METHOD ONERROR( xParam ) CLASS CustomerDao
    LOCAL xResult := NIL
    xResult := Error():New():getOnErrorMessage( Self, xParam, __GetMessage() )
    ? "*** Error => ", xResult
RETURN xResult

/*METHOD ONERROR( xParam ) CLASS CustomerDao
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
RETURN xResult*/