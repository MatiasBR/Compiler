#!/bin/bash

echo "=== CONFIGURANDO COMPILADOR PARA UBUNTU ==="
echo

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update

# Instalar herramientas necesarias
echo "Instalando herramientas de desarrollo..."
sudo apt install -y build-essential flex bison

# Verificar instalaciones
echo
echo "=== VERIFICANDO INSTALACIONES ==="
echo "GCC version:"
gcc --version | head -1

echo "Flex version:"
flex --version

echo "Bison version:"
bison --version | head -1

echo "Make version:"
make --version | head -1

echo
echo "=== COMPILANDO EL PROYECTO ==="
make clean
make

if [ $? -eq 0 ]; then
    echo "¡Compilación exitosa!"
    echo
    echo "=== EJECUTANDO PRUEBAS ==="
    make test
else
    echo "Error en la compilación. Verificando archivos..."
    ls -la
fi

echo
echo "=== USO ==="
echo "Para ejecutar el compilador:"
echo "  ./compiler"
echo
echo "Para probar con archivos:"
echo "  echo 'int main(){int x; x=5; return x;}' | ./compiler"
echo "  cat test1.txt | ./compiler"
echo
echo "Para ejecutar todas las pruebas:"
echo "  make test"
