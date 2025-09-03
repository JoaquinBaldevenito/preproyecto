# Compilador Mini Lenguaje C

Este proyecto implementa un compilador para un mini-lenguaje similar a C, con soporte para tipos `int`, `bool` y `void`, operaciones aritméticas y lógicas, declaraciones, asignaciones y control de errores sintácticos y semánticos.

## Estructura del Proyecto

- [`parserbison.y`](parserbison.y): Gramática y acciones semánticas (Bison)
- [`flex.l`](flex.l): Analizador léxico (Flex)
- [`Tree.c`](Tree.c), [`Tree.h`](Tree.h): Definición y manejo del AST
- [`SymbolTable.c`](SymbolTable.c), [`SymbolTable.h`](SymbolTable.h): Tabla de símbolos
- [`Symbol.h`](Symbol.h): Definición de símbolos y tipos
- [`Gramaticas.hs`](Gramaticas.hs): Gramática formal en notación BNF
- [`Makefile`](Makefile): Automatización de compilación y tests
- [`test/`](test/): Casos de prueba divididos en `valid`, `syntax` y `semantics`
- [`resultados/`](resultados/): Salidas de los tests

## Compilación y Ejecución de Tests

Para compilar y ejecutar todos los tests automáticamente(con config por defecto):

```sh
make
```

Sino para correr con interprete:
```sh
make MODO=1
```

con Assembly:
```sh
make MODO=0
```

Esto compilará el proyecto y ejecutará los tests, mostrando los resultados en la carpeta [`resultados/`](resultados/).(Crear la carpeta). Para cambiar entre el intérprete y el assembler cambiar el valor de modo_intérprete en el archivo parserbison.y

- Los tests válidos están en [`test/valid/`](test/valid/)
- Los tests con errores sintácticos están en [`test/syntax/`](test/syntax/)
- Los tests con errores semánticos están en [`test/semantics/`](test/semantics/)

Para limpiar los archivos generados y los resultados:

```sh
make clean
```

## Ejecución Manual

Puedes ejecutar el compilador manualmente con:

```sh
./act1 < test/valid/test1.txt
```

## Gramática

La gramática soportada está documentada en [`Gramaticas.hs`](Gramaticas.hs).

## Dependencias

- Flex
- Bison
- GCC
- Make
