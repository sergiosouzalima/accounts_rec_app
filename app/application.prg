/*
    System.......: Harbour MVC sample Application
    Program......: application.prg
    Description..: Application Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

//------------------------------------------------------------------
// Main Class
CLASS Application

    EXPORTED:
        DATA Controller AS OBJECT

        METHOD New() CONSTRUCTOR
        METHOD Run()
END CLASS

//------------------------------------------------------------------
// Constructor
METHOD New() CLASS Application
    LOCAL oModel := ApplicationModel():New()
    LOCAL oView := ApplicationView():New()

    ::Controller := ApplicationController():New( oView, oModel )
RETURN Self

//------------------------------------------------------------------
// Starting point
METHOD Run() CLASS Application

    Model():New:InitialSetup()

    ::Controller:getView:showMainWindow( ::Controller:getModel )
    ::Controller:dispatchActions()
    ::Controller:getView:showEnd()
RETURN NIL