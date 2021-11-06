/*
    System.......: Harbour MVC sample About
    Program......: about_model.prg
    Description..: About Model Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS AboutModel FROM Model

    EXPORTED:
        METHOD getDataBaseLocation()

END CLASS

METHOD getDataBaseLocation() CLASS AboutModel
    LOCAL cDBPathDBName := ::getDBPathDBName()
RETURN iif(File(cDBPathDBName), cDBPathDBName , "not found")