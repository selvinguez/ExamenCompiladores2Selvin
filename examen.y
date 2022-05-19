%code requires{
    #include "ast.h"
}

%{
    #include <cstdio>
    #include <fstream>
    #include <iostream>
    #include <map>
    #include <string_view>
    #include <string>
    #include <cstring>
    using namespace std;
    int yylex();

     map<string, float> variables;
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
   Expr * expr_t;
   Statement * statement_t;
    float int_t;
    char * string_t;
}

%token TK_PRINT
%type<int_t> expres_Total relacionalExpre expression;

%token  TK_PUNTOCOMA TK_MAS TK_MENOS TK_MULTI 
%token TK_DIVI  TK_IGUAL TK_LET TK_IF TK_BEGIN TK_END TK_IGUALIGUAL TK_MAYOR  TK_MENOR TK_COMIA
/*%token TK_MAYOR TK_MENOR TK_IGUALIGUALTK_COMIA */
%token<int_t> TK_NUMBER 
%token<string_t> TK_IDENTIFICADOR
%type<int_t> term factor assignment_stmt


%%

input: statement_list
    ;

statement_list: %empty
    | statement_list statement
    ;

statement: TK_PRINT '(' expres_Total ')' TK_PUNTOCOMA   { printf("%f\n",$3); }
    | assignment_stmt
    | if_stmt
    | expression TK_PUNTOCOMA
    | metodos_statement
 ;


 metodos_statement: TK_LET TK_IDENTIFICADOR '(' identificador_list ')' TK_IGUAL TK_BEGIN statement_list TK_END;
 
 identificador_list: %empty | identificador_list TK_IDENTIFICADOR
                    | TK_COMIA 
                    ;

if_stmt: TK_IF '(' expres_Total ')' TK_BEGIN statement_list  TK_END ;



assignment_stmt: TK_LET TK_IDENTIFICADOR TK_IGUAL expres_Total TK_PUNTOCOMA { 
    //Mire con esta condicion actualizo el valor cuando la vuelve a declarar
    if(variables.count($2)){
        variables.find($2)->second = $4;
    
    }else{
        variables.insert(make_pair($2,$4)); 
    }
    
    }
    ;

expres_Total: expres_Total TK_IGUALIGUAL relacionalExpre {$$ =$1 == $3;}
    | relacionalExpre {$$ = $1;}
    ;
relacionalExpre: relacionalExpre  TK_MAYOR expression {$$ = $1>$3;}
    | relacionalExpre TK_MENOR expres_Total {$$ = $1<$3;}
    | expression {$$ = $1;};
    ;
expression: expression TK_MAS factor { $$ = $1 + $3; }
    | expression TK_MENOS factor { $$ = $1 - $3; }
    | factor { $$ = $1; }
    ;
factor: factor TK_MULTI term { $$ = $1 * $3; }
    | factor TK_DIVI term { $$ = $1 / $3; }
    | term { $$ = $1; }
    ;
term: TK_NUMBER { $$ = $1; }
    | TK_IDENTIFICADOR { if(variables.count($1)){ $$ = variables.find($1)->second;} else { printf("Error: variable %s no existe.\n",$1); return 0;} }
    ;


%%