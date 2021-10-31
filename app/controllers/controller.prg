/*
    System.......: Harbour MVC sample Application
    Program......: controller.prg
    Description..: Controller Class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "hbclass.ch"
#include "../assets/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS Controller
    DATA Controller AS OBJECT

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD Model( oModel ) SETGET
        METHOD View( oView ) SETGET
        METHOD dispatchActions() VIRTUAL

    HIDDEN:
        DATA oModel     AS OBJECT
        DATA oView      AS OBJECT

END CLASS

//------------------------------------------------------------------
// Constructor
METHOD New( oView, oModel ) CLASS Controller
    ::View := oView
    ::Model := oModel
RETURN Self

METHOD Model( oModel ) CLASS Controller
    ::oModel := oModel IF hb_isObject(oModel)
RETURN ::oModel

METHOD View( oView ) CLASS Controller
    ::oView := oView IF hb_isObject(oView)
RETURN ::oView