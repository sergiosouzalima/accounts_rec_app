/*
    System.......:
    Program......: browse_data.prg
    Description..: Browse Data Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

REQUEST HB_CODEPAGE_PTISO
REQUEST HB_LANG_PT

#define COLUMN_SEP " "+CHR(179)+" "
#define FOOT_SEP CHR(196)+CHR(193)+CHR(196)
#define HEAD_SEP CHR(196)+CHR(194)+CHR(196)

#xtrans  :data   =>   :cargo\[1]
#xtrans  :recno  =>   :cargo\[2]

#include "box.ch"
#include "inkey.ch"
#include "hbclass.ch"
#include "setcurs.ch"
#include "tbrowse.ch"
#include "../app/assets/custom_commands_v1.0.0.ch"

// Browse commands
#define K_a 97
#define K_A 65
#define K_E 69
#define K_e 101
#define K_I 73
#define K_i 105

//------------------------------------------------------------------
CLASS BrowseData

    EXPORTED:
        DATA nRow1                      AS  INTEGER INIT    08
        DATA nCol1                      AS  INTEGER INIT    03
        DATA nRow2                      AS  INTEGER INIT    MaxRow()-2
        DATA nCol2                      AS  INTEGER INIT    MaxCol()-2
        DATA cTitle                     AS  STRING  INIT    "Browse Data"
        DATA aColHeadings               AS  ARRAY   INIT    {"Id", "Message"}
        DATA aColValues                 AS  ARRAY   INIT    {{{1, "No data found"}}, 1}
        DATA aColWidths                 AS  ARRAY   INIT    {10, 30}
        DATA nNumOfRecords              AS  INTEGER INIT    1
        DATA cFooterMsg                 AS  STRING  INIT    "<ESC>-Exit"
        DATA aAvailableKeys             AS  ARRAY   INIT    {K_ESC}
        DATA lLookup                    AS  LOGICAL INIT    .F.
        DATA nKeyPressed                AS  INTEGER INIT    0
        DATA nSelectedRecord            AS  INTEGER INIT    0
        METHOD New() CONSTRUCTOR
        METHOD Run()
        METHOD Destroy()
        METHOD Row1( nRow1 ) SETGET
        METHOD Col1( nCol1 ) SETGET
        METHOD Row2( nRow2 ) SETGET
        METHOD Col2( nCol2 ) SETGET
        METHOD Title( cTitle ) SETGET
        METHOD ColHeadings( aColHeadings ) SETGET
        METHOD ColValues( aColValues ) SETGET
        METHOD ColWidths( aColWidths ) SETGET
        METHOD NumOfRecords( nNumOfRecords ) SETGET
        METHOD FooterMsg( cFooterMsg ) SETGET
        METHOD AvailableKeys( aAvailableKeys ) SETGET
        METHOD Lookup( lLookup ) SETGET
        METHOD KeyPressed( nKeyPressed ) SETGET
        METHOD SelectedRecord( nSelectedRecord ) SETGET

    HIDDEN:
        DATA oTBrowse   AS  OBJECT  INIT    NIL
        METHOD ArraySkipper( nSkipRequest, oTBrowse )
        METHOD ArrayBlock( oTBrowse, nSubScript )

        //ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New() CLASS BrowseData
    LOCAL i, bBlock, oTBrowse, oTBColumn
    LOCAL nHeadings := Len( ::ColHeadings )

    HB_CDPSELECT( 'PTISO' )
    HB_LANGSELECT( 'PT' )

    oTBrowse := TBrowse():New( ::Row1, ::Col1, ::Row2, ::Col2 )

    oTBrowse:cargo      := ::ColValues
    oTBrowse:border     := B_SINGLE
    oTBrowse:headSep    := HEAD_SEP
    oTBrowse:colSep     := COLUMN_SEP
    oTBrowse:footSep    := FOOT_SEP
    //oTBrowse:colorSpec  := "W/N" //"W/B, W+/N, N/W*, W+/R,  R+/B, R/W*"
    oTBrowse:colorSpec  := "W+/B, N/BG" // "W/N"

    // Navigation code blocks for array
    oTBrowse:goTopBlock    := {|| oTBrowse:recno := 1 }
    oTBrowse:goBottomBlock := {|| oTBrowse:recno := Len( oTBrowse:data ) }
    oTBrowse:skipBlock     := {|nSkip| ::ArraySkipper( nSkip, oTBrowse ) }

    // create TBColumn objects and add them to TBrowse object
    FOR i:=1 TO nHeadings
       // code block for individual columns of the array
       bBlock    := ::ArrayBlock( oTBrowse, i )
       oTBColumn := TBColumn():new( ::ColHeadings[i], bBlock )
       oTBColumn:width := ::ColWidths[i]
       oTBrowse:addColumn( oTBColumn )
    NEXT
    ::oTBrowse := oTBrowse
RETURN Self

METHOD Run() CLASS BrowseData
    LOCAL oTBrowse := ::oTBrowse
    LOCAL nKey := 0, nSelectedRecord := 0

    // display browser and process user input
    Repeat
        oTBrowse:forceStable()
        nKey := Inkey(0)
        nSelectedRecord := Eval( oTBrowse:getColumn( 1 ):block )
    Until oTBrowse:applyKey( nKey ) == TBR_EXIT .OR. hb_AScan( ::AvailableKeys, nKey ) > 0
    ::KeyPressed        := nKey
    ::SelectedRecord    := nSelectedRecord
RETURN NIL

METHOD Destroy() CLASS BrowseData
    Self := NIL
RETURN Self

METHOD Row1( nRow1 ) CLASS BrowseData
    ::nRow1 := nRow1 IF hb_IsNumeric(nRow1)
RETURN ::nRow1

METHOD Col1( nCol1 ) CLASS BrowseData
    ::nCol1 := nCol1 IF hb_IsNumeric(nCol1)
RETURN ::nCol1

METHOD Row2( nRow2 ) CLASS BrowseData
    ::nRow2 := nRow2 IF hb_IsNumeric(nRow2)
RETURN ::nRow2

METHOD Col2( nCol2 ) CLASS BrowseData
    ::nCol2 := nCol2 IF hb_IsNumeric(nCol2)
RETURN ::nCol2

METHOD Title( cTitle ) CLASS BrowseData
    ::cTitle := cTitle IF hb_IsString(cTitle)
RETURN ::cTitle

METHOD ColHeadings( aColHeadings ) CLASS BrowseData
    ::aColHeadings := aColHeadings IF hb_IsArray(aColHeadings)
RETURN ::aColHeadings

METHOD ColValues( aColValues ) CLASS BrowseData
    ::aColValues := aColValues IF hb_IsArray(aColValues)
RETURN ::aColValues

METHOD ColWidths( aColWidths ) CLASS BrowseData
    ::aColWidths := aColWidths IF hb_IsArray(aColWidths)
RETURN ::aColWidths

METHOD NumOfRecords( nNumOfRecords ) CLASS BrowseData
    ::nNumOfRecords := nNumOfRecords IF hb_IsNumeric(nNumOfRecords)
RETURN ::nNumOfRecords

METHOD FooterMsg( cFooterMsg ) CLASS BrowseData
    ::cFooterMsg := cFooterMsg IF hb_IsString(cFooterMsg)
RETURN ::cFooterMsg

METHOD AvailableKeys( aAvailableKeys ) CLASS BrowseData
    ::aAvailableKeys := aAvailableKeys IF hb_IsArray(aAvailableKeys)
RETURN ::aAvailableKeys

METHOD Lookup( lLookup ) CLASS BrowseData
    ::lLookup := lLookup IF hb_IsLogical(lLookup)
RETURN ::lLookup

METHOD KeyPressed( nKeyPressed ) CLASS BrowseData
    ::nKeyPressed := nKeyPressed IF hb_IsNumeric(nKeyPressed)
RETURN ::nKeyPressed

METHOD SelectedRecord( nSelectedRecord ) CLASS BrowseData
    ::nSelectedRecord := nSelectedRecord IF hb_IsNumeric(nSelectedRecord)
RETURN ::nSelectedRecord

// This code block uses detached LOCAL variables to
// access single elements of a two-dimensional array.
METHOD ArrayBlock( oTBrowse, nSubScript ) CLASS BrowseData
RETURN {|| oTBrowse:data[ oTBrowse:recno, nSubScript ] }

// This function navigates the row pointer of the
// the data source (array)
METHOD ArraySkipper( nSkipRequest, oTBrowse ) CLASS BrowseData
   LOCAL nSkipped
   LOCAL nLastRec := Len( oTBrowse:data ) // Length of array

   IF oTBrowse:recno + nSkipRequest < 1
      // skip requested that navigates past first array element
      nSkipped := 1 - oTBrowse:recno
   ELSEIF oTBrowse:recno + nSkipRequest > nLastRec
      // skip requested that navigates past last array element
      nSkipped := nLastRec - oTBrowse:recno
   ELSE
      // skip requested that navigates within array
      nSkipped := nSkipRequest
   ENDIF
   // adjust row pointer
   oTBrowse:recno += nSkipped
// tell TBrowse how many rows are actually skipped.
RETURN nSkipped