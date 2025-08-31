# Compilador Mini Lenguaje C

Este proyecto implementa un compilador para un mini-lenguaje similar a C, con soporte para tipos `int`, `bool` y `void`, operaciones aritméticas y lógicas, declaraciones, asignaciones y control de errores sintácticos y semánticos.

## Estructura del Proyecto

- [`parserbison.y`](parserbison.y): Gramática y acciones semánticas (Bison)
- [`flex.l`](flex.l): Analizador léxico (Flex)
- [`Tree.c`](Tree.c), [`Tree.h`](Tree.h): Definición y manejo del AST
- [`SymbolTable.c`](SymbolTable.c), [`SymbolTable.h`](SymbolTable.h): Tabla de símbolos
- [`Symbol.h`](Symbol.h): Definición de símbolos y tipos
- [`start.sh`](start.sh): Script para compilar y correr tests
- [`test/`](test/): Casos de prueba divididos en `valid`, `syntax` y `semantics`
- [`resultados/`](resultados/): Salidas de los tests

## Compilación

Ejecuta el script de compilación:

```sh
./start.sh
```

Esto compila el proyecto y ejecuta todos los tests, mostrando los resultados en la carpeta [`resultados/`](resultados/).

## Ejecución Manual

Puedes ejecutar el compilador manualmente con:

```sh
./act1 < test/valid/test1.txt
```

## Gramática

La gramática soportada está documentada en [`Gramaticas.hs`](Gramaticas.hs).

## Tests

- Los tests válidos están en [`test/valid/`](test/valid/)
- Los tests con errores sintácticos están en [`test/syntax/`](test/syntax/)
- Los tests con errores semánticos están en [`test/semantics/`](test/semantics/)

## Dependencias

- Flex
- Bison
- GCC

## Créditos

Desarrollado por [Tu
