/*
    System.......: Harbour MVC sample Application
    Program......: about_view.prg
    Description..: View Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS AboutView FROM View

    EXPORTED:
        METHOD Run( oModel )

END CLASS

METHOD Run( oModel ) CLASS AboutView
    LOCAL nOpc := 0, hBox := oModel:getBoxDimensions()

    ::showBox(hBox, "Sobre")

    @10,06 SAY  "------ BANCO DE DADOS ------"
    @12,06 SAY  "NOME DO BANCO DE DADOS......: " + oModel:getDataBaseName()
    @13,06 SAY  "LOCALIZACAO.................: " + oModel:getDataBaseLocation()
    @14,06 SAY  "QUANTIDADE DE CLIENTES......: " //+ ltrim(str(nQtdCliente))
    @15,06 SAY  "QUANTIDADE DE FATURAS.......: " //+ ltrim(str(nQtdFatura))
    @16,06 SAY  "VERSAO DO SQLite3...........: " //+ sqlite3_libversion()

    @19,06 SAY  "-------- SISTEMA ------------"
    @21,06 SAY  "VERSAO......................: " + oModel:getAppVersion()
    @22,06 SAY  "LOCALIZACAO DO EXECUTAVEL...: " + oModel:getAppLocation()
    @23,06 SAY  "INFORMACOES DO Harbour......: " + oModel:getHarbourVersion()
    @24,06 SAY  "COMPILADOR C................: " + oModel:getCompilerVersion()
    @25,06 SAY  "SISTEMA OPERACIONAL EM USO..: " + oModel:getOS()

    @27,06 ;
    PROMPT  "  Tecle <ENTER> para voltar "
    MENU TO nOpc

    ::clearBox(hBox)
RETURN NIL
