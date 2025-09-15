# Compilador e Intérprete de Expresiones con Variables

Compilador completo que extiende una gramática de expresiones con declaraciones de variables, asignaciones y función main. Incluye análisis léxico, sintáctico, generación de AST, tabla de símbolos, interpretación de expresiones y generación de pseudo-assembly.

## Características

- **Análisis Léxico**: Flex/Lex
- **Análisis Sintáctico**: Bison/Yacc  
- **AST**: Árbol Sintáctico Abstracto
- **Tabla de Símbolos**: Gestión de variables con verificación de tipos
- **Intérprete**: Evaluación de expresiones y ejecución de asignaciones
- **Pseudo-Assembly**: Código intermedio

## Tipos Soportados

- `int`: Números enteros
- `bool`: Valores lógicos (true/false)
- `void`: Sin retorno

## Sintaxis

```c
// Declaración de variables
int x;
bool flag;

// Función main
int main() {
    int x;
    x = 5;
    return x;
}

// Expresiones
x = 1 + 2 * 3;
return (x + y) * 2;
```

## Instalación

```bash
# Instalar dependencias
sudo apt update
sudo apt install -y build-essential flex bison

# Compilar
make clean
make
```

## Uso

```bash
# Modo interactivo
./compiler

# Con archivo
echo "int main(){int x; x=5; return x;}" | ./compiler

# Pruebas
make test
```

## Ejemplo de Salida

```bash
$ echo "int main(){int x; int y; x = 5; y = 3; return x + y;}" | ./compiler

Programa parseado correctamente

=== AST ===
PROGRAM
  MAIN
  BLOCK
    DECL_LIST
      DECL_LIST
        DECL_LIST
        DECL
      DECL
    STMT_LIST
      STMT_LIST
        STMT_LIST
          STMT_LIST
          ASSIGN(x)
            NUM(5)
        ASSIGN(y)
          NUM(3)
      RETURN
        PLUS
          ID(x)
          ID(y)

=== TABLA DE SÍMBOLOS ===
Variable: x, Tipo: int, Valor: 0
Variable: y, Tipo: int, Valor: 0

=== PSEUDO-ASSEMBLY ===
  LOAD 5
  STORE x
  LOAD 3
  STORE y
  LOAD x
  LOAD y
  ADD
  RET

=== INTERPRETACIÓN ===
Asignación: x = 5
Asignación: y = 3
Return: 8
Valor de retorno: 8

=== TABLA DE SÍMBOLOS FINAL ===
Variable: x, Tipo: int, Valor: 5
Variable: y, Tipo: int, Valor: 3
```

## Salida

El compilador genera:
1. **AST**: Árbol sintáctico abstracto
2. **Tabla de Símbolos**: Variables declaradas con tipos
3. **Pseudo-Assembly**: Código intermedio
4. **Interpretación**: Ejecución de asignaciones y evaluación de expresiones
5. **Valor de Retorno**: Resultado final de la función main

## Archivos

- `lexer.l` - Analizador léxico
- `parser.y` - Analizador sintáctico  
- `ast.h` - Definiciones de estructuras
- `Makefile` - Compilación
- `test*.txt` - Archivos de prueba