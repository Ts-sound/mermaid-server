# This stage builds the go executable.
FROM golang:1.19.3-buster as go

WORKDIR /root
COPY ./ ./

RUN go build -o bin/app cmd/app/main.go


# Final stage that will be pushed.
FROM debian:buster-slim

FROM node:18.10.0-buster-slim as node

WORKDIR /root

# copy the mermaidcli node package into the container and install
# COPY ./mermaidcli/* ./

RUN npm install -g @mermaid-js/mermaid-cli@11.12.0 

ENV DEBIAN_FRONTEND=noninteractive

# adjust debian sources to use archive.debian.org for old releases
RUN sed -i 's/http:\/\/[^\/]*\/debian/http:\/\/archive.debian.org\/debian/g' /etc/apt/sources.list && \
  sed -i 's/https:\/\/[^\/]*\/debian/http:\/\/archive.debian.org\/debian/g' /etc/apt/sources.list
RUN apt update 2>/dev/null  

RUN apt install -y --no-install-recommends \
    openssh-server \
    ca-certificates \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libxcb-dri3-0 \
    libgbm1 \
    ca-certificates \
    fonts-liberation \
    libappindicator1 \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    libxshmfence1 \
    2>/dev/null && rm -rf /var/lib/apt/lists/*;

COPY --from=go /root/bin/app ./app
COPY ./mermaidcli/puppeteer-config.json ./

RUN mkdir -p ./in
RUN mkdir -p ./out
RUN chmod 0777 ./in
RUN chmod 0777 ./out

CMD ["./app", "--allow-all-origins=true", "--mermaid=./node_modules/.bin/mmdc", "--in=./in", "--out=./out", "--puppeteer=./puppeteer-config.json"]

