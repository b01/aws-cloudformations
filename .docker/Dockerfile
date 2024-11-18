ARG USER_NAME='app'
ARG USER_UID='1000'
ARG USER_GID='1000'
ARG USER_GROUP='app_users'
ARG REPO='github.com/b01/aws-cloudformations'
ARG WD="/home/${USER_NAME}/src/${REPO}"

FROM python:3.12-slim-bookworm AS base

ARG USER_NAME
ARG USER_UID
ARG USER_GID
ARG USER_GROUP
ARG REPO
ARG WD

WORKDIR /tmp

# Perform a system update and install packages.
RUN apt-get update \
 && apt-get --purge install -y --upgrade \
    awscli \
    curl \
    ca-certificates \
    less \
    openssl \
    sudo \
    tree \
    zip \
 && rm -vrf /var/cache/apt/* \
 && rm -rf /var/lib/apt/lists/*

RUN pip install boto3

COPY --chmod=+x .docker/start.sh /usr/local/bin

HEALTHCHECK --interval=5m --timeout=3s \
  CMD echo "healthy" || exit 1

ENTRYPOINT [ "start.sh" ]

# Add a non-root group and user to runas
RUN addgroup --gid ${USER_GID} ${USER_GROUP} \
 && adduser --disabled-password \
    --ingroup ${USER_GROUP} \
    --uid ${USER_UID} \
    ${USER_NAME}

# Add the user to the docker and sudo groups.
RUN usermod -aG sudo ${USER_NAME} \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN curl -LO https://raw.githubusercontent.com/b01/make-aws-lambda-layer/refs/heads/main/make-lambda-layer.sh \
 && chmod +x make-lambda-layer.sh \
 && mv make-lambda-layer.sh /usr/local/bin \
 && make-lambda-layer.sh -h

USER ${USER_NAME}

RUN curl -LO https://raw.githubusercontent.com/b01/dl-vscode-server/refs/tags/0.2.1/download-vs-code.sh \
 && chmod +x download-vs-code.sh \
 && ./download-vs-code.sh "linux" "x64"

LABEL purpose="education,learning,training"
LABEL owner="Khalifah Khalil Shabazz (b01)"
LABEL description="AWS CloudFormartion templates by b01"
LABEL apps="aws cli, python"
