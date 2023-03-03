#!/bin/bash

# Comprobar si se ha pasado un argumento
if [ $# -eq 0 ]; then
    read -p "Introduce el nombre del paquete: " package
else
    package=$1
fi

# Asignar el nombre del paquete al parámetro correspondiente
paquete=$1

# Comprobar si el paquete está instalado
if ! dpkg -s $paquete >/dev/null 2>&1; then
    # Si el paquete no está instalado, comprobar se puede instalar
    if apt-cache show $paquete >/dev/null 2>&1; then
        echo "El paquete $paquete está disponible para instalar"
        read -p "¿Desea instalar el paquete $paquete? (s/n): " respuesta
        if [ "$respuesta" = "s" ]; then
            sudo apt-get install $paquete
        else
            exit 0
        fi
    else
        # Si el paquete no existe en los repositorios, mostrar resultados de búsqueda
        echo "No se encontró el paquete $paquete en los repositorios."
        apt-cache search $paquete
    fi
else
    # Si el paquete está instalado, mostrar opciones disponibles
    while true; do
        echo "El paquete $paquete está instalado."
        echo "1. Mostrar su versión"
        echo "2. Reinstalarlo"
        echo "3. Actualizarlo (solo este paquete, si fuera actualizable)"
        echo "4. Eliminarlo (guardando la configuración)"
        echo "5. Eliminarlo totalmente"
        echo "0. Salir"
        read -p "Introduce una opción: " opcion
        case $opcion in
            1)
                dpkg -s $paquete | grep -E "^Version:" | cut -c 10-
                ;;
            2)
                sudo apt-get --reinstall install $paquete
                ;;
            3)
                if apt-cache policy $paquete | grep -E "Installed:.*none" >/dev/null; then
                    echo "El paquete $paquete no está instalado o no tiene una versión actualizable."
                else
                    sudo apt-get install --only-upgrade $paquete
                fi
                ;;
            4)
                sudo apt-get remove $paquete
                ;;
            5)
                sudo apt-get --purge remove $paquete
                ;;
            0)
                exit 0
                ;;
            *)
                echo "Opción inválida. Introduce una opción del 0 al 5."
                ;;
        esac
    done
fi