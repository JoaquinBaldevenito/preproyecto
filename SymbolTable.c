#include <stdlib.h>
#include <string.h>
#include "SymbolTable.h"

SymbolTable* createTable() {
    SymbolTable *t = malloc(sizeof(SymbolTable));
    t->size = 0;
    t->capacity = 16;
    t->symbols = malloc(sizeof(Symbol*) * t->capacity);
    return t;
}

Symbol* insertSymbol(SymbolTable *table, const char *name, SymbolType type, int value) {
    if (!name) {
    fprintf(stderr, "Error: insertSymbol recibió un nombre NULL\n");
    return NULL;
    }
    // Chequear duplicados
    for (int i = 0; i < table->size; i++) {
        if (table->symbols[i] && table->symbols[i]->name) {
            if (strcmp(table->symbols[i]->name, name) == 0) {
                return table->symbols[i]; // ya existe
            }
        }
    }

    if (table->size == table->capacity) {
        table->capacity *= 2;
        table->symbols = realloc(table->symbols, sizeof(Symbol*) * table->capacity);
    }

    Symbol *s = malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->type = type;
    s->value = value;

    table->symbols[table->size++] = s;
    return s;
}

Symbol* lookupSymbol(SymbolTable *table, const char *name) {
    for (int i = 0; i < table->size; i++) {
        if (strcmp(table->symbols[i]->name, name) == 0)
            return table->symbols[i];
    }
    return NULL;
}
