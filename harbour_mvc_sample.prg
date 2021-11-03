/*
    System.......: Harbour MVC sample Application
    Program......: harbour_mvc_sample.prg
    Description..: Harbour MVC sample Application
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/

#include "box.ch"
#include "hbclass.ch"
#include "lib/custom_commands_v1.0.0.ch"

FUNCTION Main()
    LOCAL oApp := Application():New()

    oApp:Run()
RETURN NIL