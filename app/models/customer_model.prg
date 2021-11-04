/*
    System.......: Harbour MVC sample Customer
    Program......: customer_model.prg
    Description..: Customer Model Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS CustomerModel FROM Model

    EXPORTED:
        METHOD getCustomerBoxDim()

END CLASS

METHOD getCustomerBoxDim() CLASS CustomerModel
RETURN ::getBoxDim()