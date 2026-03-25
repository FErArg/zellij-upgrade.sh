#!/bin/bash
fecha="$(date +%Y%m%d-%H%M)"

# URL de la API de GitHub para obtener la última versión de Zellij
API_URL="https://api.github.com/repos/zellij-org/zellij/releases/latest"

# Archivo para guardar la versión actual
current_version=$(zellij --version) #zellij 0.44.0
current_version=$(echo $current_version | sed 's/zellij //')

# Función para obtener la última versión del repositorio
get_latest_version() {
    curl -s $API_URL | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Obtener la última versión del repositorio
latest_version=$(get_latest_version)
latest_version=$(echo $latest_version | sed 's/v//')

# Comparar las versiones
if [ "$latest_version" != "$current_version" ]; then
    echo "Nueva versión disponible: $latest_version"
    cd /tmp
    wget https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz
    tar xvzf zellij-x86_64-unknown-linux-musl.tar.gz
    rm zellij-x86_64-unknown-linux-musl.tar.gz
    # crea backup por si el archivo descargado tiene errores o no funciona
    mv ~/.local/bin/zellij /home/ferarg/.local/bin/zellij-$fecha
    mv /tmp/zellij ~/.local/bin/
    chmod +x ~/.local/bin/zellij
else
    echo "No hay actualizaciones disponibles. Versión actual: $current_version"
fi
