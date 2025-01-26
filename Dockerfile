# Dockerfile
FROM ubuntu:20.04

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk wget curl fuse && \
    apt-get clean

# Instalar rclone (para Google Drive)
RUN curl https://rclone.org/install.sh | bash

# Instalar Ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && \
    apt-get install -y ngrok

# Crear un directorio para el servidor de Minecraft
RUN mkdir /minecraft
WORKDIR /minecraft

# Descargar el servidor de Mohist (usando el enlace proporcionado)
RUN wget https://mohistmc.com/api/v2/projects/mohist/1.20.1/builds/923/download -O mohist-server.jar

# Aceptar el EULA de Minecraft
RUN echo "eula=true" > eula.txt

# Copiar el archivo .env al contenedor
COPY .env /minecraft/.env

# Copiar el script de inicio
COPY start-server.sh /minecraft/start-server.sh
RUN chmod +x /minecraft/start-server.sh

# Comando para iniciar el servidor
CMD ["./start-server.sh"]