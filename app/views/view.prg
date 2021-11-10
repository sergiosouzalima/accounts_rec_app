/*
    System.......: Harbour MVC sample Application
    Program......: view.prg
    Description..: View Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"
#include "box.ch"

//------------------------------------------------------------------
CREATE CLASS View
    EXPORTED:
        METHOD  New() CONSTRUCTOR
        METHOD  showMainWindow( oModel )
        METHOD  showEnd()
        METHOD  showMainMenu() VIRTUAL
        METHOD  showBox(hBox, cTitle)
        METHOD  clearBox( hBox )

END CLASS

//------------------------------------------------------------------
METHOD New() CLASS View
RETURN Self

METHOD showMainWindow( oModel ) CLASS View
    __Clear()
    @ 00,00 TO 00, oModel:nMaxCol DOUBLE
    @ 01,oModel:getCenteredColumn(oModel:getCompanyName()) SAY oModel:getCompanyName()
    @ 02,oModel:getCenteredColumn(oModel:getAppNameTitle()) SAY oModel:getAppNameTitle()
    @ 03,00 TO 03, oModel:nMaxCol
    @ 04, oModel:nMaxCol - 10 SAY Date()
    @ 05,00 TO 05, oModel:nMaxCol DOUBLE
RETURN NIL

METHOD showBox(hBox, cTitle) CLASS View
    DispBox(hBox["nRow1"], hBox["nCol1"], hBox["nRow2"], hBox["nCol2"], B_DOUBLE_SINGLE + Chr(32), "W+/N")
    @hBox["nRow1"], hBox["nCol1"] + 02 SAY "[ " + cTitle + " ]"
RETURN NIL

METHOD clearBox( hBox ) CLASS View
    @hBox["nRow1"], hBox["nCol1"] CLEAR TO hBox["nRow2"], hBox["nCol2"]
RETURN NIL

//------------------------------------------------------------------
METHOD showEnd() CLASS View
    __Clear()
    hb_DispOutAt( 01, 01, "*** SYSTEM FINISHED!" )
    ? " "
    ? " "
RETURN NIL