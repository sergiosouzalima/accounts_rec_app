/*
    System.......: Harbour MVC sample Application
    Program......: application.prg
    Description..: Application Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "assets/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
// Main Class
CLASS Application
    DATA Controller AS OBJECT

    METHOD New() CONSTRUCTOR
    METHOD Run()

END CLASS

//------------------------------------------------------------------
// Constructor
METHOD New() CLASS Application
    LOCAL oView := ApplicationView():New()
    LOCAL oModel := ApplicationModel():New()

    ::Controller := ApplicationController():New( oView, oModel )

RETURN Self

//------------------------------------------------------------------
// Starting point
METHOD Run() CLASS Application

    ::Controller:View:showMainWindow( ::Controller:Model )
    //::Controller:View:showMainMenu()
    ::Controller:getDispatchActions( ::Controller:Model )
    //::Controller:View:showMenu( ::Controller:Model )
    ::Controller:View:showEnd()
    //::Controller:dispatchActions()

RETURN NIL