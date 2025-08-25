
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
struct Tree;

typedef enum{
  NODE_PROGRAM,
    NODE_RESTO,
    NODE_ARGS,
    NODE_LIST,
    NODE_BLOCK,
    NODE_RETURN,
    NODE_DECLARATION,
    NODE_ASSIGN,
    NODE_ID,
    NODE_INT,
    NODE_TRUE,
    NODE_FALSE,
    NODE_T_INT,
    NODE_T_BOOL,
    NODE_T_VOID,
    NODE_PLUS,
    NODE_MUL,
    NODE_OR,
    NODE_AND,
    NODE_NOT,
    NODE_PARENS,
    NODE_SUM,
} typeTree;

typedef struct Tree {
    typeTree tipo;            /* nombre del nodo: "INT", "+", "*" ... */
    int value;             /* usado si es número */
    char *name;           /* usado si es identificador */
    struct Tree *left;
    struct Tree *right;
}Tree;

Tree* createNode(typeTree tipo, int value, Tree *left, Tree *right);
void printTree(Tree *n, int level);
const char* tipoToStr(typeTree t);