# Compilador de Expresiones con Variables

Compilador completo que extiende una gramática de expresiones con declaraciones de variables, asignaciones y función main.

## Características

- **Análisis Léxico**: Flex/Lex
- **Análisis Sintáctico**: Bison/Yacc  
- **AST**: Árbol Sintáctico Abstracto
- **Tabla de Símbolos**: Gestión de variables
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

## Salida

El compilador genera:
1. **AST**: Árbol sintáctico abstracto
2. **Tabla de Símbolos**: Variables declaradas
3. **Pseudo-Assembly**: Código intermedio

## Archivos

- `lexer.l` - Analizador léxico
- `parser.y` - Analizador sintáctico  
- `ast.h` - Definiciones de estructuras
- `Makefile` - Compilación
- `test*.txt` - Archivos de prueba