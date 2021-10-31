/*
    System.......: Harbour MVC sample Application
    Program......: model.prg
    Description..: Model Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"

#define COMPANY_NAME "My Company"
#define APP_VERSION "1.0.0"
#define APP_NAME "My Application"
#define MAX_COL 132 //(MaxCol()-3)
#define MAX_ROW 40

//------------------------------------------------------------------
CLASS Model

    DATA cCompanyName   AS  STRING  INIT    COMPANY_NAME
    DATA cAppVersion    AS  STRING  INIT    APP_VERSION
    DATA cAppName       AS  STRING  INIT    APP_NAME
    DATA nMaxCol        AS  INTEGER INIT    MAX_COL
    DATA nMaxRow        AS  INTEGER INIT    MAX_ROW
    DATA hMainBoxPos    AS  HASH    INIT {;
        "nRow1" => 08, "nCol1" => 03        ,   ;
        "nRow2" => 27 ,"nCol2" => MAX_COL   ,   ;
        "cChars" => "┌─┐│┘─└│ "                 ;
        }

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD getAppNameTitle()
        METHOD getCenteredColumn(cText)

    HIDDEN:
        METHOD InitialSetup()

END CLASS

//------------------------------------------------------------------
METHOD New() CLASS Model
    ::InitialSetup()
RETURN Self

METHOD getAppNameTitle() CLASS Model
RETURN "*** " + ::cAppName + " ***"

METHOD getCenteredColumn(cText) CLASS Model
RETURN ((::nMaxCol - LEN(cText)) / 2)

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