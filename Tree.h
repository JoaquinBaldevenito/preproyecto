#ifndef TREE_H
#define TREE_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
struct Tree;

typedef struct Tree {
    char *tipo;            /* nombre del nodo: "INT", "+", "*" ... */
    int value;             /* usado si es número */
    char *name;           /* usado si es identificador */
    struct Tree *left;
    struct Tree *right;
}Tree;

Tree* createNode(char *tipo, int value, Tree *left, Tree *right);
void printTree(Tree *n, int level);

#endif /* TREE_H */