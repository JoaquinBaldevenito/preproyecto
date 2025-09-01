%{
#include <stdio.h>
#include <stdlib.h>
#include "Tree.h"
#include "SymbolTable.h"

extern FILE *yyin;
extern int yylineno;
extern int semantic_error;

SymbolTable *symtab;
Tree *ast_root;
int yylex(void);

int had_error = 0;

void yyerror(const char *s) {
    extern int yylineno;   
    printf("-> ERROR Sintáctico en la línea %d: %s\n", yylineno, s);
    had_error = 1;
}

%}

%union {
    int num;               /* para INT */
    char* id;             /* para ID */
    struct Tree* node;   /* para expresiones */
    struct Symbol* sym; /* para la tabla de simbolos*/
}

/* Palabras Reservadas*/
%token MAIN RETURN IF ELSE WHILE T_INT T_BOOL T_VOID

%token <num> INT /* Números enteros */

/* Constantes Booleanas */
%token <num> TRUE FALSE

/* Operadores */
%token OR AND EQ NEQ LE GE

/* Numeros e identificadores */
%token <num> NUM
%token <id> ID

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
                        ast_root = createNode(NODE_PROGRAM, 0, $1, $3);
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

declaracion 
    : T ID {
        Symbol *s = lookupSymbol(symtab, $2);
        if (s) {
            fprintf(stderr, "Error: variable '%s' ya declarada\n", $2);
        }
        // Mapear el nodo de tipo T a SymbolType
        SymbolType t;
        if ($1->tipo == NODE_T_INT) t = TYPE_INT;
        else if ($1->tipo == NODE_T_BOOL) t = TYPE_BOOL;
        else t = TYPE_VOID;

        // Insertar en la tabla
        Valores v = {0}; 
        Symbol *aux = insertSymbol(symtab, $2, t, v);
        // Crear nodo AST con símbolo
        $$ = createNode(NODE_DECLARATION, aux, $1, NULL);
    }
    | T ID '=' E {
        //Chequeo de inicialización
        Symbol *s = lookupSymbol(symtab, $2);
        if (s) {
            fprintf(stderr, "Error: variable '%s' ya declarada\n", $2);
        }
        // Declaración + inicialización
        SymbolType t;
        if ($1->tipo == NODE_T_INT) t = TYPE_INT;
        else if ($1->tipo == NODE_T_BOOL) t = TYPE_BOOL;
        else t = TYPE_VOID;

        Valores v = {0};
        Symbol *aux = insertSymbol(symtab, $2, t, v);
        $$ = createNode(NODE_DECLARATION, aux, $1, $4);
    }
;

asignacion 
    // solo asignaciones
    : ID '=' E {
        // Buscar símbolo (debe existir previamente en tabla)
        Symbol *s = lookupSymbol(symtab, $1);
        if (!s) {
            fprintf(stderr, "Error: variable '%s' no declarada\n", $1);
        }

        // Nodo asignación, enlazado al símbolo
        $$ = createNode(NODE_ASSIGN, s, $3, NULL);
    }
    ;


T : T_INT { $$ = createNode(NODE_T_INT, 0, NULL, NULL); }
    | T_BOOL { $$ = createNode(NODE_T_BOOL, 0, NULL, NULL); }
    | T_VOID { $$ = createNode(NODE_T_VOID, 0, NULL, NULL); }
    ;



E   : E '+' E { $$ = createNode(NODE_SUM,0,$1,$3); }

    | E '*' E   { $$ = createNode(NODE_MUL,0,$1,$3); }

    | E '-' E   { $$ = createNode(NODE_RES,0,$1,$3); }
    
    | E '/' E   { $$ = createNode(NODE_DIV,0,$1,$3); }

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

    | ID {
        Symbol *s = lookupSymbol(symtab, $1);
        if (!s) {
            fprintf(stderr, "Error: variable '%s' no declarada\n", $1);
        }
        $$ = createNode(NODE_ID, s, NULL, NULL);
    }

    | INT {
        Symbol *s = malloc(sizeof(Symbol));
        if (!s) { fprintf(stderr, "Error: sin memoria\n"); exit(1); }
        s->valor.value = $1;
        s->type = TYPE_INT;
        $$ = createNode(NODE_INT, s, NULL, NULL);
    }
    | TRUE {
        Symbol *s = malloc(sizeof(Symbol));
        s->valor.value = 1;
        s->type = TYPE_BOOL;
        $$ = createNode(NODE_TRUE, s, NULL, NULL);
    }
    | FALSE {
        Symbol *s = malloc(sizeof(Symbol));
        s->valor.value = 0;
        s->type = TYPE_BOOL;
        $$ = createNode(NODE_FALSE, s, NULL, NULL);
    }
    ;
%%


int main(int argc,char *argv[]){
    symtab = createTable();
    ++argv,--argc;
    if (argc > 0)
        yyin = fopen(argv[0],"r");
    else
        yyin = stdin;

    yyparse();

    if (had_error || !ast_root) {
        fprintf(stderr, "Se detectaron errores. No se ejecutará el AST.\n");
        return 1;
    }
    printf("Árbol antes de ejecutar asignaciones:\n");
    printTree(ast_root, 0);

    // Ejecutar asignaciones
    execute(ast_root);

    // Chequeo semantico
    check_types(ast_root);
    if (semantic_error) {
        fprintf(stderr, "Error semántico\n");
        return 2;
    } else {
        printf("\nSIN ERRORES SEMANTICOS\n");
    }

    printf("\nÁrbol después de ejecutar asignaciones:\n");
    printTree(ast_root, 0);

    printSymbolTable(symtab);
    return 0;
}
