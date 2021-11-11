/*
    System.......: Accounts Receivable Application
    Program......: gender_class.prg
    Description..: Gender Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"

CREATE CLASS GenderModel INHERIT GenderDao, Model

    EXPORTED:
		METHOD New( cConnection ) CONSTRUCTOR
        METHOD GenderDescription( cGenderDescription ) SETGET
        METHOD Destroy()
        METHOD Insert()
        METHOD Update( cID )
        METHOD Delete( cID )
        METHOD FeedProperties( ahRecordSet )
        METHOD ResetProperties()
        METHOD InsertFakeGender()
        METHOD BrowseDataPrepare()

    HIDDEN:
        DATA cGenderDescription         AS STRING   INIT ""
        DATA oGenderDao                 AS Object   INIT NIL
        METHOD Validation()
        METHOD InsertValidation()
        METHOD UpdateValidation()
        METHOD DeleteValidation(cID)
        METHOD SetPropsToRecordhHash()

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS GenderModel
    ::oGenderDao := ::GenderDao:New( cConnection )
RETURN Self

METHOD Destroy() CLASS GenderModel
    Self := NIL
RETURN Self

METHOD GenderDescription( cGenderDescription ) CLASS GenderModel
    ::cGenderDescription := cGenderDescription IF hb_IsString(cGenderDescription)
RETURN ::cGenderDescription

METHOD Insert() CLASS GenderModel
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::InsertValidation() IF ::Valid
        hRecord := ::SetPropsToRecordhHash(hRecord) IF ::Valid

        IF ::Valid
            ::oGenderDao:GenderDao:Insert(hRecord)
            ::Message := "Genero cadastrado com sucesso!"
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Update(cID) CLASS GenderModel
    LOCAL oError := NIL, hRecord := { => }

    TRY
        ::Validation()
        ::UpdateValidation(cID) IF ::Valid
        hRecord := ::SetPropsToRecordhHash(hRecord) IF ::Valid

        IF ::Valid
            ::oGenderDao:GenderDao:Update(cID, hRecord)
            ::Message := "Genero alterado com sucesso!"
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Delete(cID) CLASS GenderModel
    LOCAL oError := NIL

    TRY
        ::DeleteValidation(cID)

        IF ::Valid
            ::oGenderDao:GenderDao:Delete(cID)
            ::Message := "Genero excluido com sucesso!"
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Validation() CLASS GenderModel
    LOCAL oError := NIL, nI := 0, lCondition := .F., nConditions := 0
    LOCAL aValidation := { ;
            { {|| Empty(::GenderDescription)}    , "Descricao do Genero nao informada!"} ;
        }

    TRY
        ::Valid := .F.
        nConditions := Len(aValidation)

        Repeat
            ::Message := aValidation[nI][2] IF (lCondition := Eval(aValidation[++nI][1]))
        Until nI >= nConditions .OR. lCondition

        ::Valid := !lCondition
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD InsertValidation() CLASS GenderModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.
        ::oGenderDao:GenderDao:FindByGenderDescription( ::GenderDescription )
        IF ::oGenderDao:GenderDao:Found()
            ::Message := "Genero ja cadastrado com esta descricao!"
        ELSE
            ::Valid := .T.
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD UpdateValidation(cID) CLASS GenderModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.

        ::oGenderDao:GenderDao:FindById( cID )
        IF ::oGenderDao:GenderDao:NotFound()
            ::Message := "Genero nao encontrado com Id: " + cID
        ELSE
            ::oGenderDao:GenderDao:FindGenderAvoidDup( cID, ::GenderDescription )
            IF ::oGenderDao:GenderDao:Found()
                ::Message := "Genero ja cadastrado com esta descricao!"
            ELSE
                ::Valid := .T.
            ENDIF
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD DeleteValidation(cID) CLASS GenderModel
    LOCAL oError := NIL

    TRY
        ::Valid := .F.

        ::oGenderDao:GenderDao:FindById( cID )
        IF ::oGenderDao:GenderDao:NotFound()
            ::Message := "Genero nao encontrado com Id: " + cID
        ELSE
            ::Valid := .T.
        ENDIF
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD SetPropsToRecordhHash(hRecord) CLASS GenderModel
    hRecord := { ;
        "#ID"                           =>  ::Id, ;
        "#GENDER_DESCRIPTION"           =>  ::GenderDescription ;
    }
RETURN hRecord

METHOD ResetProperties() CLASS GenderModel
    LOCAL oError := NIL

    TRY
        ::Id                    := ""
        ::GenderDescription     := ""
        ::CreatedAt             := ""
        ::UpdatedAt             := ""
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD FeedProperties() CLASS GenderModel
    LOCAL oError := NIL
    LOCAL ahRecordSet := NIL, oUtilities := Utilities():New()

    RETURN .F. IF ::oGenderDao:GenderDao:NotFound()

    TRY
        ahRecordSet := ::oGenderDao:GenderDao:RecordSet[01]
        ::Id                    := oUtilities:getStringValueFromHash (ahRecordSet, "ID")
        ::GenderDescription     := oUtilities:getStringValueFromHash (ahRecordSet, "GENDER_DESCRIPTION")
        ::CreatedAt             := oUtilities:getStringValueFromHash (ahRecordSet, "CREATED_AT")
        ::UpdatedAt             := oUtilities:getStringValueFromHash (ahRecordSet, "UPDATED_AT")
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD InsertFakeGender() CLASS GenderModel
    LOCAL oError := NIL
    TRY
        WITH OBJECT Self
            :GenderDescription := "MASCULINO"
        ENDWITH
        ::Insert()
        ::ResetProperties()
    CATCH oError
        ::oGenderDao:GenderDao:Error := oError
    ENDTRY
RETURN NIL

METHOD BrowseDataPrepare() CLASS GenderModel
    LOCAL oBrowseData := NIL, nNumberOfRecords := 0
    LOCAL aColValues := {}, ahColValues := { => }
    LOCAL nCols := 0, i

    nNumberOfRecords := ::CountAll()

    ::FindAll()
    ::FeedProperties()

    ahColValues := ::RecordSet
    nCols := Len(ahColValues)

    FOR i := 1 TO nCols
        AADD( aColValues, { ;
                    ahColValues[i]["ID"], ;
                    ahColValues[i]["GENDER_DESCRIPTION"], ;
                    ahColValues[i]["CREATED_AT"], ;
                    ahColValues[i]["UPDATED_AT"] ;
                } ;
            )
    NEXT

    oBrowseData := BrowseData():New( ::getBoxDimensions() )
    oBrowseData:Title := "Generos"
    oBrowseData:ColHeadings := {"Id", "Descricao Genero", "Registro em", "Alterado em"}
    oBrowseData:ColValues := { aColValues, 1 }
    oBrowseData:ColWidths := {  00, 30, 23, 23  }
    oBrowseData:NumOfRecords := nNumberOfRecords
RETURN oBrowseData

METHOD ONERROR( xParam ) CLASS GenderModel
    LOCAL cCol := __GetMessage(), xResult

    IF Left( cCol, 1 ) == "_" // underscore means it's a variable
       cCol = Right( cCol, Len( cCol ) - 1 )
       IF ! __objHasData( Self, cCol )
          __objAddData( Self, cCol )
       ENDIF
       IF xParam == NIL
          xResult = __ObjSendMsg( Self, cCol )
       ELSE
          xResult = __ObjSendMsg( Self, "_" + cCol, xParam )
       ENDIF
    ELSE
       xResult := "Method not created " + cCol
    ENDIF
    ? "*** Error => ", xResult
RETURN xResult