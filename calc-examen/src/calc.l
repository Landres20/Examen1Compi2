%option yylineno
%option noyywrap

%{
    #include "tokens.h"
%}

DIGIT[0-9]

%%
"print" { return TK_PRINT; }
"+" { return TK_SUMA; }
"-" { return TK_RESTA; }
"*" { return TK_MULT; }
"/" { return TK_DIV; }
"=" { return '='; }
"<" { return TK_LT; }
">" { return TK_GT; }
"==" { return TK_EQEQ; }
"(" { return '('; }
")" { return ')'; }
";" { return ';'; }
"," { return ','; }
"." { return '.'; }
"let" { return LET; }
"if" { return IF; }
"begin" { return BEGIN; }
"end" { return END; }

{DIGIT}+ { yyval.flotante = atof(yytext); return FLOAT_T; }
{DIGIT}+"."{DIGIT}+ { yylval.flotante = atof(yytext); return FLOAT_T; }
. {printf("Invalid character %c, line %d\n", yytext[0], yylineno); yyterminate();}
%%