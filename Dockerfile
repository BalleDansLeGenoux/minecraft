# Utiliser une image de base avec g++ et les bibliothèques de développement nécessaires
FROM ubuntu:22.04

# Installer les dépendances
RUN apt-get update && apt-get install -y \
    g++ \
    libglfw3-dev \
    libglew-dev \
    libglu1-mesa-dev \
    mesa-common-dev \
    libxrandr-dev \
    libxxf86vm-dev \
    libxi-dev \
    libxinerama-dev \
    libx11-dev \
    && apt-get clean

# Définir le répertoire de travail
WORKDIR /app

# Copier le code source dans le conteneur
COPY . .

# Commande pour compiler le projet
RUN g++ $(find src/ -name '*.cpp') -o bin/progGL -Iinclude -Ilib -L./lib -lglfw -lGLEW -lGLU -lGL -lXrandr -lXxf86vm -lXi -lXinerama -lX11 -lrt -ldl

# Définir la commande par défaut pour exécuter le programme
CMD ["./bin/progGL"]
