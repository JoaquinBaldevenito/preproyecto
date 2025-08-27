#ifndef SYMBOL_H
#define SYMBOL_H

#include <stdio.h>

typedef enum {
    TYPE_INT,
    TYPE_BOOL,
    TYPE_VOID
} SymbolType;

typedef struct Symbol {
    SymbolType type;        /* tipo de dato */
    int value;             /* usado si es número */
    char *name;           /* usado si es identificador */
} Symbol;

#endif /*SYMBOL_H*/