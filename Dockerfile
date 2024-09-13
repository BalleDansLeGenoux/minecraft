# Étape 1: Préparer l'image de base
FROM ubuntu:20.04 AS builder

# Configurer les paramètres non interactifs pour l'installation
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    mingw-w64 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Configurer le fuseau horaire
ENV TZ=America/New_York

# Créer un répertoire pour l'application
WORKDIR /app

# Copier le code source et les dépendances dans le conteneur
COPY . .

# Configurer et compiler le projet pour Windows
RUN mkdir -p build && cd build && \
    cmake -DCMAKE_TOOLCHAIN_FILE=/usr/share/cmake-3.16/Modules/Platform/Windows.cmake .. && \
    cmake --build . --config Release

# Étape 2: Préparer l'image finale
FROM ubuntu:20.04 AS runtime

# Copier le binaire de l'image de construction
COPY --from=builder /app/build/Release/myapp.exe /app/myapp.exe

# Définir le point d'entrée du conteneur
ENTRYPOINT ["/app/myapp.exe"]
