/*
    System.......: Harbour MVC sample About
    Program......: about_model.prg
    Description..: About Model Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

//------------------------------------------------------------------
CREATE CLASS AboutModel FROM Model

    EXPORTED:
        METHOD getDataBaseLocation()
        METHOD getCustomerNumberOfRecords()

END CLASS

METHOD getDataBaseLocation() CLASS AboutModel
    LOCAL cDBPathDBName := ::getDBPathDBName()
RETURN iif(File(cDBPathDBName), cDBPathDBName , "not found")

METHOD getCustomerNumberOfRecords()
    LOCAL oCustomer := CustomerModel():New( ::getDBPathDBName() )
RETURN oCustomer:CountAll()