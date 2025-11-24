%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "TS.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int num_lineas;

FILE *salida;

void yyerror(const char *s) {
    fprintf(stderr, "Error semántico en línea %d: %s\n", num_lineas, s);
}
%}

%union {
    int entero;
    double decimal;
    char *str;
}

%token <str> VARIABLE CONSTANTE CADENA
%token <entero> ENTERO
%token <decimal> DECIMAL CIENTIFICO
%token ACCION TIPO_DATO BOOLEANO
%token SI SINO OSI MIENTRAS PARA HACER IMPRIMIR LEER
%token IGUAL DIFERENTE MENOR_IGUAL MAYOR_IGUAL AND OR NOT
%token MAS MENOS POR DIV MOD MENOR MAYOR ASIGN

/* PRECEDENCIA PARA RESOLVER CONFLICTOS (Dangling Else) */
%nonassoc LOWER_THAN_SINO
%nonassoc SINO OSI

%%

programa:
    { 
        fprintf(salida, "#include <stdio.h>\n"); 
        fprintf(salida, "#include <stdlib.h>\n\n"); 
        fprintf(salida, "int main() {\n"); 
    }
    declaraciones bloque_principal
    { 
        fprintf(salida, "\n\treturn 0;\n}\n");
        printf("\n--- Compilación Exitosa: Se generó 'salida.c' ---\n");
        imprimir_tabla(ts);
    }
    ;

declaraciones:
    /* vacío */
    | declaraciones declaracion
    ;

declaracion:
      TIPO_DATO VARIABLE ';'
      {
          if(esta_en_tabla(ts, $2)) {
              char msg[100]; sprintf(msg, "Variable '%s' duplicada", $2); yyerror(msg);
          } else {
              ts = inserta_simbolo(ts, $2, 0); 
              fprintf(salida, "\tdouble %s;\n", $2); 
          }
      }
    | TIPO_DATO VARIABLE ASIGN 
      { 
          if(esta_en_tabla(ts, $2)) {
              char msg[100]; sprintf(msg, "Variable '%s' duplicada", $2); yyerror(msg);
          } else {
              ts = inserta_simbolo(ts, $2, 0);
              fprintf(salida, "\tdouble %s = ", $2); 
          }
      } 
      expresion ';' 
      { fprintf(salida, ";\n"); }

    | TIPO_DATO CONSTANTE ASIGN 
      {
          if(esta_en_tabla(ts, $2)) {
               yyerror("Constante duplicada");
          } else {
               ts = inserta_simbolo(ts, $2, 1); 
               fprintf(salida, "\tconst double %s = ", $2);
          }
      }
      expresion ';' 
      { fprintf(salida, ";\n"); }
    ;

bloque_principal:
    ACCION CONSTANTE '(' ')' bloque
    ;

bloque:
    '{' sentencias '}'
    ;

sentencias:
    /* vacío */
    | sentencias sentencia
    ;

sentencia:
    expresion ';' { fprintf(salida, ";\n"); }
    | declaracion
    | sentencia_si
    | sentencia_mientras
    | sentencia_para
    | sentencia_imprimir
    | sentencia_leer
    | bloque
    ;

sentencia:
    VARIABLE ASIGN 
    {
        if(!esta_en_tabla(ts, $1)) {
             char msg[100]; sprintf(msg, "Variable '%s' no declarada", $1); yyerror(msg);
        }
        if(es_constante(ts, $1)) {
             yyerror("Error: No se puede modificar una CONSTANTE.");
        }
        fprintf(salida, "\t%s = ", $1);
    }
    expresion ';' 
    { fprintf(salida, ";\n"); }
    ;

inicio_si:
    SI '(' { fprintf(salida, "\tif ("); } expresion ')' { fprintf(salida, ") {\n"); }
    ;

sentencia_si:
      inicio_si sentencia %prec LOWER_THAN_SINO 
      { fprintf(salida, "\t}\n"); }
    
    | inicio_si sentencia SINO { fprintf(salida, "\t} else {\n"); } sentencia 
      { fprintf(salida, "\t}\n"); }
      
    | inicio_si sentencia OSI { fprintf(salida, "\t} else "); } sentencia_si
    ;

sentencia_mientras:
    MIENTRAS '(' { fprintf(salida, "\twhile ("); } expresion ')' { fprintf(salida, ") {\n"); } 
    sentencia { fprintf(salida, "\t}\n"); }
    ;

sentencia_para:
    PARA '(' { fprintf(salida, "\tfor ("); } 
    expresion_asignacion ';' { fprintf(salida, "; "); }
    expresion ';' { fprintf(salida, "; "); }
    expresion_asignacion ')' { fprintf(salida, ") {\n"); }
    sentencia
    { fprintf(salida, "\t}\n"); }
    ;

expresion_asignacion:
    VARIABLE ASIGN 
    {
        if(!esta_en_tabla(ts, $1)) yyerror("Variable iterador no declarada");
        fprintf(salida, "%s = ", $1);
    }
    expresion
    ;

sentencia_imprimir:
    IMPRIMIR '(' CADENA ')' ';'
    {
        fprintf(salida, "\tprintf(%s);\n\tprintf(\"\\n\");\n", $3);
    }
    ;

sentencia_leer:
    LEER '(' VARIABLE ')' ';'
    {
        if(!esta_en_tabla(ts, $3)) yyerror("Variable a leer no declarada");
        
        fprintf(salida, "\tprintf(\"Introduce un valor para %s: \");\n", $3);
        
        fprintf(salida, "\tscanf(\"%%lf\", &%s);\n", $3);
    }
    ;

expresion:
    expresion_logica
    ;

expresion_logica:
    expresion_logica OR { fprintf(salida, " || "); } expresion_relacional
    | expresion_logica AND { fprintf(salida, " && "); } expresion_relacional
    | expresion_relacional
    ;

expresion_relacional:
    expresion_simple MENOR { fprintf(salida, " < "); } expresion_simple
    | expresion_simple MAYOR { fprintf(salida, " > "); } expresion_simple
    | expresion_simple MENOR_IGUAL { fprintf(salida, " <= "); } expresion_simple
    | expresion_simple MAYOR_IGUAL { fprintf(salida, " >= "); } expresion_simple
    | expresion_simple IGUAL { fprintf(salida, " == "); } expresion_simple
    | expresion_simple DIFERENTE { fprintf(salida, " != "); } expresion_simple
    | expresion_simple
    ;

expresion_simple:
    expresion_simple MAS { fprintf(salida, " + "); } termino
    | expresion_simple MENOS { fprintf(salida, " - "); } termino
    | termino
    ;

termino:
    termino POR { fprintf(salida, " * "); } factor
    | termino DIV { fprintf(salida, " / "); } factor
    | termino MOD { fprintf(salida, " %% "); } factor
    | factor
    ;

factor:
    '(' { fprintf(salida, "("); } expresion ')' { fprintf(salida, ")"); }
    | ENTERO        { fprintf(salida, "%d", $1); }
    | DECIMAL       { fprintf(salida, "%f", $1); }
    | CIENTIFICO    { fprintf(salida, "%f", $1); }
    | VARIABLE      
      { 
          if(!esta_en_tabla(ts, $1)) {
               char msg[100]; sprintf(msg, "Variable '%s' no declarada", $1); yyerror(msg);
          }
          fprintf(salida, "%s", $1); 
      }
    | CONSTANTE     
      { 
          if(!esta_en_tabla(ts, $1)) yyerror("Constante no declarada");
          fprintf(salida, "%s", $1); 
      }
    | BOOLEANO      { fprintf(salida, "1"); }
    | CADENA        { fprintf(salida, "%s", $1); }
    | NOT { fprintf(salida, " ! "); } factor 
    | ACCION '(' argumentos ')'
    ;

argumentos:
    /* vacío */
    | expresion
    | argumentos ',' expresion
    ;

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "No se pudo abrir el archivo fuente: %s\n", argv[1]);
            return 1;
        }
    } else {
        fprintf(stderr, "Uso: ./compilador fuente.txt\n");
        return 1;
    }
    
    salida = fopen("salida.c", "w");
    if (!salida) {
        fprintf(stderr, "Error creando salida.c\n");
        return 1;
    }

    printf("=== COMPILADOR DE RECETAS ===\n");
    yyparse();
    
    if (yyin != stdin) fclose(yyin);
    fclose(salida);
    return 0;
}