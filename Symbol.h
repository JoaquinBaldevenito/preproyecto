#ifndef SYMBOL_H
#define SYMBOL_H

#include <stdio.h>

typedef union {
    int value;             /* usado si es número */
    char *string;           /* usado si es identificador */
}Valores;
    


typedef enum {
    TYPE_INT,
    TYPE_BOOL,
    TYPE_VOID
} SymbolType;

typedef struct Symbol {
    SymbolType type;        /* tipo de dato */
    char *name;   
    Valores valor;      /* usado si es identificador */
} Symbol;

#endif /*SYMBOL_H*/