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
CREATE CLASS CustomerController

    EXPORTED:
        METHOD New( oView, oModel ) CONSTRUCTOR
        METHOD getModel( oModel ) SETGET
        METHOD getView( oView ) SETGET
        METHOD dispatchActions()

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

METHOD dispatchActions() CLASS CustomerController
    LOCAL nChosenItem := 0
    LOCAL hBox := ::getModel:getBoxDimensions()

    ::getModel:CreateTable()
    ::getModel:InsertInitialCustomer() IF ::getModel:TableEmpty()

    Repeat

        ::getView:showCustomerBrowseData( hBox, ::getModel:BrowseDataPrepare() )
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
        //oBrowseData := oBrowseData:Destroy()
    Until nChosenItem == K_ESC
RETURN NIL