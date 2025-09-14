%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"
#include "parser.tab.h"
%}

%option noyywrap

%%

"int"           { return INT; }
"bool"          { return BOOL; }
"void"          { return VOID; }
"main"          { return MAIN; }
"return"        { return RETURN; }
"true"          { return TRUE; }
"false"         { return FALSE; }

[a-zA-Z][a-zA-Z0-9]* {
    yylval.stringValue = strdup(yytext);
    return ID;
}

[0-9]+ {
    yylval.intValue = atoi(yytext);
    return NUM;
}

"+"             { return PLUS; }
"*"             { return MULT; }
"="             { return ASSIGN; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
";"             { return SEMICOLON; }
","             { return COMMA; }

[ \t\n\r]+      { /* ignorar espacios en blanco */ }

.               { 
    printf("Error léxico: carácter no reconocido '%c'\n", yytext[0]);
    return -1;
}

%%
