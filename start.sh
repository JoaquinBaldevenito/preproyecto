!/bin/bash
bison -d parserbison.y
flex flex.l
gcc -o act1 parserbison.tab.c lex.yy.c -lfl
./act1
