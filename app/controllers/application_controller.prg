/*
    System.......: Harbour MVC sample Application
    Program......: application_controller.prg
    Description..: Application Controller Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

CREATE CLASS ApplicationController

    EXPORTED:
        METHOD  New( oView, oModel ) CONSTRUCTOR
        METHOD  dispatchActions()
        METHOD  getModel( oModel ) SETGET
        METHOD  getView( oView ) SETGET

    HIDDEN:
        DATA    oModel     AS OBJECT
        DATA    oView      AS OBJECT
        METHOD  runCustomer()
        METHOD  runAbout()
END CLASS

METHOD New( oView, oModel ) CLASS ApplicationController
    ::getView := oView
    ::getModel := oModel
RETURN Self

METHOD getModel( oModel ) CLASS ApplicationController
    ::oModel := oModel IF hb_isObject(oModel)
RETURN ::oModel

METHOD getView( oView ) CLASS ApplicationController
    ::oView := oView IF hb_isObject(oView)
RETURN ::oView

METHOD dispatchActions() CLASS ApplicationController
    LOCAL nChosenItem := 0

    Repeat
        ::getView:showMainMenu( ::getModel:hMainMenuBox, ::getModel:aMainMenuItems )
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
    LOCAL oModel := AboutModel():New( Model():New:getDBPathDBName() )
    LOCAL oView := AboutView():New()
    oView:Run(oModel)
RETURN NIL

METHOD runCustomer() CLASS ApplicationController
    LOCAL oModel := CustomerModel():New( Model():New:getDBPathDBName() )
    LOCAL oView := CustomerView():New()
    LOCAL oController := CustomerController():New( oView, oModel )

    oController:dispatchActions()
RETURN NIL