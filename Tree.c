#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Tree.h"
#include "Symbol.h"   

struct Tree;  /* forward declaration */

Tree* createNode(typeTree tipo, Symbol *sym, Tree *left, Tree *right) {
    Tree *n = malloc(sizeof(Tree));
    n->tipo = tipo;
    n->sym = sym;
    n->left = left;
    n->right = right;
    return n;
}

void printTree(Tree *n, int level) {
    if (!n) return;

    for (int i = 0; i < level; i++) printf("  ");

    const char *tipo = tipoToStr(n->tipo);

    if (n->sym) {
        printf("%s(Symbol: %s, type=%d, value=%d)\n",
                tipo,
                n->sym->name ? n->sym->name : "anon",
                n->sym->type,
                n->sym->valor.value);
    } else {
        printf("%s\n", tipo);
    }

    if (n->left) {
        for (int i = 0; i <= level; i++) printf("  ");
        printf("left:\n");
        printTree(n->left, level + 2);
    }
    if (n->right) {
        for (int i = 0; i <= level; i++) printf("  ");
        printf("right:\n");
        printTree(n->right, level + 2);
    }
}

const char* tipoToStr(typeTree t) {
    switch (t) {
        case NODE_ID:    return "ID";
        case NODE_PLUS:  return "PLUS";
        case NODE_MUL:   return "*";
        case NODE_RES:   return "-";
        case NODE_DIV:   return "/";
        case NODE_PROGRAM: return "PROGRAM";
        case NODE_RESTO: return "RESTO";
        case NODE_ARGS:  return "ARGS";
        case NODE_LIST:  return "LIST";
        case NODE_BLOCK: return "BLOCK";
        case NODE_RETURN: return "RETURN";
        case NODE_DECLARATION: return "DECLARATION";
        case NODE_ASSIGN: return "=";
        case NODE_TRUE:  return "TRUE";
        case NODE_INT: return "INT";
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

void execute(Tree *n) {
    if (!n) return;

    switch (n->tipo) {
        case NODE_ASSIGN: {
            Symbol *s = n->sym;
            Tree *expr = n->left;
            execute(expr);         // calcula la expresión antes
            if (expr->sym) {
                s->valor.value = expr->sym->valor.value;
            }
            break;
        }
        case NODE_DECLARATION:
            if (n->left) execute(n->left);
            if (n->right) execute(n->right);
            break;
        case NODE_SUM:
        case NODE_MUL:
        case NODE_RES:
        case NODE_DIV: {
            execute(n->left);
            execute(n->right);
            int v1 = n->left->sym->valor.value;
            int v2 = n->right->sym->valor.value;
            Symbol *s = malloc(sizeof(Symbol));
            s->valor.value = 
                (n->tipo == NODE_SUM) ? v1 + v2 :
                (n->tipo == NODE_RES) ? v1 - v2 :
                (n->tipo == NODE_MUL) ? v1 * v2 :
                (v2 != 0 ? v1 / v2 : 0);
            s->type = TYPE_INT;
            n->sym = s;
            break;
        }
        default:
            execute(n->left);
            execute(n->right);
            break;
    }
}
