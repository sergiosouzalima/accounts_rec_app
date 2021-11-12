/*
    System.......: DAO
    Program......: genderdao_model.prg
    Description..: Belongs to Model DAO to allow access to a datasource named Gender.
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/


#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

#define SQL_CREATE_TABLE ;
    "CREATE TABLE IF NOT EXISTS GENDER(" + ;
    " ID VARCHAR2(36) NOT NULL PRIMARY KEY," +;
    " GENDER_DESCRIPTION VARCHAR2(40) NOT NULL," +;
    " CREATED_AT VARCHAR2(23)," +;
    " UPDATED_AT VARCHAR2(23));" +;
    " CREATE UNIQUE INDEX I01_GENDER ON GENDER(GENDER_DESCRIPTION); " +;
    " CREATE INDEX I02_GENDER ON GENDER(CREATED_AT);"

#define SQL_INSERT ;
    "INSERT INTO GENDER(" +;
    " ID, GENDER_DESCRIPTION, " +;
    " CREATED_AT, UPDATED_AT) VALUES(" +;
    " '#ID', '#GENDER_DESCRIPTION'," +;
    " '#CREATED_AT', '#UPDATED_AT' );"

#define SQL_UPDATE ;
    "UPDATE GENDER SET" +;
    " GENDER_DESCRIPTION = '#GENDER_DESCRIPTION'," +;
    " UPDATED_AT = '#UPDATED_AT'"+;
    " WHERE ID = '#ID';"

#define SQL_DELETE ;
    "DELETE FROM GENDER WHERE ID = '#ID';"

#define SQL_FIND_BY_ID ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " WHERE ID = '#ID';"

#define SQL_FIND_BY_GENDER_DESCRIPTION ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " WHERE GENDER_DESCRIPTION = '#GENDER_DESCRIPTION';"

#define SQL_AVOID_DUP ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " WHERE ID <> '#ID' AND GENDER_DESCRIPTION = '#GENDER_DESCRIPTION';"

#define SQL_ALL ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " ORDER BY CREATED_AT;"

#define SQL_COUNT_ALL ;
    "SELECT COUNT(*) AS NUMBER_OF_RECORDS FROM GENDER;"

#define SQL_FIRST ;
    "SELECT" +;
    " ID," +;
    " GENDER_DESCRIPTION," +;
    " CREATED_AT," +;
    " UPDATED_AT" +;
    " FROM GENDER" +;
    " ORDER BY CREATED_AT" +;
    " LIMIT 1;"

CREATE CLASS GenderDao INHERIT PersistenceDao
    EXPORTED:
        METHOD  New( cConnection ) CONSTRUCTOR
        METHOD  Destroy()
        METHOD  CreateTable()
        METHOD  Insert( hRecord )
        METHOD  Update( cID, hRecord )
        METHOD  Delete( cID )
        METHOD  FindById( cID )
        METHOD  FindByGenderDescription( cGenderDescription )
        METHOD  FindGenderAvoidDup( cID, cGenderDescription )
        METHOD  FindAll()
        METHOD  CountAll()
        METHOD  FindFirst()
        METHOD  TableEmpty()

    HIDDEN:
        DATA oPersistenceDao   AS Object   INIT NIL

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS GenderDao
    ::oPersistenceDao := ::Super:New( hb_defaultValue(cConnection, "database.s3db") )
RETURN Self

METHOD Destroy() CLASS GenderDao
    Self := NIL
RETURN Self
//-------------------

METHOD CreateTable() CLASS GenderDao
    LOCAL oError := NIL
    TRY
        ::ExecuteCommand( SQL_CREATE_TABLE )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD Insert( hRecord ) CLASS GenderDao
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

METHOD Update( cID, hRecord ) CLASS GenderDao
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

METHOD Delete( cID ) CLASS GenderDao
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

METHOD FindById( cID ) CLASS GenderDao
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

METHOD CountAll() CLASS GenderDao
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

METHOD TableEmpty() CLASS GenderDao
    LOCAL oError := NIL, nNumberOfRecords := 0
    TRY
        nNumberOfRecords := ::CountAll()
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN nNumberOfRecords == 0

METHOD FindByGenderDescription( cGenderDescription ) CLASS GenderDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(cGenderDescription)
        hRecord["#GENDER_DESCRIPTION"] := cGenderDescription
        ::FindBy( hRecord, SQL_FIND_BY_GENDER_DESCRIPTION )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindGenderAvoidDup( cID, cGenderDescription ) CLASS GenderDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        BREAK IF Empty(cID) .or. Empty(cGenderDescription)
        hRecord["#ID"] := cID
        hRecord["#GENDER_DESCRIPTION"] := cGenderDescription
        ::FindBy( hRecord, SQL_AVOID_DUP )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindAll() CLASS GenderDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        ::FindBy( hRecord, SQL_ALL )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD FindFirst() CLASS GenderDao
    LOCAL oError := NIL,  hRecord := { => }

    TRY
        ::InitStatusIndicators()
        ::FindBy( hRecord, SQL_FIRST )
    CATCH oError
        ::Error := oError
    ENDTRY
RETURN NIL

METHOD ONERROR( xParam ) CLASS GenderDao
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