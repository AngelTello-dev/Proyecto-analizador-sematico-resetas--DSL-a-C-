%{
#include <stdio.h>
#include <string.h>
#include "compilador.tab.h"

int num_lineas = 1;
void yyerror(const char *s);
%}

ACCION              preparar|sazonar|mezclar|hornear|servir|deglasar|reposar|marinar|cortar|batir|hervir|freir
TIPO_DATO           ingrediente|receta
BOOLEANO            verdadero|falso
VARIABLE            [a-záéíóúñ][a-z0-9áéíóúñ_]*
CONSTANTE           [A-ZÁÉÍÓÚÑ][A-Z0-9ÁÉÍÓÚÑ_]*
ENTERO              -?[0-9]+                   
DECIMAL             -?[0-9]*\.[0-9]+            
CIENTIFICO          -?[0-9]*\.?[0-9]+[Ee][-+]?[0-9]+
CADENA              \"([^"\\]|\\.)*\"
COMENTARIO_LINEA    "#".*
COMENTARIO_BLOQUE   "<##"([^#]|#([^#]|#[^>]))*"##>"
AGRUPACION          [(){},;:]

%%

{ACCION}            { return ACCION; }
{TIPO_DATO}         { return TIPO_DATO; }
{BOOLEANO}          { return BOOLEANO; }
"si"                { return SI; }
"sino"              { return SINO; }
"osi"               { return OSI; }
"mientras"          { return MIENTRAS; }
"para"              { return PARA; }
"hacer"             { return HACER; }
"imprimir"          { return IMPRIMIR; }
"leer"              { return LEER; }

{VARIABLE}          { yylval.str = strdup(yytext); return VARIABLE; }
{CONSTANTE}         { yylval.str = strdup(yytext); return CONSTANTE; }
{ENTERO}            { yylval.entero = atoi(yytext); return ENTERO; }
{DECIMAL}           { yylval.decimal = atof(yytext); return DECIMAL; }
{CIENTIFICO}        { yylval.decimal = atof(yytext); return CIENTIFICO; }
{CADENA}            { yylval.str = strdup(yytext); return CADENA; }
{COMENTARIO_LINEA}  { }
{COMENTARIO_BLOQUE} { }

"=="                { return IGUAL; }
"!="                { return DIFERENTE; }
"<="                { return MENOR_IGUAL; }
">="                { return MAYOR_IGUAL; }
"&&"                { return AND; }
"||"                { return OR; }
"!"                 { return NOT; }
"+"                 { return MAS; }
"-"                 { return MENOS; }
"*"                 { return POR; }
"/"                 { return DIV; }
"%"                 { return MOD; }
"<"                 { return MENOR; }
">"                 { return MAYOR; }
"="                 { return ASIGN; }
{AGRUPACION}        { return yytext[0]; }
[ \t]               { }
\n                  { num_lineas++; }
.                   { yyerror("Carácter no reconocido"); }

%%

int yywrap() { return 1; }