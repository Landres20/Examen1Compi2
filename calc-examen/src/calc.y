%code requires{
    #include "ast.h"
}

%{
    #include <cstdio>
    #include <fstream>
    #include <iostream>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
    float flotante;
    char * id_t;
    Declaration * declaracion;
    Expr * expr_t;
    Statement * statement_t;
}

%token<flotante> FLOAT_T
%token<id_t> ID
%token TK_PRINT
%token TK_SUMA
%token TK_RESTA
%token TK_MULT
%token TK_DIV
%token TK_LT
%token TK_GT
%token TK_EQEQ
%token TK_IF
%token LET
%token BEGIN
%token END
%token ASSIG
%token DO
%token DONE

%type<flotante> expr term rela_expr factor;
%type<statement_t> statement;
%type<id_t> assi_ id;

%%

program: statements
;

statements: statements statement
          | statement 
          ;

statement: TK_PRINT '(' expr ')' ';' { $$ = new PrintStatement(yylineno, $3); }
          ;

statement: LET assi_
         | func_call { }
         | LET ID '(' PARAM_LIST ')' ASSIG block { printf("Method %s declarared\n",$2); }
         | expr { printf("Result = %f\n",$1); }
;

block: TK_IF '(' expr ')' DO cosa
     | expr
;

cosa: assi_ ';' assi_ DONE func_call
    | assi_ ';'
    | expr  ';' expr DONE func_call
;

assi_: ID ASSIG expr { printf("Variable %s declared\n", $1); }

func_call: ID '(' PARAM_LIST ')'
;

PARAM_LIST: ID ',' PARAM_LIST
    | expr ',' PARAM_LIST { printf("Return: %f",$1); }
    | ID 
    | FLOAT_T
;

expr: expr TK_SUMA term { $$ = $1 + $3; }
    | expr TK_RESTA term { $$ = $1 - $3; }
    | term { $$ = $1; }
;

term: term TK_MULT factor { $$ = $1 * $3; }
    | term TK_DIV factor { $$ = $1 / $3; }
    | rela_expr { $$ = $1; }
;

rela_expr: rela_expr TK_GT factor { $$ = $1 > $3; }
         | rela_expr TK_LT factor { $$ = $1 < $3; }
         | factor { $$ = $1; }
;

factor: FLOAT_T { $$ = $1; }
      | id
      | '(' expr ')' { $$ = $2; }
;

id: ID { $$ = $1; }
;

%%
