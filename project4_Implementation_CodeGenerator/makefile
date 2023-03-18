tree: lex.yy.c rose.tab.c rose.tab.h tree.c
	gcc -o rose.exe lex.yy.c rose.tab.c tree.c codegen.c

rose.tab.c rose.tab.h: rose.y 
	bison -d rose.y

lex.yy.c : rose.l 
	flex rose.l

clean :
	rm -f lex.yy.c rose.tab.c rose.tab.h tree.exe
