#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Tree.h"
struct Tree;  /* forward declaration */

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
    else if (strcmp(n->tipo,"ID")==0)
        printf("%s(%s)\n", n->tipo, n->name);
    else
        printf("%s\n", n->tipo);

    if(n->left) {
        for(int i=0;i<=level;i++) printf("  "); 
        printf("left:\n");
        printTree(n->left, level+2);
    }
    if(n->right) {
        for(int i=0;i<=level;i++) printf("  ");
        printf("right:\n");
        printTree(n->right, level+2);
    }
}

