/*
    System.......:
    Program......: custom_commands.ch
    Description..: custom commands created for Harbour Language
    Author.......: Sergio Lima
    Updated at...: Nov, 2021
    Version......: 1.1
*/


// TRY CATCH FINALLY structure
#xcommand TRY      			=> BEGIN SEQUENCE WITH {|o| break(o)}
#xcommand CATCH [<!oErr!>] 	=> RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY 			=> ALWAYS
#xcommand ENDTRY 			=> ENDSEQUENCE

/* Throw() => generate error */
#xtranslate Throw( <oErr> ) => ( Eval( ErrorBlock(), <oErr> ), Break( <oErr> ) )

// in line IF & UNLESS commands
#xcommand <Command1> [<Commandn>] IF <lCondition> => IF <lCondition> ; <Command1> [<Commandn>]; ENDIF ;
// keep this comment line between IF & UNLESS commands
#xcommand <Command1> [<Commandn>] UNLESS <lCondition> => IF !(<lCondition>) ; <Command1> [<Commandn>]; ENDIF ;

// "repeat until" repetition structure
#xcommand REPEAT => WHILE .T.
#xcommand UNTIL <lCondition> => IF <lCondition> ; EXIT; END ; ENDDO ;