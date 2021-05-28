
bison -d -t -v sintactico.y
flex lexico.l
gcc -Wall -Wextra -g3 -ggdb sintactico.tab.c lex.yy.c -DDEBUGGO_MODDO -o analizador.exe