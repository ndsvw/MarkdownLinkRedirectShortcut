
FROM clowa/powershell-core:latest

SHELL ["/bin/sh", "-c"]

RUN apt update

# required later:
RUN apt install -y curl

RUN apt update
RUN apt install -y openssh-server

# node
ENV NODE_VERSION=18.20.5
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

WORKDIR /bindir
COPY . .
RUN npm install

WORKDIR /workdir

ENTRYPOINT ["pwsh", "/bindir/main.ps1"]