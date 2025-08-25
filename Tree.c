#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Tree.h"
struct Tree;  /* forward declaration */

Tree* createNode(typeTree tipo, int value, Tree *left, Tree *right) {
    Tree *n = malloc(sizeof(Tree));
    n->tipo = tipo;
    n->value = value;
    n->name = NULL;
    n->left = left;
    n->right = right;
    return n;
}

void printTree(Tree *n, int level) {
    if (!n) return;
    
    for (int i=0; i<level; i++) printf("  ");
    
    const char *tipo = tipoToStr(n->tipo); // Convert enum to string    
    if (n->tipo == NODE_T_INT)
        printf("%s(%d)\n", tipo, n->value);
    else if (n->tipo == NODE_ID)
        printf("%s(%s)\n", tipo, n->name);
    else if (n->tipo == NODE_PLUS)
        printf("%s(%s)\n", tipo, n->name);
    else
        printf("%s\n", tipo);

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

    const char* tipoToStr(typeTree t) {
      switch (t) {
          case NODE_ID:    return "ID";
          case NODE_PLUS:  return "PLUS";
          case NODE_MUL:   return "*";
          case NODE_PROGRAM: return "PROGRAM";
          case NODE_RESTO: return "RESTO";
          case NODE_ARGS:  return "ARGS";
          case NODE_LIST:  return "LIST";
          case NODE_BLOCK: return "BLOCK";
          case NODE_RETURN: return "RETURN";
          case NODE_DECLARATION: return "DECLARATION";
          case NODE_ASSIGN: return "=";
          case NODE_TRUE:  return "TRUE";
          case NODE_FALSE: return "FALSE";
          case NODE_T_INT: return "T_INT";
          case NODE_T_BOOL: return "T_BOOL";
          case NODE_T_VOID: return "T_VOID";
          case NODE_OR:    return "OR";
          case NODE_AND:   return "AND";
          case NODE_NOT:   return "¬";
          case NODE_PARENS: return "()";
          case NODE_SUM:   return "+";
          case NODE_EQ:   return "==";
          case NODE_NEQ:   return "!=";
          case NODE_LE:   return "<=";
          case NODE_LT:   return "<";
          case NODE_GE:   return ">=";
          case NODE_GT:   return ">";
          default:         return "STRING";
      }
    }

