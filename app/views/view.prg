/*
    System.......: Harbour MVC sample Application
    Program......: view.prg
    Description..: View Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"
#include "box.ch"

//------------------------------------------------------------------
CLASS View
    EXPORTED:
        METHOD  New() CONSTRUCTOR
        METHOD  showMainWindow( oModel )
        METHOD  showEnd()
        METHOD  showMainMenu() VIRTUAL
        METHOD  showBox(nInitialRow, nInitialCol, nFinalRow, nFinalCol)
        METHOD  clearBox(nInitialRow, nInitialCol, nFinalRow, nFinalCol)

END CLASS

//------------------------------------------------------------------
METHOD New() CLASS View
RETURN Self

METHOD showMainWindow( oModel ) CLASS View
    __Clear()
    @ 00,00 TO 00, oModel:nMaxCol DOUBLE
    @ 01,oModel:getCenteredColumn(oModel:cCompanyName) SAY oModel:cCompanyName
    @ 02,oModel:getCenteredColumn(oModel:getAppNameTitle()) SAY oModel:getAppNameTitle()
    @ 03,00 TO 03, oModel:nMaxCol
    @ 04, oModel:nMaxCol - 10 SAY Date()
    @ 05,00 TO 05, oModel:nMaxCol DOUBLE
RETURN NIL

METHOD showBox(nInitialRow, nInitialCol, nFinalRow, nFinalCol, cTitle) CLASS View
    @ nInitialRow, nInitialCol, nFinalRow, nFinalCol BOX B_DOUBLE_SINGLE + SPACE(1)
    @ nInitialRow - 01, nInitialCol CLEAR TO nInitialRow - 01, nFinalCol
    @ nInitialRow - 01, nInitialCol SAY "[ " + cTitle + " ]"
RETURN NIL

METHOD clearBox(nInitialRow, nInitialCol, nFinalRow, nFinalCol) CLASS View
    @ nInitialRow - 01, nInitialCol CLEAR TO nFinalRow, nFinalCol
RETURN NIL

//------------------------------------------------------------------
METHOD showEnd() CLASS View
    __Clear()
    hb_DispOutAt( 01, 01, "*** SYSTEM FINISHED!" )
    ? " "
    ? " "
RETURN NIL