#ifndef CODEGEN_H
#define CODEGEN_H

#include "Tree.h"
#include "SymbolTable.h"

void genCode(Tree *root);

char* newTemp();

char* genExpr(Tree *node);

#endif /* CODEGEN_H */
