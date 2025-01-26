#!/bin/bash

# Cargar variables de entorno desde .env
set -a
source .env
set +a

# Autenticar Ngrok
ngrok authtoken $NGROK_TOKEN

# Iniciar Ngrok en segundo plano (para el puerto 25565)
ngrok tcp 25565 &

# Esperar unos segundos para que Ngrok se inicie
sleep 5

# Mostrar la URL de Ngrok
echo "Ngrok está corriendo. La URL pública es:"
curl --silent http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'

# Configurar rclone
mkdir -p /root/.config/rclone
echo "$RCLONE_CONFIG" > /root/.config/rclone/rclone.conf

# Montar Google Drive
mkdir -p /minecraft/gdrive
rclone mount gdrive: /minecraft/gdrive --daemon

# Sincronizar datos con Google Drive
rsync -av /minecraft/ /minecraft/gdrive/minecraft-server/

# Iniciar el servidor de Minecraft
java -Xmx1024M -Xms1024M -jar mohist-server.jar nogui

# Al finalizar, sincronizar los datos de nuevo con Google Drive
rsync -av /minecraft/ /minecraft/gdrive/minecraft-server/