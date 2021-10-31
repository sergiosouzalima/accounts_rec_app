/*
    System.......: Harbour MVC sample Application
    Program......: application_view.prg
    Description..: View Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationView FROM View

    EXPORTED:
        METHOD showMainMenu( aMenuItems, hMenuScreenPos )
        METHOD getOption()
        METHOD showAbout( hMainBoxPos )

    HIDDEN:
        METHOD showMainMenuBox(aMenu, nInitialRow, nInitialCol)

END CLASS

METHOD showMainMenu( aMenuItems, hMenuScreenPos, nMaxRow, nMaxCol ) CLASS ApplicationView
    LOCAL i, aMenu := aMenuItems
    LOCAL nInitialRow := hMenuScreenPos["nRow"], nInitialCol := hMenuScreenPos["nCol"]

    @nInitialRow - 02, nInitialCol - 04 clear to nMaxRow, nMaxCol - 03

    ::showMainMenuBox(aMenu, nInitialRow, nInitialCol)

    FOR i := 1 TO LEN(aMenu)
        @ nInitialRow + i, nInitialCol PROMPT aMenu[i,01] message aMenu[i,02]
    NEXT
RETURN NIL

METHOD showMainMenuBox(aMenu, nInitialRow, nInitialCol) CLASS ApplicationView
    LOCAL nTamMenu := LEN(aMenu)
    LOCAL nFinalRow := nInitialRow + nTamMenu + 2
    LOCAL nFinalCol := 04 + LEN(aMenu[01,01]) + 04

    ::showBox(nInitialRow - 01, nInitialCol - 03, nFinalRow, nFinalCol, "Main")

    //@nInitialRow - 01, nInitialCol - 03 TO nFinalRow, nFinalCol DOUBLE
    //@nInitialRow - 01, nInitialCol SAY "[ Main ]"
RETURN NIL

METHOD getOption() CLASS ApplicationView
    LOCAL nChoseItem := 0
    MENU TO nChoseItem
RETURN nChoseItem

METHOD showAbout( hMainBoxPos, cAppName ) CLASS ApplicationView
    LOCAL nOpc := 0

    /*hb_DispBox( ;
        hMainBoxPos["nRow1"], hMainBoxPos["nCol1"],   ;
        hMainBoxPos["nRow2"], hMainBoxPos["nCol2"] - 03,   ;
        hb_UTF8ToStrBox( hMainBoxPos["cChars"] )         ;
    )*/
    ::showBox(hMainBoxPos["nRow1"], hMainBoxPos["nCol1"], hMainBoxPos["nRow2"], hMainBoxPos["nCol2"] - 03, "Sobre")


    @10,06 SAY  "------ BANCO DE DADOS ------"
    @12,06 SAY  "NOME DO BANCO DE DADOS......: " //+ BD_CONTAS_RECEBER
    @13,06 SAY  "LOCALIZACAO.................: " //+ if(lFileExists, cCurrentFolder, BD_CONTAS_RECEBER + " nao encontrado")
    @14,06 SAY  "QUANTIDADE DE CLIENTES......: " //+ ltrim(str(nQtdCliente))
    @15,06 SAY  "QUANTIDADE DE FATURAS.......: " //+ ltrim(str(nQtdFatura))
    @16,06 SAY  "VERSAO DO SQLite3...........: " //+ sqlite3_libversion()

    @19,06 SAY  "-------- SISTEMA ------------"
    @21,06 SAY  "VERSAO......................: " + cAppName
    @22,06 SAY  "LOCALIZACAO DO EXECUTAVEL...: " //+ cCurrentFolder
    @23,06 SAY  "INFORMACOES DO Harbour......: " //+ StrSwap2( cHabourInfo, hHabourInfo )
    @24,06 SAY  "COMPILADOR C................: " //+ hb_Version( HB_VERSION_COMPILER )
    @25,06 SAY  "SISTEMA OPERACIONAL EM USO..: " + OS()

    @27,06 ;
    PROMPT  "  Tecle <ENTER> para voltar "
    MENU TO nOpc
RETURN NIL