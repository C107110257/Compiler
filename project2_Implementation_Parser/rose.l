%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include "rose.tab.h"
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
{id}            {return ID;     }
{const}         {return NST;    }
{white_space}   {/*nothing*/    }
{comment}       {/*nothing*/    }

"begin"         {return BEG;    }
"declare"       {return DEQ;    }
"else"          {return ELSE;   }
"end"           {return END;    }
"exit"          {return EX;     }
"for"           {return FORL;   }
"if"            {return IF;     }
"in"            {return SE;     }
"integer"       {return INTG;   }
"is"            {return EIF;    }
"loop"          {return WHL;    }
"procedure"     {return PROG;   }
"read"          {return RE;     }
"then"          {return TH;     }
"write"         {return WR;     }    

":"             {return DO;     }
".."            {return DLE;    }
";"             {return SLP;    }
"+"             {return ADD;    }
"-"             {return SUB;    }
"*"             {return MUL;    }
"/"             {return DIV;    }
"%"             {return REM;    }
"="             {return EQ;     }
"<>"            {return LEGE;   }
">"             {return GE;     }
">="            {return GEQ;    }
"<"             {return LE;     }
"<="            {return LEQ;    }
"&&"            {return AND;    }
"||"            {return OR;     }
"!"             {return NOT;    }
":="            {return AEQ;    }
"("             {return LPA;    }
")"             {return RPA;    }

{error}         yyerror("L_error");
%%
