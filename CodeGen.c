#include <stdio.h>
#include "Tree.h"
#include "CodeGen.h"
static int tempCount = 0;

char* newTemp() {
    char *buf = malloc(16);
    sprintf(buf, "t%d", tempCount++);
    return buf;
}

char* genExpr(Tree *node) {
    if (!node) return NULL;

    switch (node->tipo) {
        case NODE_INT: {
            char *t = newTemp();
            printf("MOV %s, %d\n", t, node->sym->valor.value);
            return t;
        }

        case NODE_ID:
            return node->sym->name;

        case NODE_SUM: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();        // nuevo temporal para almacenar el resultado
            printf("MOV %s, %s\n", t, lhs);
            printf("ADD %s, %s\n", t, rhs);
            return t;
        }

        case NODE_RES: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, lhs);
            printf("SUB %s, %s\n", t, rhs);
            return t;
        }

        case NODE_MUL: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, lhs);
            printf("IMUL %s, %s\n", t, rhs);
            return t;
        }

        case NODE_DIV: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, lhs);
            printf("IDIV %s, %s\n", t, rhs);
            return t;
        }

        case NODE_PARENS: {
            return genExpr(node->left);
        }

        case NODE_TRUE:
        case NODE_FALSE: {
            char *t = newTemp();
            int val = (node->tipo == NODE_TRUE) ? 1 : 0;
            printf("MOV %s, %d\n", t, val);
            return t;
        }

        case NODE_NOT: {
            char *expr = genExpr(node->left);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, expr);
            printf("NOT %s\n", t);   // pseudo-instrucción NOT
            return t;
        }

        case NODE_AND:
        case NODE_OR: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, lhs);
            if (node->tipo == NODE_AND)
                printf("AND %s, %s\n", t, rhs);
            else
                printf("OR %s, %s\n", t, rhs);
            return t;
        }

        case NODE_EQ:
        case NODE_NEQ:
        case NODE_LT:
        case NODE_GT:
        case NODE_LE:
        case NODE_GE: {
            char *lhs = genExpr(node->left);
            char *rhs = genExpr(node->right);
            char *t = newTemp();
            printf("MOV %s, %s\n", t, lhs);
            switch(node->tipo) {
                case NODE_EQ:  printf("CMP_EQ %s, %s\n", t, rhs); break;
                case NODE_NEQ: printf("CMP_NEQ %s, %s\n", t, rhs); break;
                case NODE_LT:  printf("CMP_LT %s, %s\n", t, rhs); break;
                case NODE_GT:  printf("CMP_GT %s, %s\n", t, rhs); break;
                case NODE_LE:  printf("CMP_LE %s, %s\n", t, rhs); break;
                case NODE_GE:  printf("CMP_GE %s, %s\n", t, rhs); break;
            }
            return t;
        }

        default:
            fprintf(stderr, "genExpr ISA: nodo no implementado %d\n", node->tipo);
            return NULL;
    }
}

void genCode(Tree *node) {
    if (!node) return;

    switch (node->tipo) {
        case NODE_RESTO:
        case NODE_LIST:
        case NODE_BLOCK:
        case NODE_PROGRAM:
            genCode(node->left);
            genCode(node->right);
            break;

        case NODE_DECLARATION:
            printf("; reservar %s\n", node->sym->name);
            if (node->right) {
                char *rhs = genExpr(node->right);
                printf("MOV %s, %s\n", node->sym->name, rhs);
            }
            break;

        case NODE_ASSIGN: {
            char *rhs = genExpr(node->left);
            printf("MOV %s, %s\n", node->sym->name, rhs);
            break;
        }

        case NODE_RETURN: {
            if (node->left) {
                char *val = genExpr(node->left);
                printf("MOV eax, %s\n", val);
            }
            printf("RET\n");
            break;
        }
    }
}
