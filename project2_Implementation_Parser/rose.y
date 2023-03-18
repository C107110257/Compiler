%{
#include <stdio.h>
#include <string.h>

int mode = 0;

int yylex(void);
void yyerror(char const *s)
{
	extern yylineno;
	if(mode)
	{
		fprintf(stderr, "Syntax error: line %d\n", yylineno);
	}
}
%}
%union{
	int i;
	char *s;
};


%start program
%token ID
%token NST
%token BEG DEQ ELSE END EX FORL IF SE INTG EIF WHL PROG RE TH WR
%token DO DLE SLP ADD SUB MUL DIV REM EQ LEGE GE GEQ LE LEQ AND OR NOT AEQ LPA RPA
%%

program : PROG ID EIF DEQ var_decls BEG statements END SLP	{if(mode)	printf("program -> PROCEDURE ID IS DECLARE var_decls BEG statements END;\n");}
;
var_decls : 					{if(mode)	printf("var_decls -> <empty>\n");}
	| var_decls var_decl		{if(mode)	printf("var_decls -> var_decls var_decl\n");}
;
var_decl : ID DO INTG SLP	{if(mode)	printf("var_decl -> ID : INTEGER;\n");}
;
statements :				{if(mode)	printf("statements -> <empty>\n");}
	| statements statement	{if(mode)	printf("statements -> statements statement\n");}
;
statement : assignment_stmt	{if(mode)	printf("statement -> assignment_stmt\n");}
	| if_stmt				{if(mode)	printf("statement -> if_stmt\n");}
	| for_stmt				{if(mode)	printf("statement -> for_stmt\n");}
	| exit_stmt				{if(mode)	printf("statement -> exit_stmt\n");}
	| read_stmt				{if(mode)	printf("statement -> read_stmt\n");}
	| write_stmt			{if(mode)	printf("statement -> write_stmt\n");}
;
assignment_stmt : ID AEQ arith_expr SLP	{if(mode)	printf("assignment_stmt -> ID := arith_expr;\n");}
;
if_stmt : IF bool_expr TH statements END IF SLP				{if(mode)	printf("if_stmt -> IF bool_expr THEN statements END IF;\n");}
	| IF bool_expr TH statements ELSE statements END IF SLP	{if(mode)	printf("if_stmt -> IF bool_expr THEN statements ELSE statements END IF;\n");}
;
for_stmt : FORL ID SE arith_expr DLE arith_expr WHL statements END WHL SLP	{if(mode)	printf("for_stmt -> FOR ID IN arith_expr .. arith_expr LOOP statements END LOOP;\n");}
;
exit_stmt : EX SLP	{if(mode)	printf("exit_stmt -> EXIT;\n");}
;
read_stmt : RE ID SLP	{if(mode)	printf("read_stmt -> READ ID;\n");}
;
write_stmt : WR arith_expr SLP	{if(mode)	printf("write_stmt -> WRITE arith_expr;\n");}
;
bool_expr : bool_term			{if(mode)	printf("bool_expr -> bool_term\n");}
	| bool_expr OR bool_term	{if(mode)	printf("bool_expr -> bool_expr || bool_term\n");}
;
bool_term : bool_factor			{if(mode)	printf("bool_term -> bool_factor\n");}
	| bool_term AND bool_factor	{if(mode)	printf("bool_term -> bool_term && bool_factor\n");}
;
bool_factor : bool_primary	{if(mode)	printf("bool_factor -> bool_primary\n");}
	| NOT bool_primary		{if(mode)	printf("bool_factor -> ! bool_primary\n");}
;
bool_primary : arith_expr EQ arith_expr	{if(mode)	printf("bool_primary -> arith_expr = arith_expr\n");}
	| arith_expr LEGE arith_expr		{if(mode)	printf("bool_primary -> arith_expr <> arith_expr\n");}
	| arith_expr GE arith_expr			{if(mode)	printf("bool_primary -> arith_expr > arith_expr\n");}
	| arith_expr GEQ arith_expr			{if(mode)	printf("bool_primary -> arith_expr >= arith_expr\n");}
	| arith_expr LE arith_expr			{if(mode)	printf("bool_primary -> arith_expr < arith_expr\n");}
	| arith_expr LEQ arith_expr			{if(mode)	printf("bool_primary -> arith_expr <= arith_expr\n");}
	| LPA bool_expr RPA					{if(mode)	printf("bool_primary -> ( bool_expr )\n");}
;
arith_expr : arith_term			{if(mode)	printf("arith_expr -> arith_term\n");}
	| arith_expr ADD arith_term	{if(mode)	printf("arith_expr -> arith_expr + arith_term\n");}
	| arith_expr SUB arith_term	{if(mode)	printf("arith_expr -> arith_expr - arith_term\n");}
;
arith_term : arith_factor			{if(mode)	printf("arith_term -> arith_factor\n");}
	| arith_term MUL arith_factor	{if(mode)	printf("arith_term -> arith_term * arith_factor\n");}
	| arith_term DIV arith_factor	{if(mode)	printf("arith_term -> arith_term / arith_factor\n");}
	| arith_term REM arith_factor	{if(mode)	printf("arith_term -> arith_term % arith_factor\n");}
;
arith_factor : arith_primary	{if(mode)	printf("arith_factor -> arith_primary\n");}
	| SUB arith_primary			{if(mode)	printf("arith_factor -> - arith_primary\n");}
;
arith_primary : NST			{if(mode)	printf("arith_primary -> CONST\n");}
	| ID					{if(mode)	printf("arith_primary -> ID\n");}
	| LPA arith_expr RPA	{if(mode)	printf("arith_primary -> ( arith_expr )\n");}
;
%%

void main(int argc, char *argv[])
{
	for(int i = 0; i < argc; i++)
	{
		if(strcmp(argv[i], "-p") == 0)
		{
			mode = 1;
			break;
		}
	}
	mode = 1;
	yyparse();
	
	return;
}
