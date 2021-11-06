/*
    System.......: Harbour MVC sample Application
    Program......: application_controller.prg
    Description..: Application Controller Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS ApplicationController FROM Controller

    EXPORTED:
        METHOD  getDispatchActions(oModel)

    HIDDEN:
        METHOD  runCustomer()
        METHOD  runAbout()

END CLASS

METHOD getDispatchActions( oModel ) CLASS ApplicationController
    LOCAL nChosenItem := 0

    Repeat
        ::getView:showMainMenu( oModel:hMainMenuBox, oModel:aMainMenuItems )
        nChosenItem := ::getView:getOption()

        // switch....
        switch nChosenItem
            case 4
                ::runAbout()
                exit
            case 2
                ::runCustomer()
                exit
            /*otherwise
                ::vista:operacionIncorrecta()*/
        end switch
    Until nChosenItem == 5
RETURN NIL

METHOD runAbout() CLASS ApplicationController
    LOCAL oModel := AboutModel():New()
    LOCAL oView := AboutView():New()
    oView:Run(oModel)
RETURN NIL

METHOD runCustomer() CLASS ApplicationController
    LOCAL oView := CustomerView():New()
    LOCAL oModel := CustomerModel():New()
    LOCAL oController := CustomerController():New( oView, oModel )

    oController:getDispatchActions()
RETURN NIL