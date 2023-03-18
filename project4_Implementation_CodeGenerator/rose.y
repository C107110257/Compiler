%{
#include <stdio.h>
#include <string.h>
#include "tree.h"

int mode = 0;
int yylex(void);



void yyerror(char const *s){
	extern yylineno;
	if(mode)
	{
		fprintf(stderr, "Syntax error: line %d\n", yylineno);
	}
}
%}

%union{
	int i;
	int value;
	char *s;
	char *name;
	struct tree_node *tree;
};


%start program
%token ID
%token CONST
%token BEG DEQ ELSE END EXIT FOR IF SE INTG EIF WHL PROCEDURE READ TH WRITE NIL IFTHEN IFTHENELSE DLIST SLIST MINUS
%token DO DLE SLP ADD SUB MUL DIV MOD EQ NE GT GE LT LE AND OR NOT ASSIGN LPA RPA
  
%type <name>  ID
%type <value> CONST
%type <tree> program var_decls var_decl statements statement assignment_stmt if_stmt for_stmt exit_stmt write_stmt read_stmt bool_expr bool_term bool_factor bool_primary arith_expr arith_term arith_factor arith_primary
%%


program : PROCEDURE ID EIF DEQ var_decls BEG statements END SLP	{if(mode)	$$=gen_code(build_procedure($5,$7));}
;

var_decls : 						{if(mode)	$$=build_emptylist();}
;
var_decls :var_decls var_decl		{if(mode)	$$=build_decllist($1,$2);}
;
var_decl : ID DO INTG SLP			{if(mode)	$$=build_id($1);}
;
statements :						{if(mode)	$$=build_emptylist();}
;
statements : statements statement	{if(mode)	$$=build_stmtlist($1,$2);}
;
statement : assignment_stmt	
	| if_stmt				
	| for_stmt				
	| exit_stmt				
	| read_stmt				
	| write_stmt			
;
assignment_stmt : ID ASSIGN arith_expr SLP									{if(mode)	$$=build_assign($1,$3);}
;
if_stmt : IF bool_expr TH statements END IF SLP								{if(mode)	$$=build_ifthen($2,$4);}
;
if_stmt : IF bool_expr TH statements ELSE statements END IF SLP				{if(mode)	$$=build_ifthenelse($2,$4,$6);}
;
for_stmt : FOR ID SE arith_expr DLE arith_expr WHL statements END WHL SLP	{if(mode)	$$=build_for($2,$4,$6,$8);}
;
exit_stmt : EXIT SLP							{if(mode)	$$=build_exit();}
;
read_stmt : READ ID SLP							{if(mode)	$$=build_read($2);}
;
write_stmt : WRITE arith_expr SLP				{if(mode)	$$=build_write($2);}
;
bool_expr : bool_term	
;			
bool_expr : bool_expr OR bool_term				{if(mode)	$$=build_or($1,$3);}
;
bool_term : bool_factor			
;
bool_term : bool_term AND bool_factor			{if(mode)	$$=build_and($1,$3);}
;
bool_factor : bool_primary	
;
bool_factor : NOT bool_primary					{if(mode)	$$=build_not($2);}
;
bool_primary : arith_expr EQ arith_expr			{if(mode)	$$=build_eq($1,$3);}
;
bool_primary : arith_expr NE arith_expr			{if(mode)	$$=build_ne($1,$3);}
;
bool_primary : arith_expr GT arith_expr			{if(mode)	$$=build_gt($1,$3);}
;
bool_primary : arith_expr GE arith_expr			{if(mode)	$$=build_ge($1,$3);}
;
bool_primary : arith_expr LT arith_expr			{if(mode)	$$=build_lt($1,$3);}
;
bool_primary : arith_expr LE arith_expr			{if(mode)	$$=build_le($1,$3);}
;
bool_primary : LPA bool_expr RPA					
;
arith_expr : arith_term			
;
arith_expr : arith_expr ADD arith_term			{if(mode)	$$=build_add($1,$3);}
;
arith_expr : arith_expr SUB arith_term			{if(mode)	$$=build_sub($1,$3);}
;
arith_term : arith_factor			
;
arith_term : arith_term MUL arith_factor		{if(mode)	$$=build_mul($1,$3);}
;
arith_term : arith_term DIV arith_factor		{if(mode)	$$=build_div($1,$3);}
;
arith_term : arith_term MOD arith_factor		{if(mode)	$$=build_mod($1,$3);}
;
arith_factor : arith_primary	
;
arith_factor : SUB arith_primary				{if(mode)	$$=build_minus($2);}
;
arith_primary : CONST							{if(mode)	$$=build_const($1);}
;
arith_primary : ID								{if(mode)	$$=build_id($1);}
;
arith_primary : LPA arith_expr RPA				{if(mode)	$$=build_pa($2);}
;
%%

void main(int argc, char *argv[])
{
	for(int i = 0; i < argc; i++)
	{
		if(strcmp(argv[i], "-t") == 0)
		{
			mode = 1;
			break;
		}
	}
	mode = 1;
	yyparse();
	
	return;
}
