FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget curl zip git python3 python3-pip \
    build-essential libc6-dev unzip

RUN wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# Configuration des environnements pour Go
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Installation des outils Go
RUN go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/sensepost/gowitness@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Copie du fichier .env dans l'image Docker
COPY .env /app/.env

# Définir le répertoire de travail
WORKDIR /app

COPY . .
RUN pip3 install -r requirements.txt --break-system-packages

# Exposer le port sur lequel Flask va tourner
EXPOSE 5000

# Définir la variable d'environnement FLASK_APP
ENV FLASK_APP=app.py

# Commande pour démarrer Flask
CMD ["flask", "run", "--host=0.0.0.0"]
