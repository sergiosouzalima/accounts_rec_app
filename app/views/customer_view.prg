/*
    System.......: Harbour MVC sample Application
    Program......: customer_view.prg
    Description..: Customer View Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

//------------------------------------------------------------------
CREATE CLASS CustomerView INHERIT View

    EXPORTED:
        METHOD showCustomerBrowseData( hBox, oBrowseData )
        METHOD getOption( nOption ) SETGET
        METHOD getSelectedRecord( nSelectedRecord ) SETGET

    HIDDEN:
        DATA nOption            AS INTEGER  INIT 0
        DATA nSelectedRecord    AS INTEGER  INIT 0

END CLASS

METHOD showCustomerBrowseData( hBox, oBrowseData ) CLASS CustomerView
    ::clearBox(hBox)

    WITH OBJECT oBrowseData
        :Run()
        ::getOption := :nKeyPressed
        ::getSelectedRecord := :nSelectedRecord
    ENDWITH

    ::clearBox(hBox)
RETURN NIL

METHOD getOption( nOption ) CLASS CustomerView
    ::nOption := nOption IF hb_isNumeric(nOption)
RETURN ::nOption

METHOD getSelectedRecord( nSelectedRecord ) CLASS CustomerView
    ::nSelectedRecord := nSelectedRecord IF hb_isNumeric(nSelectedRecord)
RETURN ::nSelectedRecord