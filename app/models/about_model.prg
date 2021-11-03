/*
    System.......: Harbour MVC sample About
    Program......: about_model.prg
    Description..: About Model Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS AboutModel FROM Model

    EXPORTED:
        METHOD getAboutBoxDim()
        METHOD getDataBaseLocation()

END CLASS

METHOD getAboutBoxDim() CLASS AboutModel
RETURN ::getBoxDim()

METHOD getDataBaseLocation() CLASS AboutModel
RETURN iif(File(::getDataBaseName()), CurDir() , "not found")