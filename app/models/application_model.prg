/*
    System.......: Harbour MVC sample Application
    Program......: application_model.prg
    Description..: Application Model Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationModel FROM Model

    EXPORTED:
        DATA hMainMenuBox       AS  HASH    INIT    {;
        "cTitle" => "Menu", ;
        "nRow1" => 08, "nCol1" => 03        ,   ;
        "nRow2" => 14 ,"nCol2" => 20            ;
        }
        DATA aMainMenuItems     AS  ARRAY   INIT {;
            {"1 - FATURA    ",  "    MANUTENCAO DE FATURAS     "    },;
            {"2 - CLIENTE   ",  "   MANUTENCAO DE CLIENTES     "    },;
            {"3 - CONSULTA  ",  "CONSULTA DE FATURAS E CLIENTES"    },;
            {"4 - SOBRE     ",  " INFORMACOES SOBRE O SISTEMA  "    },;
            {"5 - FIM       ",  "RETORNA AO SISTEMA OPERACIONAL"    }}

        METHOD DBPrepare(cConnection)
        METHOD MainBox()
END CLASS

METHOD DBPrepare( cConnection ) CLASS ApplicationModel
    LOCAL oPersistence := PersistenceDao():New(cConnection)
    oPersistence := oPersistence:Destroy()
RETURN NIL

METHOD MainBox() CLASS ApplicationModel
    LOCAL hMainBox := {;
        "nRow1" => 08, "nCol1" => 03    ,   ;
        "nRow2" => ::Super:nMaxRow      ,   ;
        "nCol2" => ::Super:nMaxCol          ;
        }
RETURN hMainBox
