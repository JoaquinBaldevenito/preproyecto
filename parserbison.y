%{

#include <stdlib.h>
#include <stdio.h>

%}

/* Palabras Reservadas*/
%token MAIN INT BOOL VOID RETURN IF ELSE WHILE T_INT T_BOOL T_VOID

/* Constantes Booleanas */
%token TRUE FALSE

/* Operadores */
%token OR AND EQ NEQ 

/* Numeros e identificadores */
%token NUM
%token ID

/* ==== No terminales con tipo ==== */
%type E
%type T

/* ==== Precedencia y asociatividad ==== */

%left OR
%left AND
%left EQ NEQ
%left '+'
%left '*'
%right '!'

%%
programa : T MAIN '(' ')' bloque  { printf("No hay errores \n"); }
        ;

bloque : '{' lista_sentencias '}'
        ;
lista_sentencias : sentencia  lista_sentencias
                | /* epsilon */
                ;

sentencia : declaracion ';'
          | asignacion ';'
          | RETURN E ';'
          | RETURN ';'
          ;

declaracion : T ID 
            | T asignacion
            ;

asignacion : ID '=' E
           ;

T : T_INT
    | T_BOOL
    | T_VOID
    ;



E   : E '+' E

    | E '*' E

    | '(' E ')'

    | E OR E

    | E AND E

    | '!' E

    | ID

    | INT

    | TRUE

    | FALSE 
    ;
%%
