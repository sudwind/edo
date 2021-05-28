%{

#include <stdio.h> 
#include <string.h>
#include "sintactico.tab.h"
#include "common.h"

void CargarSubCadenas();
extern int SubIndice, SubIndiceMax, NumLineas;
extern int should_kill;
%}

EXTRA [A-Za-z0-9_-]
NO ({EXTRA})+

%% 

"class_header" { printf("\n Lectura de token: CLS_HDR");
                CargarSubCadenas("CLS_HDR"); 
				return (CLS_HDR);}

"note"						{printf("\n Lectura de token: note  ");
                CargarSubCadenas("NOTE"); return (NOTE);} 
                       
","             {printf("\n Lectura de token: COMA  ");
                CargarSubCadenas("COMA"); return (COMA);}

"convert" 			{printf("\n Lectura de token: CONVERT  ");
                CargarSubCadenas("CONV"); return (CONV);}

"conversion_procedure"           {printf("\n Lectura de token: conversion_procedure  ");
                CargarSubCadenas("CONV_PROC"); return (CONV_PROC);}

"conversion_query"           {printf("\n Lectura de token: conversion_query  ");
                CargarSubCadenas("CONV_QRY"); return (CONV_QRY);}
                       

\n              {
					SubIndiceMax = SubIndice;
					SubIndice = 0;
					NumLineas++;
					return(NL);
				}


[ \t]           /* suprime espacios en blanco */



{NO}             {printf("\nError lexico, cadena inesperada: ");ECHO; printf("\nEXPRESION INVALIDA\n");}

<<EOF>> { return (EOF); }


%%

void CargarSubCadenas(char* NomToken) {
	Lexema[SubIndice] = (char*) malloc(strlen(yytext) + 1);
	strcpy(Lexema[SubIndice], yytext);
	Token[SubIndice] = (char*) malloc(strlen(NomToken) + 1);
	strcpy(Token[SubIndice], NomToken);
	SubIndice++;
}
         
int DibujarTabla(){
    int ContAuxT, ContAuxK;
    int LargoToken, LargoIzq, LargoDer;

    printf("\n==============================TABLA DE SIMBOLOS================================\n");
    printf("|                LEXEMAS               |                 TOKENS               |\n");
	printf("---------------------------------------+---------------------------------------\n");

	   for (ContAuxK=0;ContAuxK<SubIndiceMax;ContAuxK++){
		LargoToken=38-strlen(Lexema[ContAuxK]);
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		printf("|");
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Lexema[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|");
	
		LargoToken=38-strlen(Token[ContAuxK]);
		if ((LargoToken & 1)==0){
			LargoIzq=LargoToken/2;
		}else{
			LargoIzq=(LargoToken+1)/2;
		}
		LargoDer=LargoToken-LargoIzq;
		for (ContAuxT=0;ContAuxT<LargoIzq;ContAuxT++){
			printf(" ");
		}
		printf("%s",Token[ContAuxK]);
		for (ContAuxT=0;ContAuxT<LargoDer;ContAuxT++){
			printf(" ");
		}
		printf("|\n");
	}
	printf("===============================================================================\n\n\n");
	return 0;
}

