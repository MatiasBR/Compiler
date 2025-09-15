%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror(const char* s);
int yyparse();
%}

%union {
    int intValue;
    char* stringValue;
    ASTNode* node;
}

%token <intValue> NUM
%token <stringValue> ID
%token INT BOOL VOID MAIN RETURN TRUE FALSE
%token PLUS MULT ASSIGN LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA

%type <node> program main_decl block decl_list decl stmt_list stmt expr
%type <stringValue> type var_list

%%

program:
    main_decl block
    {
        $$ = createNode(0, 0, "PROGRAM", $1, $2);
        printf("Programa parseado correctamente\n");
        printf("\n=== AST ===\n");
        printAST($$, 0);
        printSymbolTable();
        printf("\n=== PSEUDO-ASSEMBLY ===\n");
        generateAssembly($$, 0);
        
        printf("\n=== INTERPRETACIÓN ===\n");
        int result = interpretProgram($$);
        printf("Valor de retorno: %d\n", result);
        printf("\n=== TABLA DE SÍMBOLOS FINAL ===\n");
        printSymbolTable();
    }
;

main_decl:
    type MAIN LPAREN RPAREN
    {
        $$ = createNode(1, 0, $1, NULL, NULL);
    }
;

type:
    INT { $$ = "int"; }
    | BOOL { $$ = "bool"; }
    | VOID { $$ = "void"; }
;

block:
    LBRACE decl_list stmt_list RBRACE
    {
        $$ = createNode(2, 0, "BLOCK", $2, $3);
    }
;

decl_list:
    decl_list decl
    {
        $$ = createNode(3, 0, "DECL_LIST", $1, $2);
    }
    | /* empty */
    {
        $$ = createNode(3, 0, "DECL_LIST", NULL, NULL);
    }
;

decl:
    type var_list SEMICOLON
    {
        $$ = createNode(4, 0, "DECL", NULL, NULL);
        char* varType = $1;
        char* varName = $2;
        
        int exists = 0;
        for(int i = 0; i < symbolTable.count; i++) {
            if(strcmp(symbolTable.symbols[i].name, varName) == 0) {
                exists = 1;
                break;
            }
        }
        
        if(!exists) {
            if(symbolTable.count >= symbolTable.capacity) {
                symbolTable.capacity *= 2;
                symbolTable.symbols = realloc(symbolTable.symbols, symbolTable.capacity * sizeof(Symbol));
            }
            
            symbolTable.symbols[symbolTable.count].name = strdup(varName);
            symbolTable.symbols[symbolTable.count].type = (strcmp(varType, "int") == 0) ? 0 : 1;
            symbolTable.symbols[symbolTable.count].value = 0;
            symbolTable.symbols[symbolTable.count].declared = 1;
            symbolTable.count++;
        }
    }
;

var_list:
    var_list COMMA ID
    {
        $$ = $3;
    }
    | ID
    {
        $$ = $1;
    }
;

stmt_list:
    stmt_list stmt
    {
        $$ = createNode(5, 0, "STMT_LIST", $1, $2);
    }
    | /* empty */
    {
        $$ = createNode(5, 0, "STMT_LIST", NULL, NULL);
    }
;

stmt:
    ID ASSIGN expr SEMICOLON
    {
        $$ = createNode(6, 0, "ASSIGN", NULL, $3);
        $$->stringValue = strdup($1);
    }
    | RETURN expr SEMICOLON
    {
        $$ = createNode(7, 0, "RETURN", $2, NULL);
    }
    | RETURN SEMICOLON
    {
        $$ = createNode(7, 0, "RETURN", NULL, NULL);
    }
;

expr:
    expr PLUS expr
    {
        $$ = createNode(8, 0, "PLUS", $1, $3);
    }
    | expr MULT expr
    {
        $$ = createNode(9, 0, "MULT", $1, $3);
    }
    | LPAREN expr RPAREN
    {
        $$ = $2;
    }
    | NUM
    {
        $$ = createNode(10, $1, "NUM", NULL, NULL);
    }
    | ID
    {
        $$ = createNode(11, 0, "ID", NULL, NULL);
        $$->stringValue = strdup($1);
    }
    | TRUE
    {
        $$ = createNode(12, 1, "TRUE", NULL, NULL);
    }
    | FALSE
    {
        $$ = createNode(12, 0, "FALSE", NULL, NULL);
    }
;

%%

SymbolTable symbolTable;

ASTNode* createNode(int type, int intValue, char* stringValue, ASTNode* left, ASTNode* right) {
    ASTNode* node = malloc(sizeof(ASTNode));
    node->type = type;
    node->intValue = intValue;
    node->stringValue = stringValue ? strdup(stringValue) : NULL;
    node->left = left;
    node->right = right;
    return node;
}

void printAST(ASTNode* node, int depth) {
    if(!node) return;
    
    for(int i = 0; i < depth; i++) printf("  ");
    
    switch(node->type) {
        case 0: printf("PROGRAM\n"); break;
        case 1: printf("MAIN\n"); break;
        case 2: printf("BLOCK\n"); break;
        case 3: printf("DECL_LIST\n"); break;
        case 4: printf("DECL\n"); break;
        case 5: printf("STMT_LIST\n"); break;
        case 6: printf("ASSIGN(%s)\n", node->stringValue); break;
        case 7: printf("RETURN\n"); break;
        case 8: printf("PLUS\n"); break;
        case 9: printf("MULT\n"); break;
        case 10: printf("NUM(%d)\n", node->intValue); break;
        case 11: printf("ID(%s)\n", node->stringValue); break;
        case 12: printf("BOOL(%d)\n", node->intValue); break;
    }
    
    printAST(node->left, depth + 1);
    printAST(node->right, depth + 1);
}

void printSymbolTable() {
    printf("\n=== TABLA DE SÍMBOLOS ===\n");
    for(int i = 0; i < symbolTable.count; i++) {
        printf("Variable: %s, Tipo: %s, Valor: %d\n", 
               symbolTable.symbols[i].name,
               symbolTable.symbols[i].type == 0 ? "int" : "bool",
               symbolTable.symbols[i].value);
    }
}

int evaluate(ASTNode* node) {
    if(!node) return 0;
    
    switch(node->type) {
        case 10: // NUM
            return node->intValue;
        case 12: // BOOL
            return node->intValue;
        case 11: // ID
            for(int i = 0; i < symbolTable.count; i++) {
                if(strcmp(symbolTable.symbols[i].name, node->stringValue) == 0) {
                    return symbolTable.symbols[i].value;
                }
            }
            printf("Error: Variable '%s' no declarada\n", node->stringValue);
            return 0;
        case 8: // PLUS
            return evaluate(node->left) + evaluate(node->right);
        case 9: // MULT
            return evaluate(node->left) * evaluate(node->right);
        default:
            return 0;
    }
}

void generateAssembly(ASTNode* node, int depth) {
    if(!node) return;
    
    switch(node->type) {
        case 6: // ASSIGN
            generateAssembly(node->right, depth);
            printf("  STORE %s\n", node->stringValue);
            break;
        case 7: // RETURN
            if(node->left) {
                generateAssembly(node->left, depth);
                printf("  RET\n");
            } else {
                printf("  RET\n");
            }
            break;
        case 8: // PLUS
            generateAssembly(node->left, depth);
            generateAssembly(node->right, depth);
            printf("  ADD\n");
            break;
        case 9: // MULT
            generateAssembly(node->left, depth);
            generateAssembly(node->right, depth);
            printf("  MUL\n");
            break;
        case 10: // NUM
            printf("  LOAD %d\n", node->intValue);
            break;
        case 11: // ID
            printf("  LOAD %s\n", node->stringValue);
            break;
        case 12: // BOOL
            printf("  LOAD %d\n", node->intValue);
            break;
        default:
            generateAssembly(node->left, depth);
            generateAssembly(node->right, depth);
    }
}

int interpretProgram(ASTNode* node) {
    if(!node) return 0;
    
    if(node->type == 0) { // PROGRAM
        return interpretProgram(node->right);
    }
    else if(node->type == 2) { // BLOCK
        return interpretStatements(node->right);
    }
    
    return 0;
}

int interpretStatements(ASTNode* node) {
    if(!node) return 0;
    
    if(node->type == 5) { // STMT_LIST
        if(node->left) {
            interpretStatements(node->left);
        }
        if(node->right) {
            return interpretStatement(node->right);
        }
    }
    else {
        return interpretStatement(node);
    }
    
    return 0;
}

int interpretStatement(ASTNode* node) {
    if(!node) return 0;
    
    switch(node->type) {
        case 6: { // ASSIGN
            int value = evaluate(node->right);
            for(int i = 0; i < symbolTable.count; i++) {
                if(strcmp(symbolTable.symbols[i].name, node->stringValue) == 0) {
                    symbolTable.symbols[i].value = value;
                    printf("Asignación: %s = %d\n", node->stringValue, value);
                    break;
                }
            }
            return value;
        }
        case 7: { // RETURN
            if(node->left) {
                int value = evaluate(node->left);
                printf("Return: %d\n", value);
                return value;
            } else {
                printf("Return: void\n");
                return 0;
            }
        }
        default:
            return 0;
    }
}

void yyerror(const char* s) {
    printf("Error de sintaxis en línea %d: %s\n", yylineno, s);
}

int main() {
    // Inicializar tabla de símbolos
    symbolTable.capacity = 10;
    symbolTable.count = 0;
    symbolTable.symbols = malloc(symbolTable.capacity * sizeof(Symbol));
    
    printf("Compilador iniciado. Ingrese un programa:\n");
    
    if(yyparse() == 0) {
        printf("\n=== AST ===\n");
        // El AST se imprime desde la regla program
        printSymbolTable();
    }
    
    return 0;
}
