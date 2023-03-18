%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include "rose.tab.h"
#include "tree.h"
%}



/* regular definitions */

letter       [_A-Z]
const        [0-9]+
id           {letter}({letter}|{const})*
white_space  [ \t\n]
comment      "//".*"\n"
error        .


/* translation rules*/
%%
{id}            {yylval.name = strdup(yytext); return ID;     }
{const}         {yylval.value = atoi(yytext); return CONST;    }
{white_space}   {/*nothing*/    }
{comment}       {/*nothing*/    }

"begin"         {return BEG;    }
"declare"       {return DEQ;    }
"else"          {return ELSE;   }
"end"           {return END;    }
"exit"          {return EXIT;   }
"for"           {return FOR;    }
"if"            {return IF;     }
"in"            {return SE;     }
"integer"       {return INTG;   }
"is"            {return EIF;    }
"loop"          {return WHL;    }
"procedure"     {return PROCEDURE;}
"read"          {return READ;   }
"then"          {return TH;     }
"write"         {return WRITE;  }    

":"             {return DO;     }
".."            {return DLE;    }
";"             {return SLP;    }
"+"             {return ADD;    }
"-"             {return SUB;    }
"*"             {return MUL;    }
"/"             {return DIV;    }
"%"             {return MOD;    }
"="             {return EQ;     }
"<>"            {return NE;     }
">"             {return GT;     }
">="            {return GE;     }
"<"             {return LT;     }
"<="            {return LE;     }
"&&"            {return AND;    }
"||"            {return OR;     }
"!"             {return NOT;    }
":="            {return ASSIGN; }
"("             {return LPA;    }
")"             {return RPA;    }

{error}         yyerror("L_error");
%%
