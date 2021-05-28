@echo off

bison -d sintactico.y
flex lexico.l
gcc sintactico.tab.c lex.yy.c -o analizador.exe
strip --strip-unneeded analizador.exe