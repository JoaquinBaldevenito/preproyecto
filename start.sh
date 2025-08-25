#!/bin/bash
bison -d parserbison.y
flex flex.l
gcc -o act1 parserbison.tab.c lex.yy.c Tree.c -lfl
# guardamos la salida en un archivo
./act1 < test/test1.txt > resultados/result1.txt

### Para correr wsl
#sed -i 's/\r$//' start.sh