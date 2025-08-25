%{

#include "Tree.h"


%}

%union {
    int num;    /* para INT */
    char* id;   /* para ID */
    struct Tree* node;  /* para expresiones */
}

/* Palabras Reservadas*/
%token MAIN BOOL VOID RETURN IF ELSE WHILE T_INT T_BOOL T_VOID

%token <num> INT /* Números enteros */

/* Constantes Booleanas */
%token <num> TRUE FALSE

/* Operadores */
%token OR AND EQ NEQ 

/* Numeros e identificadores */
%token <num> NUM
%token <id>ID

/* ==== No terminales con tipo ==== */
%type <node> E T 

/* ==== Bloques, sentencias y declaraciones ==== */
%type <node> programa resto args parameters bloque lista_sentencias sentencia declaracion asignacion

/* ==== Precedencia y asociatividad ==== */

%left OR
%left AND
%left EQ NEQ
%left '+' '-'
%left '*' '/'
%right '!'

%%
programa : T MAIN resto{ 
                        printf("No hay errores \n");
                        {$$ = createNode("programa", 0, $1, $3);}
                        printTree($$, 0);
                        }
        ;

resto : args bloque { $$ = createNode("resto", 0, $1, $2);};

args : '(' parameters ')' {$$ = createNode("()", 0, $2, NULL);};

parameters : declaracion
            | declaracion ',' parameters { 
                Tree *n = createNode("list", 0, $1, $3);
                $$ = n;
            } 
            | {$$ = NULL;} /* epsilon */
            ;

bloque : '{' lista_sentencias '}' {$$ = createNode("bloque", 0, $2, NULL);}
        ;
lista_sentencias : sentencia  lista_sentencias { 
                                                    if ($2 == NULL) $$ = $1; 
                                                    else {
                                                        Tree *n = createNode("list", 0, $1, $2);
                                                        $$ = n;
                                                    }
                                                }
                | {$$ = NULL;}  /* epsilon */
                ;

sentencia : declaracion ';'
          | asignacion ';'
          | RETURN E ';' {$$ = createNode("RETURN", 0, $2, NULL);}
          | RETURN ';' {$$ = createNode("RETURN", 0, NULL, NULL);}
          ;

declaracion : T ID {Tree* aux = createNode("ID", 0, NULL, NULL);
                    aux->name = $2;
                    $$ = createNode("declaracion", 0, $1, aux);
                    $$->left->name = $2; 
                  }
            | T asignacion
            ;

asignacion : ID '=' E { 
                $$ = createNode("=",0,NULL,NULL);
                $$->left = createNode("ID",0,NULL,NULL);
                $$->left->name = $1; 
                $$->right = $3; 
            }
           ;

T : T_INT { $$ = createNode("T_INT", 0, NULL, NULL); }
    | T_BOOL { $$ = createNode("T_BOOL", 0, NULL, NULL); }
    | T_VOID { $$ = createNode("T_VOID", 0, NULL, NULL); }
    ;



E   : E '+' E { $$ = createNode("+",0,$1,$3); }

    | E '*' E   { $$ = createNode("*",0,$1,$3); }

    | '(' E ')' { $$ = createNode("()",0,$2,NULL); }

    | E OR E    { $$ = createNode("OR",0,$1,$3); }

    | E AND E   { $$ = createNode("AND",0,$1,$3); }

    | '!' E { $$ = createNode("!",0,$2,NULL); }

    | ID { $$ = createNode("ID",0,NULL,NULL);
            $$->name = $1; }

    | INT { $$ = createNode("INT",$1,NULL,NULL); }

    | TRUE { $$ = createNode("TRUE",1,NULL,NULL); }

    | FALSE { $$ = createNode("FALSE",0,NULL,NULL); }
    ;
%%
