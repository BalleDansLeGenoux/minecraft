# Étape 1: Préparer l'image de base
FROM ubuntu:20.04 AS builder

# Installer les outils nécessaires pour la compilation croisée
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    mingw-w64 \
    && rm -rf /var/lib/apt/lists/*

# Créer un répertoire pour l'application
WORKDIR /app

# Copier le code source et les dépendances dans le conteneur
COPY . .

# Configurer et compiler le projet pour Windows
RUN mkdir -p build && cd build && \
    cmake -DCMAKE_TOOLCHAIN_FILE=/usr/share/cmake-3.16/Modules/Platform/Windows.cmake .. && \
    cmake --build . --config Release

# Étape 2: Créer un répertoire final pour les artefacts
FROM ubuntu:20.04 AS runtime

# Copier le binaire de l'image de construction
COPY --from=builder /app/build/Release/myapp.exe /app/myapp.exe

# Définir le point d'entrée du conteneur
ENTRYPOINT ["/app/myapp.exe"]
