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

    /* ======== PATRONES Y |ACCIONES ========== */
%%|
"main"              {   return MAIN;    }
"int"               {   return T_INT;    }
"bool"              {   return T_BOOL;    }
"void"              {   return T_VOID;    }
"return"            {   return RETURN;    }
"if"                {   return IF;    }
"else"              {   return ELSE;    }
"while"             {   return WHILE;    }
"true"              {   return TRUE;    }
"false"             {   return FALSE;    }

    /* Números */
{NUMERO}            {
                    yylval.num = atoi(yytext);
                    return INT; }

    /* Identificadores */
{ID}                {
                    yylval.id = strdup(yytext);
                    return ID; }

    /* Operadores de un solo carácter y delimitadores */
[+*;(){}=!,-/<>]         {   return *yytext;    }

    /* Operadores de dos caracteres */
"||"          {   return OR;    }
"&&"          {   return AND;   }
"=="          {   return EQ;    }
"!="          {   return NEQ;   }
"<="          {   return LE;   }
">="          {   return GE;   }


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
