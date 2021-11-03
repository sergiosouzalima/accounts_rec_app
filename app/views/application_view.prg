/*
    System.......: Harbour MVC sample Application
    Program......: application_view.prg
    Description..: View Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationView FROM View

    EXPORTED:
        METHOD showMainMenu( hMainMenuBox, aMenuItems )
        METHOD getOption()

END CLASS

METHOD showMainMenu( hMainMenuBox, aMenuItems ) CLASS ApplicationView
    LOCAL i := 0

    ::showBox( ;
        hMainMenuBox["nRow1"], hMainMenuBox["nCol1"], ;
        hMainMenuBox["nRow2"], hMainMenuBox["nCol2"], ;
        hMainMenuBox["cTitle"]  ;
    )

    FOR i := 1 TO LEN(aMenuItems)
        @ hMainMenuBox["nRow1"] + i, hMainMenuBox["nCol1"] + 2 PROMPT aMenuItems[i,01] message aMenuItems[i,02]
    NEXT
RETURN NIL

METHOD getOption() CLASS ApplicationView
    LOCAL nChoseItem := 0
    MENU TO nChoseItem
RETURN nChoseItem