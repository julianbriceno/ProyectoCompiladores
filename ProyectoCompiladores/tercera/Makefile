all:
	bison -d parser.y
	flex scanner.l
	g++ lex.yy.c parser.tab.c -o parser
clean:
	rm lex.yy.c
	rm parser.tab.c
	rm parser.tab.h
	rm parser
