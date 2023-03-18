parser: lex.yy.c rose.tab.c rose.tab.h
	gcc -o parser lex.yy.c rose.tab.c

rose.tab.c rose.tab.h: rose.y 
	bison -d rose.y

lex.yy.c : rose.l 
	flex rose.l

clean :
	rm -f lex.yy.c rose.tab.c rose.tab.h parser.exe
