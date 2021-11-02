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
        METHOD  getDispatchActions(oModel)

    HIDDEN:
        METHOD  runCustomer()

END CLASS

METHOD runCustomer() CLASS ApplicationController
    //LOCAL oView := CustomerView():New()
    //LOCAL oModel := CustomerModel():New()
    //LOCAL oController := CustomerController():New( oView, oModel )

    //oController::Run()
    BrowseData():New():Run()
RETURN NIL

METHOD getDispatchActions( oModel ) CLASS ApplicationController
    LOCAL nChosenItem := 0

    Repeat
        ::View:showMainMenu( oModel:hMainMenuBox, oModel:aMainMenuItems )
        nChosenItem := ::View:getOption()

        // switch....
        switch nChosenItem
            case 4
                ::View:showAbout( oModel:hAboutBox, oModel:cAppVersion )
                exit
            case 2
                ::runCustomer()
                exit

           /* case '3'
                ::vista:acercaDe()
                exit

            otherwise
                ::vista:operacionIncorrecta()*/
        end switch
    Until nChosenItem == 5
RETURN NIL