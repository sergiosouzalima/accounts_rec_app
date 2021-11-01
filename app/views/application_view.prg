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
        METHOD showMainMenu( hMainMenuBox, aMenuItems )
        METHOD getOption()
        METHOD showAbout( hAboutBox, cAppName )

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

METHOD showAbout( hAboutBox, cAppName ) CLASS ApplicationView
    LOCAL nOpc := 0

    ::showBox(hAboutBox["nRow1"], hAboutBox["nCol1"], hAboutBox["nRow2"], hAboutBox["nCol2"], "Sobre")

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

    ::clearBox(hAboutBox["nRow1"], hAboutBox["nCol1"], hAboutBox["nRow2"], hAboutBox["nCol2"])
RETURN NIL