#!/bin/bash

# Validar el nombre del paquete
while true; do
  read -p "Introduce el nombre del paquete: " package
  if apt-cache show "$package" >/dev/null 2>&1; then
    break
  else
    echo "El nombre del paquete no es válido. Por favor, inténtelo de nuevo."
  fi
done

# Sincronizar el listado de software local y manejar errores
if ! sudo apt update; then
  echo "Error al actualizar el listado de software. Saliendo."
  exit 1
fi

# Comprobar si el paquete está instalado
if dpkg -s "$package" >/dev/null 2>&1; then
  echo "El paquete $package ya está instalado en el sistema."
else
  # Mostrar información detallada del paquete
  echo "Información del paquete $package:"
  apt-cache show "$package"
  
  # Permitir al usuario ver dependencias del paquete
  read -p "¿Desea ver las dependencias del paquete? (s/n): " show_deps
  if [[ "$show_deps" == "s" ]]; then
    apt-cache depends "$package"
  fi
  
  # Preguntar al usuario si desea instalar el paquete
  read -p "¿Desea instalar el paquete $package? (s/n): " install_package
  if [[ "$install_package" == "s" ]]; then
    # Instalar el paquete y manejar errores
    if ! sudo apt install "$package"; then
      echo "Error al instalar el paquete $package. Saliendo."
      exit 1
    fi
    echo "El paquete $package se ha instalado correctamente."
  else
    echo "No se ha instalado el paquete $package."
  fi
fi
