CC = gcc
LEX = flex
YACC = bison
CFLAGS = -Wall -g

all: compiler

compiler: lex.yy.c parser.tab.c ast.h
	$(CC) $(CFLAGS) -o compiler lex.yy.c parser.tab.c -lfl

lex.yy.c: lexer.l parser.tab.h
	$(LEX) lexer.l

parser.tab.c parser.tab.h: parser.y
	$(YACC) -d parser.y

clean:
	rm -f lex.yy.c parser.tab.c parser.tab.h compiler

test: compiler
	@echo "Probando con ejemplo 1:"
	@echo "void main(){int x; int y; x = 1 ; y=1; x = x+3*2*y; }" | ./compiler
	@echo "\nProbando con ejemplo 2:"
	@echo "int main(){int x; int y; x = 1 ; x = x+3*2*y; return x; y = 4; x = 2; return y*2;}" | ./compiler
	@echo "\nProbando con ejemplo 3:"
	@echo "bool main(){bool flag; int x; flag = true; x = 5; return flag;}" | ./compiler

install-deps:
	sudo apt update
	sudo apt install -y build-essential flex bison

.PHONY: all clean test install-deps
