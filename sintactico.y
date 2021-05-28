
%{
#ifdef DEBUGGO_MODDO
#define YYDEBUG 1
#define YYERROR_VERBOSE 1
#endif
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "common.h"
int Dibujar=0, Recursion=0, MaxRecursion;
extern char *yytext;
int SubIndice=0, SubIndiceMax, NumLineas=1, EstadoScanner=0;
int should_kill = 0;
int file_flag = 0;

int convproc_count = 0;
int convqry_count = 0;
int convcnt = 0;
int last = 0;
int yywrap();
void FuncionArbol(int tipo);
void yyerror();
%}



%token CONV COMA CLS_HDR CONV_PROC CONV_QRY NOTE NL

%start class_decl

%%   

class_decl: notes class_header converters extra {printf("\n derivacion: Class_declaration -> Notes Class_header Converters \n"); DibujarTabla();FuncionArbol(1); yyparse();}
	  
	  | notes class_header NL				{printf("\n derivacion: Class_declaration -> Notes Class_header \n");DibujarTabla(); FuncionArbol(2); yyparse();}
	  | class_header converters NL				{printf("\n derivacion: Class_declaration -> Class_header Converters \n"); DibujarTabla(); FuncionArbol(3);yyparse();}
	  | class_header NL				{printf("\n derivacion: Class_declaration -> Class_header \n");DibujarTabla(); FuncionArbol(4); yyparse();}
	  | notes error NL 				{yyerrok; printf("\n error de sintaxis: falta 'Class_header' \n\n"); yyparse();}
	  | NL                         {yyerrok; printf("\n error de sintaxis: no se introdujo nada \n\n"); yyparse();}
	  | error NL  {yyerrok; printf("\n something went wrong \n\n");}
	  |
	  ;

class_header:  CLS_HDR { printf("\n derivacion: Class_header -> class_header\n");};

notes:  NOTE   {printf("\n derivacion: Notes -> note\n"); };

converters:  CONV converter_list {yyerrok; printf("\n derivacion: Converters -> \"convert\" Converter_list\n");};

converter_list: converter {printf("\n derivacion: Converter_list -> Converter\n"); convcnt++; }
			| converter_list COMA converter { printf("\n derivacion: Converter_list -> \",\" Converter\n");}
			| converter_list error converter {yyerrok; printf("\nERROR: Se esperaba un , entre cada conversor\n"); DibujarTabla();}
			| converter_list COMA error NL {yyerrok; printf("\nERROR: Termino invalido luego de la ,\n") ; DibujarTabla(); yyparse();}
			| converter_list COMA NL {printf("\nERROR: Se esperaba una expresion valida luego de la ,\n"); YYERROR; }
			;

converter: conversion_procedure {printf("\n derivacion: Converter -> Conversion_procedure\n"); convcnt++;}
			| conversion_query {printf("\n derivacion: Converter -> Conversion_query\n"); convcnt++;}
			;


conversion_procedure: CONV_PROC {
	printf("\n derivacion: Conversion_procedure -> \"conversion_procedure\" \n"); convproc_count++; last = 1;} ;
conversion_query: CONV_QRY {printf("\n derivacion: Conversion_query -> \"conversion_query\" \n"); convqry_count++; last = 0;} ;

extra:  
		| NL;
%%

/* Rutina de error */
void yyerror (char *s) {
	printf("\nyyerror: %s\n", s);
}


extern FILE *yyin;

int main(int argc, char *argv[]) {
#ifdef DEBUGGO_MODDO
	yydebug = 1;
#endif
	FILE* ArchEnt = NULL;
	if (argc == 2) {
		ArchEnt = fopen(argv[1], "rt");
		if (!ArchEnt) {
			fprintf(stderr, "No se encuentra el archivo %s \n", argv[1]);
			exit(-1);
		}
		file_flag = 1;
		yyin = ArchEnt;
		EstadoScanner = 1;
	}
	yyparse();
	return 0;
}
/* Llamada a funcion de finalizacion */
int yywrap() { 
	if (file_flag) should_kill = 1;
	printf("Finalizacion de analisis\n");
	if (should_kill) exit(0);
	return 1;
}

/* Llamada a función que dibuja el árbol */;
 

void FuncionArbol(int SubTipo){
	int ContAuxT,ContAuxK;
	int LargoPalabra;
	int DrawnEnd = 0;

/* la pantalla tiene un maximo de 1-79 caracteres */
	printf("-----------------------------ARBOL DE DERIVACIONES-----------------------------\n\n");
	printf("                                class_declaration\n");
	printf("                                      |\n");

	switch (SubTipo){
		case 1: {
			printf("                      +---------------+---------------+                      \n");
        	printf("                      |               |               |                      \n");                
        	printf("                    notes        class_header     converters                 \n");
			printf("                      |                               |                      \n");
			printf("                    note                              |                      \n");
			printf("                                           +----------+                      \n");
			printf("                                           |          |                      \n");
			printf("                                       \"convert\"  converter_list          \n");
			printf("                                                      |                      \n");
			printf("                                                      |                      \n");
			while (convcnt) {
			if (convcnt > 1) {
			printf("                                         +------------+-----------+          \n");
			printf("                                         |            |           |          \n");
			printf("                                   converter_list    \",\"     converter     \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			--convcnt;
			if(convproc_count > 1 || last != 1) {
			printf("                                         |                        |          \n");
			printf("                                         |              conversion_procedure \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |             \"conversion_procedure\"\n");
			printf("                                         |                                   \n");
			printf("                                         |                                   \n");
			--convproc_count;
			}
			if(convqry_count > 1 || last != 0) {
			printf("                                         |                        |          \n");
			printf("                                         |                 conversion_query  \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |             \"conversion_query\"\n");
			printf("                                         |                                   \n");
			printf("                                         |                                   \n");
			--convqry_count;
			}
			}
			if (convcnt == 1) {
			printf("                                         +------------+-----------+          \n");
			printf("                                                      |           |          \n");
			printf("                                     	             \",\"     converter     \n");
			if(convproc_count == 1) {
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                        conversion_procedure \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                       \"conversion_procedure\"\n");
			--convproc_count;
			}
			if(convqry_count == 1) {
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                           conversion_query  \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                         \"conversion_query\"\n");
			--convqry_count;
			}
			}

			--convcnt;
			}
        	break;
		}
		case 2: {
			printf("                      +---------------+                                      \n");
        	printf("                      |               |                                      \n");                
        	printf("                    notes        class_header                                \n");
			printf("                      |                                                      \n");
			printf("                    note                                                     \n");
        	break;
		}
		case 3: {
			printf("                                      +---------------+                      \n");
        	printf("                                      |               |                      \n");                
        	printf("                                 class_header     converters                 \n");
			printf("                                                      |                      \n");
			printf("                                                      |                      \n");
			printf("                                           +----------+                      \n");
			printf("                                           |          |                      \n");
			printf("                                       \"convert\"  converter_list          \n");
			printf("                                                      |                      \n");
			printf("                                                      |                      \n");
			while (convcnt) {
			if (convcnt > 1) {
			printf("                                         +------------+-----------+          \n");
			printf("                                         |            |           |          \n");
			printf("                                   converter_list    \",\"     converter     \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			--convcnt;
			if(convproc_count > 1 || last != 1) {
			printf("                                         |                        |          \n");
			printf("                                         |              conversion_procedure \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |             \"conversion_procedure\"\n");
			printf("                                         |                                   \n");
			printf("                                         |                                   \n");
			--convproc_count;
			}
			if(convqry_count > 1 || last != 0) {
			printf("                                         |                        |          \n");
			printf("                                         |                 conversion_query  \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |                        |          \n");
			printf("                                         |             \"conversion_query\"\n");
			printf("                                         |                                   \n");
			printf("                                         |                                   \n");
			--convqry_count;
			}
			}
			if (convcnt == 1) {
			printf("                                         +------------+-----------+          \n");
			printf("                                                      |           |          \n");
			printf("                                     	             \",\"     converter     \n");
			if(convproc_count == 1 && DrawnEnd != 1) {
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                        conversion_procedure \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                       \"conversion_procedure\"\n");
			--convproc_count;
			DrawnEnd = 1;
			}
			if(convqry_count == 1 && DrawnEnd != 1) {
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                           conversion_query  \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                                  |          \n");
			printf("                                                         \"conversion_query\"\n");
			--convqry_count;
			DrawnEnd = 1;
			}
			}

			--convcnt;
			}
        	break;
		}

		
		case 4: {
			printf("                                      |                                      \n");
        	printf("                                      |                                      \n");                
        	printf("                                 class_header                                \n");
           	break;
		}
	}
}
																 
		  



