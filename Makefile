# Makefile

# Variables
DOCKER_IMAGE_NAME = minecraft-server
CONTAINER_NAME = minecraft-server-container

# Comandos
.PHONY: build start stop clean url

# Construir la imagen de Docker
build:
	docker build -t $(DOCKER_IMAGE_NAME) .

# Iniciar el servidor de Minecraft
start:
	docker run -d --name $(CONTAINER_NAME) -p 25565:25565 $(DOCKER_IMAGE_NAME)

# Detener el servidor de Minecraft
stop:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

# Limpiar la imagen y el contenedor
clean:
	docker rmi $(DOCKER_IMAGE_NAME)
	docker rm -f $(CONTAINER_NAME)

# Mostrar la URL de Ngrok
url:
	docker exec $(CONTAINER_NAME) curl --silent http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'