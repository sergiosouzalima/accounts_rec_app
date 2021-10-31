/*
    System.......: Harbour MVC sample Application
    Program......: application_controller.prg
    Description..: Application Controller Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationController FROM Controller

    EXPORTED:
        METHOD getDispatchActions()

END CLASS

METHOD getDispatchActions() CLASS ApplicationController
    LOCAL nChosenItem := 0

    Repeat
        ::View:showMainMenu( ::Model:aMenuItems, ::Model:hMenuScreenPos, ::Model:nMaxRow, ::Model:nMaxCol )
        nChosenItem := ::View:getOption()

        // switch....
        switch nChosenItem

            case 4
                ::View:showAbout( ::Model:hMainBoxPos, ::Model:cAppVersion )
                exit
            /*case '2'
                ::vista:setTipoConversion( cTipo )
                ::gestionDeTipoConversion()
                exit

            case '3'
                ::vista:acercaDe()
                exit

            otherwise
                ::vista:operacionIncorrecta()*/
        end switch
    Until nChosenItem == 5


RETURN NIL