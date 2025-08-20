%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
    /* Definimos tokens para el parser (Bison/Yacc) */
#include "parserbison.tab.h"

%}

%option noyywrap
%option yylineno

    /* ======== EXPRESIONES REGULARES ======== */
DIGITO      [0-9]
LETRA       [a-zA-Z]
ID          [a-z][a-zA-Z0-9]*
NUMERO      0|[1-9][0-9]*

    /* ======== PATRONES Y ACCIONES ========== */
%%
"main"              {printf("main : %s\n",yytext); return MAIN; }
"int"               {printf("int : %s\n",yytext); return T_INT; }
"bool"              {printf("bool : %s\n",yytext); return T_BOOL; }
"void"              {printf("void : %s\n",yytext); return T_VOID; }
"return"            {printf("return : %s\n",yytext); return RETURN; }
"if"                {printf("if : %s\n",yytext); return IF; }
"else"              {printf("else : %s\n",yytext); return ELSE; }
"while"             {printf("while : %s\n",yytext); return WHILE; }
"true"              {printf("true : %s\n",yytext); return TRUE; }
"false"             {printf("false : %s\n",yytext); return FALSE; }

    /* Números */
{NUMERO}            {
                    yylval.num = atoi(yytext);
                    printf("INT : %d\n",atoi(yytext));
                    return INT; }

    /* Identificadores */
{ID}                {
                    yylval.id = strdup(yytext);
                    printf("ID : %s\n",yytext);
                    return ID; }

    /* Operadores de un solo carácter y delimitadores */
[+*;(){}=!]         { printf("%s\n", yytext); 
                    return *yytext; }

    /* Operadores de dos caracteres */
"||"          { printf("%s\n", yytext); return OR; }
"&&"          { printf("%s\n", yytext); return AND; }
"=="          { printf("%s\n", yytext); return EQ; }
"!="          { printf("%s\n", yytext); return NEQ; }


    /* Ignorar espacios y tabs */
[ \t\r]+            { /* ignorar */ }

    /* Ignorar comentarios estilo C */
"//".*              { /* ignorar */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* ignorar */ }

    /* Saltos de línea (opcional si quieres contar líneas) */
\n                  { /* ignorar o contar */ }

.                   { printf("Caracter desconocido: %s\n", yytext); }
%%


void yyerror(){
	printf("%s%d\n","-> ERROR Sintactico en la linea: ",yylineno);
}

int main(int argc,char *argv[]){
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;

	yyparse();

}
