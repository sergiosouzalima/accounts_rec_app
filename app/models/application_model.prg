/*
    System.......: Harbour MVC sample Application
    Program......: application_model.prg
    Description..: Application Model Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationModel FROM Model

    EXPORTED:
        DATA hMenuScreenPos     AS HASH     INIT {"nRow" => 09, "nCol" => 07}

        DATA hMainMenuBox       AS  HASH    INIT    {;
        "cTitle" => "Menu", ;
        "nRow1" => 08, "nCol1" => 03        ,   ;
        "nRow2" => 14 ,"nCol2" => 20            ;
        }
        DATA aMainMenuItems     AS ARRAY    INIT {;
            {"1 - FATURA    ",  "    MANUTENCAO DE FATURAS     "    },;
            {"2 - CLIENTE   ",  "   MANUTENCAO DE CLIENTES     "    },;
            {"3 - CONSULTA  ",  "CONSULTA DE FATURAS E CLIENTES"    },;
            {"4 - SOBRE     ",  " INFORMACOES SOBRE O SISTEMA  "    },;
            {"5 - FIM       ",  "RETORNA AO SISTEMA OPERACIONAL"    }}

        DATA hAboutBox          AS  HASH    INIT    {;
            "nRow1" => 08, "nCol1" => 03        ,   ;
            "nRow2" => 28 ,"nCol2" => 128           ;
            }
END CLASS