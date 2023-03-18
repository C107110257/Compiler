%option noyywrap
%option yylineno

%{
/* auxiliary declarations*/
%}



/* regular definitions */

LETTER       [_A-Z]
INTEGER      [0-9]+
id           {LETTER}({LETTER}|{INTEGER})*
white_space  [ \t\n]
comment      "//".*"\n"
error        .


/* translation rules*/
%%
{id}            {printf("Identifier: %s\n",yytext);}
{INTEGER}       {printf("Integer Constant: %s\n",yytext);}
{white_space}   {/*nothing*/}
{comment}       {/*nothing*/}

"begin"         {printf("Keyword: %s\n",yytext);}
"declare"       {printf("Keyword: %s\n",yytext);}
"else"          {printf("Keyword: %s\n",yytext);}
"end"           {printf("Keyword: %s\n",yytext);}
"exit"          {printf("Keyword: %s\n",yytext);}
"for"           {printf("Keyword: %s\n",yytext);}
"if"            {printf("Keyword: %s\n",yytext);}
"in"            {printf("Keyword: %s\n",yytext);}
"integer"       {printf("Keyword: %s\n",yytext);}
"is"            {printf("Keyword: %s\n",yytext);}
"loop"          {printf("Keyword: %s\n",yytext);}
"procedure"     {printf("Keyword: %s\n",yytext);}
"read"          {printf("Keyword: %s\n",yytext);}
"then"          {printf("Keyword: %s\n",yytext);}
"write"         {printf("Keyword: %s\n",yytext);}

":"             {printf("Operator: %s\n",yytext);}
".."            {printf("Operator: %s\n",yytext);}
";"             {printf("Operator: %s\n",yytext);}
"+"             {printf("Operator: %s\n",yytext);}
"-"             {printf("Operator: %s\n",yytext);}
"*"             {printf("Operator: %s\n",yytext);}
"/"             {printf("Operator: %s\n",yytext);}
"%"             {printf("Operator: %s\n",yytext);}
"="             {printf("Operator: %s\n",yytext);}
"<>"            {printf("Operator: %s\n",yytext);}
">"             {printf("Operator: %s\n",yytext);}
">="            {printf("Operator: %s\n",yytext);}
"<"             {printf("Operator: %s\n",yytext);}
"<="            {printf("Operator: %s\n",yytext);}
"&&"            {printf("Operator: %s\n",yytext);}
"||"            {printf("Operator: %s\n",yytext);}
"!"             {printf("Operator: %s\n",yytext);}
":="            {printf("Operator: %s\n",yytext);}
"("             {printf("Operator: %s\n",yytext);}
")"             {printf("Operator: %s\n",yytext);}

{error}         {fprintf(stderr,"Lexical error: line %d:unknown cheracter %s\n",yylineno,yytext);}
%%




/* auxiliary procedures*/
int  main(){

    yylex();

    return 0;
}