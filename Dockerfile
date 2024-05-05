FROM debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget git python3 python3-pip \
    build-essential libc6-dev unzip

RUN wget https://golang.org/dl/go1.22.0.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz

# Configuration des environnements pour Go
ENV GOPATH=/root/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Téléchargement et installation de Amass
# RUN wget https://github.com/owasp-amass/amass/releases/download/v3.19.3/amass_linux_amd64.zip \
#     && unzip amass_linux_amd64.zip \
#     && cd amass_linux_amd64 \
#     && mv amass /app/scripts/

# Installation des autres outils Go
RUN go install github.com/tomnomnom/assetfinder@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/sensepost/gowitness@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Copie du fichier .env dans l'image Docker
COPY .env /app/.env

# Installation de Shodan en utilisant la clé API du fichier .env
RUN pip3 install shodan --break-system-packages && \
    export $(cat /app/.env | xargs) && \
    shodan init $SHODAN_KEY

# Installation de Flask
RUN pip3 install flask --break-system-packages

# Définir le répertoire de travail
WORKDIR /app

# Exposer le port sur lequel Flask va tourner
EXPOSE 5000

# Commande pour démarrer Flask
CMD ["flask", "run", "--host=0.0.0.0", "--debug"]
