#ifndef AST_H
#define AST_H

typedef struct ASTNode {
    int type;
    int intValue;
    char* stringValue;
    struct ASTNode* left;
    struct ASTNode* right;
} ASTNode;

typedef struct Symbol {
    char* name;
    int type; // 0=int, 1=bool
    int value;
    int declared;
} Symbol;

typedef struct SymbolTable {
    Symbol* symbols;
    int count;
    int capacity;
} SymbolTable;

extern SymbolTable symbolTable;

ASTNode* createNode(int type, int intValue, char* stringValue, ASTNode* left, ASTNode* right);
void printAST(ASTNode* node, int depth);
void printSymbolTable();
int evaluate(ASTNode* node);
void generateAssembly(ASTNode* node, int depth);

#endif
