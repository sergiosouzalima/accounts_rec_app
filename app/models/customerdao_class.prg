/*
    System.......: DAO
    Program......: customerdao_class.prg
    Description..: Belongs to Model DAO to allow access to a datasource named Customer.
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/


#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

#define SQL_CREATE_TABLE ;
    "CREATE TABLE IF NOT EXISTS CUSTOMER(" + ;
    " ID VARCHAR2(16) NOT NULL PRIMARY KEY," +;
    " CUSTOMER_NAME VARCHAR2(40) NOT NULL," +;
    " BIRTH_DATE CHAR(10) NOT NULL," +;
    " GENDER_ID INTEGER NOT NULL," +;
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
    " UPDATED_AT VARCHAR2(23));" +;
    " CREATE UNIQUE INDEX I01_CUSTOMER ON CUSTOMER(CUSTOMER_NAME); " +;
    " CREATE INDEX I02_CUSTOMER ON CUSTOMER(CREATED_AT);"
    //" FOREIGN KEY(GENDER_ID) REFERENCES GENDER(ID) ON UPDATE RESTRICT ON DELETE RESTRICT);"

#define SQL_INSERT ;
    "INSERT INTO CUSTOMER(" +;
    " ID, CUSTOMER_NAME, GENDER_ID, ADDRESS_DESCRIPTION," +;
    " COUNTRY_CODE_PHONE_NUMBER, AREA_PHONE_NUMBER, PHONE_NUMBER," +;
    " CUSTOMER_EMAIL, BIRTH_DATE, DOCUMENT_NUMBER," +;
    " ZIP_CODE_NUMBER, CITY_NAME, CITY_STATE_INITIALS," +;
    " CREATED_AT, UPDATED_AT) VALUES(" +;
    " '#ID', '#CUSTOMER_NAME', #GENDER_ID, '#ADDRESS_DESCRIPTION'," +;
    " '#COUNTRY_CODE_PHONE_NUMBER', '#AREA_PHONE_NUMBER', '#PHONE_NUMBER'," +;
    " '#CUSTOMER_EMAIL', '#BIRTH_DATE', '#DOCUMENT_NUMBER'," +;
    " '#ZIP_CODE_NUMBER', '#CITY_NAME', '#CITY_STATE_INITIALS'," +;
    " '#CREATED_AT', '#UPDATED_AT' );"

#define SQL_UPDATE ;
    "UPDATE CUSTOMER SET" +;
    " CUSTOMER_NAME = '#CUSTOMER_NAME', ADDRESS_DESCRIPTION = '#ADDRESS_DESCRIPTION'," +;
    " GENDER_ID = #GENDER_ID," +;
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
    " WHERE ID <> '#ID' AND CUSTOMER_NAME = '#CUSTOMER_NAME';"

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

CREATE CLASS CustomerDao INHERIT PersistenceDao
    EXPORTED:
        METHOD  New( cConnection ) CONSTRUCTOR
        METHOD  Destroy()
        METHOD  Destroy()
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

    HIDDEN:
        DATA oPersistenceDao   AS Object   INIT NIL

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS CustomerDao
    ::oPersistenceDao := ::Super:New( hb_defaultValue(cConnection, "database.s3db") )
RETURN Self

METHOD Destroy() CLASS CustomerDao
    Self := NIL
RETURN Self
//-------------------

METHOD CreateTable() CLASS CustomerDao
    LOCAL oError := NIL
    TRY
        ::ExecuteCommand( SQL_CREATE_TABLE )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD Insert( hRecord ) CLASS CustomerDao
    LOCAL oError := NIL, oUtilities := Utilities():New()
    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(hRecord)
        hRecord["#ID"] := oUtilities:GetGUID()
        hRecord["#CREATED_AT"] := oUtilities:GetTimeStamp()
        hRecord["#UPDATED_AT"] := hRecord["#CREATED_AT"]
        ::ExecuteCommand( hb_StrReplace( SQL_INSERT, hRecord ) )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD Update( cID, hRecord ) CLASS CustomerDao
    LOCAL oError := NIL

    TRY
        ::InitStatusIndicators()
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
        ::InitStatusIndicators()
        BREAK IF Empty(cID)
        hRecord["#ID"] := cID
        ::ExecuteCommand( hb_StrReplace( SQL_DELETE, hRecord ) )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindById( cID ) CLASS CustomerDao
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(cID)
        hRecord["#ID"] := cID
        ::FindBy( hRecord, SQL_FIND_BY_ID )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD CountAll() CLASS CustomerDao
    LOCAL oError := NIL, hRecord := { => }
    LOCAL ahRecordSet := NIL, oUtilities := Utilities():New(), nNumberOfRecords := 0

    TRY
        ::InitStatusIndicators()
        ::FindBy( hRecord, SQL_COUNT_ALL )
        ahRecordSet := ::RecordSet[01]
        nNumberOfRecords := oUtilities:getNumericValueFromHash(ahRecordSet, "NUMBER_OF_RECORDS")
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN nNumberOfRecords

METHOD TableEmpty() CLASS CustomerDao
    LOCAL oError := NIL
    TRY
        ::CountAll()
        ::FeedProperties()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN ::NumberOfRecords == 0

METHOD FindByCustomerName( cCustomerName ) CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(cCustomerName)
        hRecord["#CUSTOMER_NAME"] := cCustomerName
        ::FindBy( hRecord, SQL_FIND_BY_CUSTOMER_NAME )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindCustomerAvoidDup( cID, cCustomerName ) CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(cID) .or. Empty(cCustomerName)
        hRecord["#ID"] := cID
        hRecord["#CUSTOMER_NAME"] := cCustomerName
        ::FindBy( hRecord, SQL_AVOID_DUP )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindAll() CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        ::FindBy( hRecord, SQL_ALL )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindFirst() CLASS CustomerDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        ::FindBy( hRecord, SQL_FIRST )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD ONERROR( xParam ) CLASS CustomerDao
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