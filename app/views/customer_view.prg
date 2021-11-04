/*
    System.......: Harbour MVC sample Application
    Program......: customer_view.prg
    Description..: Customer View Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "../../lib/custom_commands_v1.0.0.ch"

//------------------------------------------------------------------
CLASS CustomerView FROM View

    EXPORTED:
        METHOD showCustomerBrowseData( oModel )
        METHOD getOption( nOption ) SETGET
        METHOD getSelectedRecord( nSelectedRecord ) SETGET

    HIDDEN:
        DATA nOption            AS INTEGER  INIT 0
        DATA nSelectedRecord    AS INTEGER  INIT 0

END CLASS

METHOD showCustomerBrowseData( oModel ) CLASS CustomerView
    LOCAL hBox := oModel:getCustomerBoxDim()
    LOCAL oBrowseData := BrowseData():New()

    //::showBox(hBox["nRow1"], hBox["nCol1"], hBox["nRow2"], hBox["nCol2"], "Sobre")

    oBrowseData:Run()
    ::getOption := oBrowseData:nKeyPressed
    ::getSelectedRecord := oBrowseData:nSelectedRecord
    oBrowseData := oBrowseData:Destroy()

    @hBox["nRow1"], hBox["nCol1"] CLEAR TO hBox["nRow2"], hBox["nCol2"]
RETURN NIL

METHOD getOption( nOption ) CLASS CustomerView
    ::nOption := nOption IF hb_isNumeric(nOption)
RETURN ::nOption

METHOD getSelectedRecord( nSelectedRecord ) CLASS CustomerView
    ::nSelectedRecord := nSelectedRecord IF hb_isNumeric(nSelectedRecord)
RETURN ::nSelectedRecord