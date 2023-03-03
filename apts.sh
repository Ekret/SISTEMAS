#!/bin/bash

# Comprobar si se ha proporcionado el nombre del paquete como argumento
if [ $# -eq 0 ]; then
    read -p "Introduce el nombre del paquete: " package
else
    package=$1
fi

# Sincronizar el listado de software local
sudo apt update

# Comprobar si el paquete está instalado
if dpkg -s "$package" >/dev/null 2>&1; then
    echo "El paquete $package ya está instalado en el sistema."
else
    # Buscar el paquete en los repositorios
    if apt-cache show "$package" >/dev/null 2>&1; then
        echo "Información del paquete $package:"
        apt-cache show "$package"
        read -p "¿Quieres instalar el paquete $package? (y/n): " install_package
        if [ "$install_package" = "y" ]; then
            sudo apt install "$package"
        else
            echo "No se ha instalado el paquete $package."
        fi
    else
        echo "El paquete $package no se ha encontrado en los repositorios."
        echo "Resultado de la búsqueda de paquetes con el nombre $package:"
        apt search "$package"
    fi
fi
