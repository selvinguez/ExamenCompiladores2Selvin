%option yylineno
%option noyywrap

%{
    #include "tokens.h"
%}

IDENTIFICADOR [A-Za-z][A-Za-z0-9]*
NUM [0-9]+("."[0-9]+)?

%%
[ \t\n\r] {/*ignore*/ }

"print" { return TK_PRINT; }
"let" {return TK_LET;}
"if" {return TK_IF;}
"begin" {return TK_BEGIN;}
"end" {return TK_END;}

{NUM} { yylval.int_t = atoi(yytext); return TK_NUMBER;}
{IDENTIFICADOR} { yylval.string_t = strdup(yytext); return TK_IDENTIFICADOR;}
"==" {return TK_IGUALIGUAL;}
"=" {return TK_IGUAL;}
";" { return TK_PUNTOCOMA;}

"+" { return TK_MAS;}
"-" { return TK_MENOS;}
"*" { return TK_MULTI;}
"/" { return TK_DIVI;}

">" {return TK_MAYOR;}
"<" {return TK_MENOR;}

"," { return TK_COMIA; }

"(" { return '('; }
")" { return ')'; }


. {printf("Invalid character %c, line %d\n", yytext[0], yylineno); yyterminate();}
%%


/*
"return" {return TK_RETURN;}
"begin" {return TK_BEGIN;}
"end" {return TK_END;}*/
/*

"," { return TK_COMIA; }
*/