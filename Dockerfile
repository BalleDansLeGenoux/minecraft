# Étape 1: Construire le binaire dans une image intermédiaire
FROM golang:1.20 AS builder

# Créer un répertoire pour l'application
WORKDIR /app

# Copier le code source dans le conteneur
COPY . .

# Construire le binaire statique
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp .

# Étape 2: Créer une image finale avec le binaire autonome
FROM scratch

# Copier le binaire de l'image de construction
COPY --from=builder /app/myapp /bin/myapp

# Définir le point d'entrée du conteneur
ENTRYPOINT ["/bin/myapp"]

