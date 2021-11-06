/*
    System.......: Harbour MVC sample Application
    Program......: model.prg
    Description..: Model Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "hbver.ch"
#include "custom_commands_v1.0.0.ch"

#define MAX_COL 132
#define MAX_ROW 40

//------------------------------------------------------------------
CLASS Model
    DATA nMaxCol        AS  INTEGER INIT    MAX_COL
    DATA nMaxRow        AS  INTEGER INIT    MAX_ROW

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD getAppNameTitle()
        METHOD getCenteredColumn(cText)
        METHOD getBoxDimensions()
        METHOD getDataBaseName()
        METHOD getDataBasePath()
        METHOD getAppLocation()
        METHOD getHarbourVersion()
        METHOD getCompilerVersion()
        METHOD getAppVersion()
        METHOD getOS()
        METHOD getCompanyName()
        METHOD getAppName()
        METHOD getDBPathDBName()

    HIDDEN:
        METHOD InitialSetup()

END CLASS

//------------------------------------------------------------------
METHOD New() CLASS Model
    ::InitialSetup()
RETURN Self

METHOD getCompanyName() CLASS Model
RETURN "My Company"

METHOD getAppName() CLASS Model
RETURN "My Application"

METHOD getAppNameTitle() CLASS Model
RETURN "*** " + ::getAppName + " ***"

METHOD getCenteredColumn(cText) CLASS Model
RETURN ((::nMaxCol - LEN(cText)) / 2)

METHOD getBoxDimensions() CLASS Model
    LOCAL hBox := {;
        "nRow1" => 08   ,   ;
        "nCol1" => 03   ,   ;
        "nRow2" => 38   ,   ;
        "nCol2" => 128      ;
        }
RETURN hBox

METHOD getDataBasePath() CLASS Model
RETURN "db"

METHOD getDataBaseName() CLASS Model
RETURN "accounts_rec.s3db"

METHOD getDBPathDBName() CLASS Model
RETURN ::getDataBasePath() + "/" + ::getDataBaseName()

METHOD getAppLocation() CLASS Model
RETURN CurDir()

METHOD getHarbourVersion() CLASS Model
    LOCAL cHarbourInfo := ;
        "Build Date bdate, major version:mjv, minor version:mnv, revision:rv"
    LOCAL hHarbourInfo := { ;
        "bdate" => hb_Version( HB_VERSION_COMPILER ),           ;
        "mjv"   => ltrim(str(hb_Version( HB_VERSION_MAJOR ))),  ;
        "mnv"   => ltrim(str(hb_Version( HB_VERSION_MINOR ))),  ;
        "rv"    => hb_Version( HB_VERSION_RELEASE )             ;
        }
RETURN hb_StrReplace(cHarbourInfo, hHarbourInfo)

METHOD getCompilerVersion() CLASS Model
RETURN hb_Version( HB_VERSION_COMPILER )

METHOD getAppVersion() CLASS Model
RETURN "1.0.0"

METHOD getOS() CLASS Model
RETURN OS()

METHOD InitialSetup() CLASS Model
    set( _SET_DATEFORMAT, "DD/MM/YYYY" )
    SET CENTURY ON
    SET MESSAGE TO 04 CENTER
    SET WRAP ON
    SET DELIMITERS ON
    SET DELIMITERS TO "[]"
    SET CONFIRM ON
    SET SCOREBOARD OFF
    SETMODE(::nMaxRow, ::nMaxCol)
RETURN NIL