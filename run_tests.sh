#!/bin/bash

echo "=== COMPILADOR DE EXPRESIONES CON VARIABLES ==="
echo

# Verificar si el compilador existe
if [ ! -f "./compiler" ]; then
    echo "Error: El compilador no existe. Ejecute 'make' primero."
    exit 1
fi

echo "=== EJECUTANDO PRUEBAS AUTOMÁTICAS ==="
echo

echo "Prueba 1: void main(){int x; int y; x = 1 ; y=1; x = x+3*2*y; }"
echo "void main(){int x; int y; x = 1 ; y=1; x = x+3*2*y; }" | ./compiler
echo

echo "Prueba 2: int main(){int x; int y; x = 1 ; x = x+3*2*y; return x; y = 4; x = 2; return y*2;}"
echo "int main(){int x; int y; x = 1 ; x = x+3*2*y; return x; y = 4; x = 2; return y*2;}" | ./compiler
echo

echo "Prueba 3: bool main(){bool flag; int x; flag = true; x = 5; return flag;}"
echo "bool main(){bool flag; int x; flag = true; x = 5; return flag;}" | ./compiler
echo

echo "=== MODO INTERACTIVO ==="
echo "El compilador está listo. Puedes escribir programas interactivamente:"
echo "Ejemplo: int main(){int x; x = 5; return x;}"
echo "Presiona Ctrl+C para salir"
echo
./compiler
