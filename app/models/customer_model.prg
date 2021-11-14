/*
    System.......: Accounts Receivable Application
    Program......: customer_class.prg
    Description..: Customer Class
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
*/

#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"

CREATE CLASS CustomerModel FROM CustomerDao, Model

    EXPORTED:
		METHOD New( cConnection ) CONSTRUCTOR
        METHOD Destroy()
        METHOD Insert()
        METHOD Update( cID )
        METHOD Delete( cID )
        METHOD InsertInitialCustomer()
        METHOD BrowseDataPrepare()

    HIDDEN:
        DATA oCustomerDao   AS Object   INIT NIL
        METHOD Validation()
        METHOD InsertValidation()
        METHOD UpdateValidation()
        METHOD DeleteValidation(cID)
        METHOD SetPropsToRecordHash()

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New( cConnection ) CLASS CustomerModel
    ::oCustomerDao := ::CustomerDao:New( cConnection )
RETURN Self

METHOD Destroy() CLASS CustomerModel
    Self := NIL
RETURN Self

METHOD Insert() CLASS CustomerModel
    LOCAL oError := NIL, hRecord := { => }, cGUID := "", lValid := .F.

    TRY
        lValid := ::Validation() .AND. ::InsertValidation()
        hRecord := ::SetPropsToRecordHash(hRecord) IF lValid

        IF lValid
            cGUID := ::oCustomerDao:CustomerDao:Insert(hRecord)
            ::Message := "Cliente cadastrado com sucesso!"
            ::Valid := lValid
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN cGUID

METHOD Update(cID) CLASS CustomerModel
    LOCAL oError := NIL, hRecord := { => }, lValid := .F.

    TRY
        lValid := ::Validation() .AND. ::UpdateValidation(cID)
        hRecord := ::SetPropsToRecordHash(hRecord) IF lValid

        IF lValid
            ::oCustomerDao:CustomerDao:Update(cID, hRecord)
            ::Message := "Cliente alterado com sucesso!"
            ::Valid := lValid
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Delete(cID) CLASS CustomerModel
    LOCAL oError := NIL

    TRY
        IF ::DeleteValidation(cID)
            ::oCustomerDao:CustomerDao:Delete(cID)
            ::Message := "Cliente excluido com sucesso!"
            ::Valid := .T.
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD Validation() CLASS CustomerModel
    LOCAL oError := NIL, nI := 0, lCondition := .F., nConditions := 0, lValid := .F.
    LOCAL aValidation := { ;
            { {|| Empty(::CustomerName)}    , "Nome do Cliente nao informado!"}, ;
            { {|| Empty(::BirthDate)}       , "Data de Nascimento do Cliente nao informada!"}, ;
            { {|| Empty(::GenderId)}        , "Genero do Cliente nao informado!"} ;
        }

    TRY
        nConditions := Len(aValidation)
        Repeat
            ::Message := aValidation[nI][2] IF (lCondition := Eval(aValidation[++nI][1]))
        Until nI >= nConditions .OR. lCondition
        lValid := !lCondition
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lValid

METHOD InsertValidation() CLASS CustomerModel
    LOCAL oError := NIL, lValid := .F., lFound := .F.

    TRY
        lFound := ::SimpleSearch( ::cSqlFindByCustomerName, { "#CUSTOMER_NAME" => ::CustomerName } )
        ::Message := "Cliente ja cadastrado com este nome!" IF lFound
        lValid := !lFound
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lValid

METHOD UpdateValidation(cID) CLASS CustomerModel
    LOCAL oError := NIL, lValid := .F., lFound := .F.

    TRY
        IF !::SimpleSearch( ::cSqlFindById, { "#ID" => cID } )
            ::Message := "Cliente nao encontrado com Id: " + cID
        ELSE
            lFound := ::SimpleSearch( ::cSqlAvoidDup, { "#ID" => cID, "#CUSTOMER_NAME" => ::CustomerName } )
            ::Message := "Cliente ja cadastrado com este nome!" IF lFound
            lValid := !lFound
        ENDIF
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lValid

METHOD DeleteValidation(cID) CLASS CustomerModel
    LOCAL oError := NIL, lValid := .F., lFound := .F.

    TRY
        lFound := ::SimpleSearch( ::cSqlFindById, { "#ID" => cID } )
        ::Message := "Cliente nao encontrado com Id: " + cID UNLESS lFound
        lValid := lFound
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN lValid

METHOD SetPropsToRecordHash(hRecord) CLASS CustomerModel
    hRecord := { ;
        "#ID"                           =>  ::Id, ;
        "#CUSTOMER_NAME"                =>  ::CustomerName, ;
        "#BIRTH_DATE"                   =>  ::BirthDate, ;
        "#GENDER_ID"                    =>  ::GenderId, ;
        "#ADDRESS_DESCRIPTION"          =>  ::AddressDescription, ;
        "#COUNTRY_CODE_PHONE_NUMBER"    =>  ::CountryCodePhoneNumber, ;
        "#AREA_PHONE_NUMBER"            =>  ::AreaPhoneNumber, ;
        "#PHONE_NUMBER"                 =>  ::PhoneNumber, ;
        "#CUSTOMER_EMAIL"               =>  ::CustomerEmail, ;
        "#DOCUMENT_NUMBER"              =>  ::DocumentNumber, ;
        "#ZIP_CODE_NUMBER"              =>  ::ZipCodeNumber, ;
        "#CITY_NAME"                    =>  ::CityName, ;
        "#CITY_STATE_INITIALS"          =>  ::CityStateInitials ;
    }
RETURN hRecord

METHOD InsertInitialCustomer() CLASS CustomerModel
    LOCAL oError := NIL
    LOCAL oGender := GenderModel():New( ::getDBPathDBName() )
    TRY
        oGender:FindFirst()
        oGender:FeedProperties()
        WITH OBJECT Self
            :CustomerName := "JOAO DA SILVA."
            :BirthDate := "22/01/1980"
            :GenderId := "816b80c0-184d-4c1e-917f-bd2c928a74a7"
            :AddressDescription := "5th AV, 505"
            :CountryCodePhoneNumber := "55"
            :AreaPhoneNumber := "11"
            :PhoneNumber := "555-55555"
            :CustomerEmail := "nome-cliente@mail.com"
            :DocumentNumber := "99876999-99"
            :ZipCodeNumber := "04058-000"
            :CityName := "Sao Paulo"
            :CityStateInitials := "SP"
        ENDWITH
        ::Insert()
        ::ResetProperties()
    CATCH oError
        ::oCustomerDao:CustomerDao:Error := oError
    ENDTRY
RETURN NIL

METHOD BrowseDataPrepare() CLASS CustomerModel
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
                    ahColValues[i]["CUSTOMER_NAME"], ;
                    ahColValues[i]["BIRTH_DATE"] ,   ;
                    ahColValues[i]["GENDER_ID"], ;
                    ahColValues[i]["ADDRESS_DESCRIPTION"], ;
                    ahColValues[i]["COUNTRY_CODE_PHONE_NUMBER"], ;
                    ahColValues[i]["AREA_PHONE_NUMBER"], ;
                    ahColValues[i]["PHONE_NUMBER"], ;
                    ahColValues[i]["CUSTOMER_EMAIL"], ;
                    ahColValues[i]["DOCUMENT_NUMBER"], ;
                    ahColValues[i]["ZIP_CODE_NUMBER"], ;
                    ahColValues[i]["CITY_NAME"], ;
                    ahColValues[i]["CITY_STATE_INITIALS"], ;
                    ahColValues[i]["CREATED_AT"], ;
                    ahColValues[i]["UPDATED_AT"] ;
                } ;
            )
    NEXT

    oBrowseData := BrowseData():New( ::getBoxDimensions() )
    oBrowseData:Title := "Clientes"
    oBrowseData:ColHeadings := {"Id", "Nome Cliente", "Data Nasc" , ;
                                "Genero", "Endereco", "DDI", "DDD", "Telefone", ;
                                "Email", "Documento", "CEP",;
                                "Cidade", "Estado", "Registro em", "Alterado em"}
    oBrowseData:ColValues := { aColValues, 1 }
    oBrowseData:ColWidths := {  00, 40 , 10, ;
                                10, 40, 02, 03, 10, ;
                                40, 20, 09, ;
                                20, 02, 23, 23  }
    oBrowseData:NumOfRecords := nNumberOfRecords
RETURN oBrowseData

METHOD ONERROR( xParam ) CLASS CustomerModel
    LOCAL xResult := NIL
    xResult := Error():New():getOnErrorMessage( Self, xParam, __GetMessage() )
    ? "*** Error => ", xResult
RETURN xResult

/*METHOD ONERROR( xParam ) CLASS CustomerModel
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
RETURN xResult*/