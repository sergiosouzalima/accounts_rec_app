/*
    System.......: Harbour MVC sample Application
    Program......: controller.prg
    Description..: Controller Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS Controller
    //DATA Controller AS OBJECT

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD getModel( oModel ) SETGET
        METHOD getView( oView ) SETGET
        METHOD dispatchActions() VIRTUAL

    HIDDEN:
        DATA oModel     AS OBJECT
        DATA oView      AS OBJECT

END CLASS

//------------------------------------------------------------------
// Constructor
METHOD New( oView, oModel ) CLASS Controller
    ::getView := oView
    ::getModel := oModel
RETURN Self

METHOD getModel( oModel ) CLASS Controller
    ::oModel := oModel IF hb_isObject(oModel)
RETURN ::oModel

METHOD getView( oView ) CLASS Controller
    ::oView := oView IF hb_isObject(oView)
RETURN ::oView