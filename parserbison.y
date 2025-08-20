%{

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
struct Tree;  /* forward declaration */

typedef struct Tree {
    char *tipo;            /* nombre del nodo: "INT", "+", "*" ... */
    int value;             /* usado si es número */
    char *name;           /* usado si es identificador */
    struct Tree *left;
    struct Tree *right;
}Tree;

Tree* createNode(char *tipo, int value, Tree *left, Tree *right) {
    Tree *n = malloc(sizeof(Tree));
    n->tipo = strdup(tipo);
    n->value = value;
    n->name = NULL;
    n->left = left;
    n->right = right;
    return n;
}

void printTree(Tree *n, int level) {
    if (!n) return;
    for (int i=0; i<level; i++) printf("  ");
    if (strcmp(n->tipo,"INT")==0)
        printf("%s(%d)\n", n->tipo, n->value);
    else
        printf("%s\n", n->tipo);
    printTree(n->left, level+1);
    printTree(n->right, level+1);
}

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
%type <node> programa bloque lista_sentencias sentencia declaracion asignacion

/* ==== Precedencia y asociatividad ==== */

%left OR
%left AND
%left EQ NEQ
%left '+' '-'
%left '*' '/'
%right '!'

%%
programa : T MAIN '(' ')' bloque  { 
                                    printf("No hay errores \n");
                                    printTree($5, 0);
                                    }
        ;

bloque : '{' lista_sentencias '}' {$$ = createNode("bloque", 0, $2, NULL);}
        ;
lista_sentencias : sentencia  lista_sentencias
                | {$$ = NULL;}  /* epsilon */
                ;

sentencia : declaracion ';'
          | asignacion ';'
          | RETURN E ';' {$$ = createNode("RETURN", 0, $2, NULL);}
          | RETURN ';' {$$ = createNode("RETURN", 0, NULL, NULL);}
          ;

declaracion : T ID 
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

    | '(' E ')' { $$ = $2; }

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
