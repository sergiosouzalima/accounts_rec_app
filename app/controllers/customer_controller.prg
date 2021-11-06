/*
    System.......: Harbour MVC sample Application
    Program......: customer_controller.prg
    Description..: CustomerController Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "inkey.ch"
#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

// Browse commands
#define K_m 109 //  Modify
#define K_M 77  //  Modify
#define K_D 100 //  Delete
#define K_d 68  //  Delete
#define K_I 73  //  Insert
#define K_i 105 //  Insert

//------------------------------------------------------------------
CLASS CustomerController FROM Controller

    EXPORTED:
        METHOD New() CONSTRUCTOR
        METHOD getModel( oModel ) SETGET
        METHOD getView( oView ) SETGET
        METHOD dispatchActions() VIRTUAL
        METHOD getDispatchActions( oModel )

    HIDDEN:
        DATA oModel     AS OBJECT
        DATA oView      AS OBJECT

END CLASS

//------------------------------------------------------------------
// Constructor
METHOD New( oView, oModel ) CLASS CustomerController
    ::getView := oView
    ::getModel := oModel
RETURN Self

METHOD getModel( oModel ) CLASS CustomerController
    ::oModel := oModel IF hb_isObject(oModel)
RETURN ::oModel

METHOD getView( oView ) CLASS CustomerController
    ::oView := oView IF hb_isObject(oView)
RETURN ::oView

METHOD getDispatchActions() CLASS CustomerController
    LOCAL nChosenItem := 0, oCustomer := NIL

    oCustomer := Customer():New( ::getModel:getDBPathDBName() )
    oCustomer:CreateTable()
    oCustomer:CountAll()
    oCustomer:FeedProperties()
    hb_Alert("table empty") IF oCustomer:NumberOfRecords == 0

    Repeat
        ::getView:showCustomerBrowserData( ::getModel )
        nChosenItem := ::getView:getOption()

        // switch....
        switch nChosenItem
            case 1
                //::runAbout()
                //exit
            case 2
                //::runCustomer()
                //exit
            /*otherwise
                ::vista:operacionIncorrecta()*/
        end switch
    Until nChosenItem == K_ESC
    oCustomer := oCustomer:Destroy()
RETURN NIL