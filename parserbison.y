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
%token OR AND EQ NEQ LE GE

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
%left EQ NEQ '<' '>' LE GE
%left '+' '-'
%left '*' '/'
%right '!'

%%
programa : T MAIN resto{ 
                        printf("No hay errores \n");
                        {$$ = createNode(NODE_PROGRAM, 0, $1, $3);}
                        printTree($$, 0);
                        }
        ;

resto : args bloque { $$ = createNode(NODE_RESTO, 0, $1, $2);};

args : '(' parameters ')' {$$ = createNode(NODE_PARENS, 0, $2, NULL);};

parameters : declaracion
            | declaracion ',' parameters { 
                Tree *n = createNode(NODE_LIST, 0, $1, $3);
                $$ = n;
            } 
            | {$$ = NULL;} /* epsilon */
            ;

bloque : '{' lista_sentencias '}' {$$ = createNode(NODE_BLOCK, 0, $2, NULL);}
        ;
lista_sentencias : sentencia  lista_sentencias { 
                                                    if ($2 == NULL) $$ = $1; 
                                                    else {
                                                        Tree *n = createNode(NODE_LIST, 0, $1, $2);
                                                        $$ = n;
                                                    }
                                                }
                | {$$ = NULL;}  /* epsilon */
                ;

sentencia : declaracion ';'
          | asignacion ';'
          | RETURN E ';' {$$ = createNode(NODE_RETURN, 0, $2, NULL);}
          | RETURN ';' {$$ = createNode(NODE_RETURN, 0, NULL, NULL);}
          ;

declaracion : T ID {Tree* aux = createNode(NODE_ID, 0, NULL, NULL);
                    aux->name = $2;
                    $$ = createNode(NODE_DECLARATION, 0, $1, aux);
                    $$->left->name = $2; 
                  }
            | T asignacion
            ;

asignacion : ID '=' E { 
                $$ = createNode(NODE_ASSIGN,0,NULL,NULL);
                $$->left = createNode(NODE_ID,0,NULL,NULL);
                $$->left->name = $1; 
                $$->right = $3; 
            }
           ;

T : T_INT { $$ = createNode(NODE_T_INT, 0, NULL, NULL); }
    | T_BOOL { $$ = createNode(NODE_T_BOOL, 0, NULL, NULL); }
    | T_VOID { $$ = createNode(NODE_T_VOID, 0, NULL, NULL); }
    ;



E   : E '+' E { $$ = createNode(NODE_SUM,0,$1,$3); }

    | E '*' E   { $$ = createNode(NODE_MUL,0,$1,$3); }

    | '(' E ')' { $$ = createNode(NODE_PARENS,0,$2,NULL); }

    | E OR E    { $$ = createNode(NODE_OR,0,$1,$3); }

    | E AND E   { $$ = createNode(NODE_AND,0,$1,$3); }

    | '!' E { $$ = createNode(NODE_NOT,0,$2,NULL); }

    | E EQ E   { $$ = createNode(NODE_EQ,0,$1,$3); }

    | E NEQ E   { $$ = createNode(NODE_NEQ,0,$1,$3); }

    | E LE E   { $$ = createNode(NODE_LE,0,$1,$3); }

    | E GE E   { $$ = createNode(NODE_GE,0,$1,$3); }

    | E '<' E   { $$ = createNode(NODE_LT,0,$1,$3); }
    
    | E '>' E   { $$ = createNode(NODE_GT,0,$1,$3); }

    | ID { $$ = createNode(NODE_ID,0,NULL,NULL);
            $$->name = $1; }

    | INT { $$ = createNode(NODE_T_INT,$1,NULL,NULL); }

    | TRUE { $$ = createNode(NODE_TRUE,1,NULL,NULL); }

    | FALSE { $$ = createNode(NODE_FALSE,0,NULL,NULL); }
    ;
%%
